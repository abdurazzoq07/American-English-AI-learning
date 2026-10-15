import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../theme.dart';
import '../models/vocabulary_entry.dart';
import '../services/learning_store.dart';

Future<List<VocabularyEntry>> _readWords() async {
  final raw = await rootBundle.loadString('assets/vocabulary.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return (json['entries'] as List<dynamic>)
      .map((row) => VocabularyEntry.fromJson(row as Map<String, dynamic>))
      .toList(growable: false);
}

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceFor(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              tabs: [
                Tab(
                  icon: const Icon(Icons.mic_none_rounded),
                  text: tr(context, 'Talaffuz'),
                ),
                Tab(
                  icon: const Icon(Icons.quiz_outlined),
                  text: tr(context, 'So‘z testi'),
                ),
              ],
            ),
          ),
        ),
        const Expanded(
          child: TabBarView(
            children: [PronunciationPractice(), VocabularyQuiz()],
          ),
        ),
      ],
    ),
  );
}

class PronunciationPractice extends StatefulWidget {
  const PronunciationPractice({super.key});
  @override
  State<PronunciationPractice> createState() => _PronunciationPracticeState();
}

class _PronunciationPracticeState extends State<PronunciationPractice> {
  late final Future<List<VocabularyEntry>> _words = _readWords();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _speechReady = false;
  bool _listening = false;
  bool _checking = false;
  String _recognized = '';
  String? _feedback;
  bool? _lastCloseMatch;
  int _wordIndex = 24;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final ready = await _speech.initialize(
        onStatus: (status) {
          if (mounted) setState(() => _listening = status == 'listening');
        },
        onError: (_) {
          if (mounted) {
            setState(() {
              _listening = false;
              _feedback = 'Mikrofon ochilmadi. Ruxsatni va mikrofon ulanishini tekshiring.';
            });
          }
        },
      );
      if (mounted) setState(() => _speechReady = ready);
    } catch (_) {
      if (mounted) setState(() => _speechReady = false);
    }
  }

  Future<void> _speak(String phrase) async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(.42);
      await _tts.speak(phrase);
    } catch (_) {
      if (mounted) {
        setState(
          () => _feedback = 'Qurilmada inglizcha ovoz xizmati mavjud emas.',
        );
      }
    }
  }

  Future<void> _startListening() async {
    if (!_speechReady) {
      await _initSpeech();
      if (!_speechReady) {
        if (mounted) {
          setState(
            () => _feedback = 'Bu qurilmada nutqni tanish xizmati yo‘q yoki mikrofonga ruxsat berilmagan.',
          );
        }
        return;
      }
    }
    setState(() {
      _recognized = '';
      _feedback = null;
      _lastCloseMatch = null;
      _listening = true;
    });
    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        listenOptions: stt.SpeechListenOptions(
          localeId: 'en_US',
          listenFor: const Duration(seconds: 8),
          pauseFor: const Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _listening = false;
          _feedback = 'Tinglash ishga tushmadi. Mikrofon ruxsatini tekshiring.';
        });
      }
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => _recognized = result.recognizedWords);
    if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
      _evaluate(result.recognizedWords);
    }
  }

  Future<void> _evaluate(String spoken) async {
    if (_checking) return;
    setState(() => _checking = true);
    final expected = await _currentWord();
    final close = _similarity(spoken, expected) >= .66;
    await LearningStore.instance.recordPronunciation(closeMatch: close);
    if (mounted) {
      setState(() {
        _lastCloseMatch = close;
        _feedback = close
            ? 'Yaxshi! Tizim aytganingizni namunaga yaqin deb topdi.'
            : 'Qayta urinib ko‘ring. Avval namunaviy ovozni tinglab, sekinroq ayting.';
        _checking = false;
      });
    }
  }

  double _similarity(String left, String right) {
    String normalize(String value) => value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z ]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final a = normalize(left);
    final b = normalize(right);
    if (a == b) return 1;
    if (a.isEmpty || b.isEmpty) return 0;
    final previous = List<int>.generate(b.length + 1, (i) => i);
    for (var i = 0; i < a.length; i++) {
      var diagonal = previous[0];
      previous[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final old = previous[j + 1];
        previous[j + 1] = min(
          min(previous[j + 1] + 1, previous[j] + 1),
          diagonal + (a[i] == b[j] ? 0 : 1),
        );
        diagonal = old;
      }
    }
    return 1 - previous[b.length] / max(a.length, b.length);
  }

  Future<String> _currentWord() async {
    final words = await _words;
    return words[_wordIndex % words.length].word;
  }

  Future<void> _next() async {
    final words = await _words;
    if (mounted) {
      setState(() {
        _wordIndex = _random.nextInt(words.length);
        _recognized = '';
        _feedback = null;
        _lastCloseMatch = null;
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<VocabularyEntry>>(
    future: _words,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError || snapshot.data!.isEmpty) {
        return const Center(child: LText('Lug‘at yuklanmadi.'));
      }
      final entry = snapshot.data![_wordIndex % snapshot.data!.length];
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF18323A),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LText(
                        'ESHITING  •  TAKRORLANG',
                        style: TextStyle(
                          color: Color(0xFFB8DED3),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: LText(
                              entry.word,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: Colors.white, fontSize: 35),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _speak(entry.word),
                            tooltip: tr(
                              context,
                              'Inglizcha talaffuzni tinglash',
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: .13,
                              ),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.volume_up_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LText(
                        '${entry.ipa}  ·  ${entry.translation}',
                        style: const TextStyle(color: Color(0xFFC8DBD5)),
                      ),
                      const SizedBox(height: 16),
                      LText(
                        entry.example,
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LText(
                        entry.exampleUz,
                        style: const TextStyle(color: Color(0xFFB8DED3)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: _checking
                        ? null
                        : (_listening ? () => _speech.stop() : _startListening),
                    icon: Icon(
                      _listening ? Icons.stop_rounded : Icons.mic_rounded,
                    ),
                    label: LText(
                      _listening
                          ? 'Tinglashni to‘xtatish'
                          : 'Mikrofonga gapiring',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceFor(context),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LText(
                        _listening ? 'Tinglayapman…' : 'Siz aytgan so‘z',
                        style: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(color: mutedFor(context)),
                      ),
                      const SizedBox(height: 7),
                      LText(
                        _recognized.isEmpty
                            ? '“${entry.word}” deb ayting'
                            : _recognized,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: inkFor(context),
                        ),
                      ),
                      if (_feedback != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _lastCloseMatch == true
                                  ? Icons.check_circle_rounded
                                  : Icons.lightbulb_outline_rounded,
                              color: _lastCloseMatch == true
                                  ? deepTeal
                                  : const Color(0xFFCE8B1B),
                              size: 19,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LText(
                                _feedback!,
                                style: const TextStyle(height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 11),
                OutlinedButton.icon(
                  onPressed: _next,
                  icon: const Icon(Icons.skip_next_rounded),
                  label: const LText('Boshqa so‘z'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: LText(
                    'Baholash nutqni tanish xizmati chiqargan matnni solishtiradi; fonema darajasidagi talaffuz tahlili emas.',
                    style: TextStyle(fontSize: 12, color: mutedFor(context)),
                  ),
                ),
                if (!_speechReady)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: LText(
                      'Nutqni tanish xizmati topilmadi yoki mikrofon ruxsati kerak. Windows qo‘llovi beta holatida.',
                      style: TextStyle(fontSize: 12, color: mutedFor(context)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class VocabularyQuiz extends StatefulWidget {
  const VocabularyQuiz({super.key});
  @override
  State<VocabularyQuiz> createState() => _VocabularyQuizState();
}

class _VocabularyQuizState extends State<VocabularyQuiz> {
  late final Future<List<VocabularyEntry>> _words = _readWords();
  final Random _random = Random();
  int _index = 41;
  List<VocabularyEntry> _options = <VocabularyEntry>[];
  String? _selected;
  bool _answered = false;

  void _makeOptions(List<VocabularyEntry> words) {
    final correct = words[_index % words.length];
    final set = <VocabularyEntry>{correct};
    while (set.length < min(4, words.length)) {
      set.add(words[_random.nextInt(words.length)]);
    }
    _options = set.toList()..shuffle(_random);
  }

  void _answer(VocabularyEntry option, VocabularyEntry current) {
    if (_answered) return;
    final correct = option.word == current.word;
    setState(() {
      _selected = option.word;
      _answered = true;
    });
    LearningStore.instance.recordQuiz(correct: correct);
  }

  void _next(List<VocabularyEntry> words) => setState(() {
    _index = _random.nextInt(words.length);
    _selected = null;
    _answered = false;
    _makeOptions(words);
  });

  @override
  Widget build(BuildContext context) => FutureBuilder<List<VocabularyEntry>>(
    future: _words,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError || snapshot.data!.isEmpty) {
        return const Center(child: LText('Lug‘at yuklanmadi.'));
      }
      final words = snapshot.data!;
      final entry = words[_index % words.length];
      if (_options.isEmpty) _makeOptions(words);
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LText(
                      'SO‘ZNI TOPING',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 1.0,
                        color: deepTeal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: LearningStore.instance,
                      builder: (_, _) => LText(
                        '${LearningStore.instance.quizCorrect} to‘g‘ri',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: mintFor(context),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      LText(
                        'Inglizchasini tanlang',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      LText(
                        entry.translation,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontSize: 27),
                      ),
                      const SizedBox(height: 8),
                      LText(
                        '${entry.partOfSpeech}  ·  ${entry.level}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                ..._options.map((option) {
                  final correctOption = option.word == entry.word;
                  final selected = _selected == option.word;
                  Color? bg;
                  if (_answered && correctOption) bg = const Color(0xFFE0F4E9);
                  if (_answered && selected && !correctOption) {
                    bg = const Color(0xFFFFE7E2);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      color: bg,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _answer(option, entry),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 17,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: LText(
                                  option.word,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                              if (_answered && correctOption)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: deepTeal,
                                ),
                              if (_answered && selected && !correctOption)
                                const Icon(
                                  Icons.cancel_rounded,
                                  color: Color(0xFFD85E4F),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (_answered) ...[
                  const SizedBox(height: 3),
                  LText(
                    entry.example,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 11),
                  FilledButton.icon(
                    onPressed: () => _next(words),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const LText('Keyingi savol'),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}
