import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('offline vocabulary has 1000 complete unique entries', () async {
    final source = await File('assets/vocabulary.json').readAsString();
    final root = jsonDecode(source) as Map<String, dynamic>;
    final rows = root['entries'] as List<dynamic>;
    expect(root['count'], 1000);
    expect(rows, hasLength(1000));

    final words = <String>{};
    final errors = <String>[];
    const levels = {'A1', 'A2', 'B1', 'B2', 'C1', 'C2'};
    for (var index = 0; index < rows.length; index++) {
      final value = rows[index];
      final row = value as Map<String, dynamic>;
      final word = row['word'];
      if (word is! String || word.trim().isEmpty) {
        errors.add('entry ${index + 1}: missing word');
        continue;
      }
      for (final key in [
        'word',
        'translation',
        'partOfSpeech',
        'level',
        'ipa',
        'example',
        'exampleUz',
      ]) {
        final field = row[key];
        if (field is! String || field.trim().isEmpty) {
          errors.add('entry ${index + 1}: empty $key');
        }
      }
      if (!words.add(word.toLowerCase())) {
        errors.add('entry ${index + 1}: duplicate $word');
      }
      if (!levels.contains(row['level'])) {
        errors.add('entry ${index + 1}: invalid CEFR level');
      }
      final ipa = row['ipa'];
      if (ipa is String && !(ipa.startsWith('/') && ipa.endsWith('/'))) {
        errors.add('entry ${index + 1}: IPA needs slash delimiters');
      }
      final example = row['example'];
      if (example is String &&
          !RegExp(
            '\\b${RegExp.escape(word)}\\b',
            caseSensitive: false,
          ).hasMatch(example)) {
        errors.add('entry ${index + 1}: example does not contain $word');
      }
    }
    expect(words, hasLength(1000));
    expect(errors, isEmpty, reason: errors.take(20).join('\n'));
  });
}
