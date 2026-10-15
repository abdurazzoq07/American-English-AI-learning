#!/usr/bin/env python3
"""Build the bundled English–Uzbek learner lexicon from a public frequency list.

Requires OPENAI_API_BASE and OPENAI_API_KEY only for regeneration. The app itself
ships with the generated JSON and works offline.
"""
from __future__ import annotations
import json
import os
import re
import sys
import time
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSET = ROOT / "assets" / "vocabulary.json"
WORDS_URL = "https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english.txt"
MODEL = os.getenv("VOCAB_MODEL", "gpt-5-mini")
BATCH = 40

SYSTEM = """You are an experienced English–Uzbek vocabulary editor. Return only a JSON object with key entries. For every given English headword, preserve it exactly and give: translation (natural concise Uzbek in Latin script, main learner-relevant sense; alternatives separated with ;), partOfSpeech (short English label), level (A1/A2/B1/B2/C1/C2; approximate CEFR), ipa (standard General American IPA between /slashes/), example (one natural short English sentence containing the exact headword in lowercase, ideally 5–12 words), exampleUz (accurate Uzbek Latin translation). Avoid invented definitions, proper names, and transliteration in place of Uzbek. Make all items distinct and learner-friendly. Do not omit any input word."""


def request_batch(words: list[str]) -> list[dict]:
    base = os.environ["OPENAI_API_BASE"].rstrip("/")
    key = os.environ["OPENAI_API_KEY"]
    schema = {
        "type": "json_schema",
        "json_schema": {
            "name": "english_uzbek_vocabulary",
            "strict": True,
            "schema": {
                "type": "object", "additionalProperties": False,
                "required": ["entries"],
                "properties": {"entries": {"type": "array", "items": {
                    "type": "object", "additionalProperties": False,
                    "required": ["word", "translation", "partOfSpeech", "level", "ipa", "example", "exampleUz"],
                    "properties": {
                        "word": {"type": "string"}, "translation": {"type": "string"},
                        "partOfSpeech": {"type": "string"}, "level": {"type": "string"},
                        "ipa": {"type": "string"}, "example": {"type": "string"},
                        "exampleUz": {"type": "string"}
                    }
                }}}
            }
        }
    }
    payload = {
        "model": MODEL,
        "messages": [
            {"role": "system", "content": SYSTEM},
            {"role": "user", "content": "Create an entry for every word, in this exact order:\n" + ", ".join(words)},
        ],
        "response_format": schema,
        "max_completion_tokens": 18000,
    }
    req = urllib.request.Request(
        base + "/chat/completions", data=json.dumps(payload).encode(),
        headers={"Authorization": "Bearer " + key, "Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=180) as response:
        body = json.loads(response.read())
    message = body["choices"][0]["message"]
    text = message.get("content")
    if not text:
        raise RuntimeError("Model returned no content: " + str({k: v for k, v in message.items() if k != "refusal"})[:500])
    obj = json.loads(text)
    return obj["entries"]


def main() -> None:
    if not os.getenv("OPENAI_API_KEY") or not os.getenv("OPENAI_API_BASE"):
        raise SystemExit("OPENAI_API_BASE va OPENAI_API_KEY yo‘q; mavjud vocabulary.json saqlanadi.")
    raw = urllib.request.urlopen(WORDS_URL, timeout=45).read().decode("utf-8").splitlines()
    words = []
    seen = set()
    for line in raw:
        word = line.strip().lower()
        if re.fullmatch(r"[a-z]+", word) and word not in seen:
            seen.add(word)
            words.append(word)
        if len(words) == 1000:
            break
    if len(words) != 1000:
        raise SystemExit(f"Manbadan 1000 so‘z chiqarmadi: {len(words)}")

    ASSET.parent.mkdir(parents=True, exist_ok=True)
    entries: list[dict] = []
    for start in range(0, len(words), BATCH):
        batch = words[start:start+BATCH]
        error = None
        for attempt in range(3):
            try:
                answer = request_batch(batch)
                indexed = {str(x.get("word", "")).lower(): x for x in answer}
                if len(indexed) != len(batch) or any(w not in indexed for w in batch):
                    raise ValueError("model omitted/duplicated a supplied headword")
                entries.extend(indexed[w] for w in batch)
                error = None
                break
            except Exception as exc:  # retry transient API/JSON failures
                error = exc
                time.sleep(2 ** attempt)
        if error:
            raise RuntimeError(f"Batch {start+1}–{start+len(batch)} failed: {error}")
        # Save each batch checkpoint for inspection; only the final path is an app asset.
        tmp = ASSET.with_suffix(".partial.json")
        tmp.write_text(json.dumps({"source": WORDS_URL, "generatedWith": MODEL, "entries": entries}, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"Tayyor: {len(entries)}/1000 so‘z", flush=True)

    valid_levels = {"A1", "A2", "B1", "B2", "C1", "C2"}
    required = ("word", "translation", "partOfSpeech", "level", "ipa", "example", "exampleUz")
    for i, row in enumerate(entries, 1):
        for field in required:
            if not isinstance(row.get(field), str) or not row[field].strip():
                raise ValueError(f"{i}-qator: {field} maydoni bo‘sh")
        if row["level"] not in valid_levels:
            raise ValueError(f"{i}-qator: CEFR darajasi noto‘g‘ri: {row['level']}")
        if row["word"].lower() != words[i-1]:
            raise ValueError(f"{i}-qator: headword mos kelmadi")
        if re.search(rf"\b{re.escape(words[i-1])}\b", row["example"], flags=re.IGNORECASE) is None:
            raise ValueError(f"{i}-qator: example jumlasida headword yo‘q")
        if not (row["ipa"].startswith("/") and row["ipa"].endswith("/")):
            raise ValueError(f"{i}-qator: IPA slashlari noto‘g‘ri")
    if len({x["word"].lower() for x in entries}) != 1000:
        raise ValueError("duplicate words detected")
    result = {"source": WORDS_URL, "sourceDescription": "Google Trillion Word Corpus asosidagi first20hours/google-10000-english frequency list; Uzbek translations, IPA, CEFR and examples are generated and checked for schema/order/uniqueness.", "generatedWith": MODEL, "count": len(entries), "entries": entries}
    ASSET.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    ASSET.with_suffix(".partial.json").unlink(missing_ok=True)
    print(f"VALID: {ASSET} ({len(entries)} ta noyob, to‘liq entry)", flush=True)


if __name__ == "__main__":
    main()
