import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../theme.dart';
import '../models/vocabulary_entry.dart';
import '../services/learning_store.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});
  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  late final Future<List<VocabularyEntry>> _load = _loadWords();
  final _search = TextEditingController();
  final _tts = FlutterTts();
  String _level = 'Barchasi';
  bool _favoritesOnly = false;

  Future<List<VocabularyEntry>> _loadWords() async {
    final raw = await rootBundle.loadString('assets/vocabulary.json');
    final root = jsonDecode(raw) as Map<String, dynamic>;
    return (root['entries'] as List<dynamic>)
        .map((item) => VocabularyEntry.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  void dispose() {
    _search.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(.43);
      await _tts.speak(text);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: LText('Qurilmada inglizcha ovoz topilmadi.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<VocabularyEntry>>(
    future: _load,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError || !snapshot.hasData) {
        return const Center(
          child: LText('Lug‘atni ochib bo‘lmadi. Ilovani qayta build qiling.'),
        );
      }
      final all = snapshot.data!;
      return AnimatedBuilder(
        animation: LearningStore.instance,
        builder: (context, _) {
          final store = LearningStore.instance;
          final shown = all
              .where(
                (entry) =>
                    entry.matches(_search.text) &&
                    (_level == 'Barchasi' || entry.level == _level) &&
                    (!_favoritesOnly ||
                        store.favoriteWords.contains(entry.word)),
              )
              .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
                child: Column(
                  children: [
                    TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: tr(context, 'So‘z yoki tarjimani qidiring'),
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _search.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _search.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: LText(
                            '${shown.length} / ${all.length} ta so‘z',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        FilterChip(
                          selected: _favoritesOnly,
                          onSelected: (value) =>
                              setState(() => _favoritesOnly = value),
                          avatar: Icon(
                            _favoritesOnly
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: _favoritesOnly
                                ? const Color(0xFFD15F61)
                                : null,
                          ),
                          label: const LText('Sevimlilar'),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _level,
                          underline: const SizedBox.shrink(),
                          items:
                              const [
                                    'Barchasi',
                                    'A1',
                                    'A2',
                                    'B1',
                                    'B2',
                                    'C1',
                                    'C2',
                                  ]
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: LText(v),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) =>
                              setState(() => _level = value ?? 'Barchasi'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: shown.isEmpty
                    ? const Center(child: LText('Mos so‘z topilmadi.'))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final entry = shown[index];
                          final favorite = store.favoriteWords.contains(
                            entry.word,
                          );
                          final learned = store.learnedWords.contains(
                            entry.word,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(17),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: LText(
                                                      entry.word,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                            fontSize: 22,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 9),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: mintFor(context),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            9,
                                                          ),
                                                    ),
                                                    child: LText(
                                                      entry.level,
                                                      style: const TextStyle(
                                                        color: deepTeal,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              LText(
                                                '${entry.ipa}  ·  ${entry.partOfSpeech}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: tr(
                                            context,
                                            'Ovozni tinglash',
                                          ),
                                          onPressed: () => _speak(entry.word),
                                          icon: const Icon(
                                            Icons.volume_up_rounded,
                                            color: deepTeal,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: favorite
                                              ? tr(context, 'Sevimlidan olish')
                                              : tr(
                                                  context,
                                                  'Sevimliga qo‘shish',
                                                ),
                                          onPressed: () =>
                                              store.toggleFavorite(entry.word),
                                          icon: Icon(
                                            favorite
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            color: favorite
                                                ? const Color(0xFFD15F61)
                                                : const Color(0xFF758286),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    LText(
                                      entry.translation,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: inkFor(context),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    LText(
                                      entry.example,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    LText(
                                      entry.exampleUz,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(height: 9),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: learned
                                            ? null
                                            : () =>
                                                  store.markLearned(entry.word),
                                        icon: Icon(
                                          learned
                                              ? Icons.check_circle_rounded
                                              : Icons
                                                    .check_circle_outline_rounded,
                                          size: 18,
                                        ),
                                        label: LText(
                                          learned ? 'O‘rganildi' : 'O‘rgandim',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      );
    },
  );
}
