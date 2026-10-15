import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inglizcha/l10n/app_localizations.dart';
import 'package:inglizcha/services/app_preferences.dart';

void main() {
  group('App localization', () {
    test('provides all three selectable interface locales', () {
      expect(
        AppLocalizations.supportedLocales.map((locale) => locale.languageCode),
        containsAll(<String>['en', 'ru', 'uz']),
      );
    });

    test('translates core UI labels and preserves Uzbek copy', () {
      expect(
        AppLocalizations(const Locale('en')).translate('Sozlamalar'),
        'Settings',
      );
      expect(
        AppLocalizations(const Locale('ru')).translate('Sozlamalar'),
        'Настройки',
      );
      expect(
        AppLocalizations(const Locale('uz')).translate('Sozlamalar'),
        'Sozlamalar',
      );
    });

    test('translates dynamic counts and English learning prompts', () {
      expect(
        AppLocalizations(const Locale('en')).translate('12 / 1000 ta so‘z'),
        '12 / 1000 words',
      );
      expect(
        AppLocalizations(const Locale('ru')).translate('“apple” deb ayting'),
        'Произнесите «apple»',
      );
      expect(
        AppLocalizations(const Locale('en')).translate('An English sentence.'),
        'An English sentence.',
      );
    });

    test('translates the new CEFR course and AI status labels', () {
      expect(
        AppLocalizations(const Locale('en')).translate('Darajangizni tanlang'),
        'Choose your level',
      );
      expect(
        AppLocalizations(const Locale('ru')).translate('Darajangizni tanlang'),
        'Выберите уровень',
      );
      expect(
        AppLocalizations(const Locale('en')).translate('3 / 4 ta dars'),
        '3 / 4 lessons',
      );
      expect(
        AppLocalizations(const Locale('ru'))
            .translate('AI API kaliti sozlandi'),
        'Ключ API ИИ настроен',
      );
    });

    testWidgets('localized text renders for all selected locales', (
      tester,
    ) async {
      const expected = <String, String>{
        'en': 'Settings',
        'ru': 'Настройки',
        'uz': 'Sozlamalar',
      };
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: const Scaffold(body: LText('Sozlamalar')),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(expected[locale.languageCode]!), findsOneWidget);
      }
    });
  });

  test('stores selected UI language and theme on device', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = AppPreferences.instance;
    await preferences.init();
    expect(preferences.themeMode, ThemeMode.dark);
    await preferences.setLanguageCode('ru');
    await preferences.setThemeMode(ThemeMode.system);
    expect(preferences.themeMode, ThemeMode.system);
    await preferences.setThemeMode(ThemeMode.light);
    expect(preferences.themeMode, ThemeMode.light);
    await preferences.setThemeMode(ThemeMode.dark);

    expect(preferences.languageCode, 'ru');
    expect(preferences.locale, const Locale('ru'));
    expect(preferences.themeMode, ThemeMode.dark);
  });
}
