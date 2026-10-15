import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningStore extends ChangeNotifier {
  LearningStore._();
  static final LearningStore instance = LearningStore._();

  late SharedPreferences _preferences;
  bool _ready = false;
  Set<String> learnedWords = <String>{};
  Set<String> favoriteWords = <String>{};
  Set<int> completedLessons = <int>{};
  int completedSessions = 0;
  int pronunciationAttempts = 0;
  int correctPronunciations = 0;
  int quizCorrect = 0;
  int quizAttempts = 0;
  int studyMinutes = 0;
  final List<String> _activeDays = <String>[];

  bool get isReady => _ready;
  int get activeDays => _activeDays.length;
  double get pronunciationAccuracy => pronunciationAttempts == 0
      ? 0
      : correctPronunciations / pronunciationAttempts;
  double get quizAccuracy => quizAttempts == 0 ? 0 : quizCorrect / quizAttempts;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    learnedWords = (_preferences.getStringList('learned_words') ?? <String>[])
        .toSet();
    favoriteWords = (_preferences.getStringList('favorite_words') ?? <String>[])
        .toSet();
    completedLessons =
        (_preferences.getStringList('completed_lessons') ?? <String>[])
            .map(int.tryParse)
            .whereType<int>()
            .toSet();
    completedSessions = _preferences.getInt('completed_sessions') ?? 0;
    pronunciationAttempts = _preferences.getInt('pronunciation_attempts') ?? 0;
    correctPronunciations = _preferences.getInt('correct_pronunciations') ?? 0;
    quizCorrect = _preferences.getInt('quiz_correct') ?? 0;
    quizAttempts = _preferences.getInt('quiz_attempts') ?? 0;
    studyMinutes = _preferences.getInt('study_minutes') ?? 0;
    _activeDays
      ..clear()
      ..addAll(_preferences.getStringList('active_days') ?? <String>[]);
    _ready = true;
    notifyListeners();
  }

  Future<void> toggleFavorite(String word) async {
    if (!favoriteWords.add(word)) favoriteWords.remove(word);
    await _preferences.setStringList('favorite_words', favoriteWords.toList());
    notifyListeners();
  }

  Future<void> markLearned(String word) async {
    learnedWords.add(word);
    await _preferences.setStringList('learned_words', learnedWords.toList());
    _touchDay();
    notifyListeners();
  }

  Future<void> markLessonComplete(int lessonIndex) async {
    completedLessons.add(lessonIndex);
    await _preferences.setStringList(
      'completed_lessons',
      completedLessons.map((value) => value.toString()).toList(),
    );
    _touchDay();
    notifyListeners();
  }

  Future<void> recordSession({int minutes = 5}) async {
    completedSessions++;
    studyMinutes += minutes;
    _touchDay();
    await _preferences.setInt('completed_sessions', completedSessions);
    await _preferences.setInt('study_minutes', studyMinutes);
    await _saveDays();
    notifyListeners();
  }

  Future<void> recordPronunciation({required bool closeMatch}) async {
    pronunciationAttempts++;
    if (closeMatch) correctPronunciations++;
    await _preferences.setInt('pronunciation_attempts', pronunciationAttempts);
    await _preferences.setInt('correct_pronunciations', correctPronunciations);
    _touchDay();
    notifyListeners();
  }

  Future<void> recordQuiz({required bool correct}) async {
    quizAttempts++;
    if (correct) quizCorrect++;
    await _preferences.setInt('quiz_attempts', quizAttempts);
    await _preferences.setInt('quiz_correct', quizCorrect);
    _touchDay();
    notifyListeners();
  }

  void _touchDay() {
    final now = DateTime.now();
    final key =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (!_activeDays.contains(key)) {
      _activeDays.add(key);
      if (_activeDays.length > 90) _activeDays.removeAt(0);
      _saveDays();
    }
  }

  Future<void> _saveDays() async =>
      _preferences.setStringList('active_days', _activeDays);
}
