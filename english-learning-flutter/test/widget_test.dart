// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:inglizcha/models/vocabulary_entry.dart';

void main() {
  test('vocabulary entry parses and searches Uzbek translation', () {
    final entry = VocabularyEntry.fromJson({
      'word': 'apple',
      'translation': 'olma',
      'partOfSpeech': 'noun',
      'level': 'A1',
      'ipa': '/ˈæpəl/',
      'example': 'I eat an apple.',
      'exampleUz': 'Men olma yeyman.',
    });

    expect(entry.word, 'apple');
    expect(entry.matches('olma'), isTrue);
    expect(entry.matches('banana'), isFalse);
  });
}
