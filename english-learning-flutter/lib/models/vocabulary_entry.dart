class VocabularyEntry {
  const VocabularyEntry({
    required this.word,
    required this.translation,
    required this.partOfSpeech,
    required this.level,
    required this.ipa,
    required this.example,
    required this.exampleUz,
  });

  final String word;
  final String translation;
  final String partOfSpeech;
  final String level;
  final String ipa;
  final String example;
  final String exampleUz;

  factory VocabularyEntry.fromJson(Map<String, dynamic> json) {
    return VocabularyEntry(
      word: json['word'] as String,
      translation: json['translation'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      level: json['level'] as String,
      ipa: json['ipa'] as String,
      example: json['example'] as String,
      exampleUz: json['exampleUz'] as String,
    );
  }

  bool matches(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    return '$word $translation $partOfSpeech $example $exampleUz'
        .toLowerCase()
        .contains(needle);
  }
}
