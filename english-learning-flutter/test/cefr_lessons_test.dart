import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inglizcha/data/cefr_lessons.dart';
import 'package:inglizcha/l10n/app_localizations.dart';
import 'package:inglizcha/screens/lessons_screen.dart';
import 'package:inglizcha/services/learning_store.dart';
import 'package:inglizcha/theme.dart';

void main() {
  group('CEFR course catalog', () {
    test('covers all six CEFR levels with multiple lessons', () {
      expect(cefrLessons, hasLength(23));
      expect(cefrLevels.map((level) => level.code).toList(), <String>[
        'A1',
        'A2',
        'B1',
        'B2',
        'C1',
        'C2',
      ]);
      for (final level in cefrLevels) {
        expect(
          cefrLessons.where((lesson) => lesson.level == level.code).length,
          greaterThanOrEqualTo(3),
          reason: '${level.code} should contain several lessons',
        );
      }
    });

    test('keeps the original lesson IDs and order for saved progress', () {
      expect(cefrLessons.take(9).map((lesson) => lesson.id).toList(), <int>[
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
      ]);
      expect(
        cefrLessons.take(9).map((lesson) => lesson.title).toList(),
        <String>[
          'Present Simple',
          'To be: am / is / are',
          'Present Continuous',
          'Past Simple',
          'Future: going to',
          'A / an / the',
          'Some / any',
          'Comparatives',
          'Present Perfect',
        ],
      );
    });

    test('every lesson has bilingual examples and a valid exercise answer', () {
      final ids = cefrLessons.map((lesson) => lesson.id).toSet();
      expect(ids.length, cefrLessons.length, reason: 'IDs must be unique');

      final invalid = cefrLessons
          .where((lesson) {
            return lesson.level.isEmpty ||
                lesson.title.isEmpty ||
                lesson.explanation.length < 30 ||
                lesson.pattern.isEmpty ||
                lesson.examples.length < 2 ||
                lesson.examples.any(
                  (example) =>
                      example.english.trim().isEmpty ||
                      example.uzbek.trim().isEmpty,
                ) ||
                lesson.question.trim().isEmpty ||
                !lesson.options.contains(lesson.answer) ||
                lesson.options.toSet().length != lesson.options.length;
          })
          .map((lesson) => '${lesson.id}: ${lesson.title}')
          .toList();

      expect(invalid, isEmpty, reason: 'Invalid lessons: $invalid');
    });

    testWidgets('A1 quiz records a result and completion on a phone layout', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final store = LearningStore.instance;
      await store.init();
      await tester.binding.setSurfaceSize(const Size(430, 900));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('uz'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: buildAppTheme(Brightness.dark),
          home: const Scaffold(body: LessonsScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('A1'), findsOneWidget);
      expect(find.text('C2'), findsOneWidget);

      await tester.tap(find.text('Boshlang‘ich'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Present Simple'));
      await tester.tap(find.text('Present Simple'));
      await tester.pumpAndSettle();
      expect(
        find.text('Men har kuni ingliz tilini o‘rganaman.'),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('studies'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('studies'));
      await tester.pumpAndSettle();
      expect(store.quizAttempts, 1);
      expect(store.quizCorrect, 1);
      await tester.tap(find.text('Darsni tugatdim'));
      await tester.pumpAndSettle();
      expect(store.completedLessons, contains(0));

      await tester.binding.setSurfaceSize(null);
    });
  });
}
