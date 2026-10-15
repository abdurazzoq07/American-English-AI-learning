import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User-selectable UI language and appearance, persisted on this device.
class AppPreferences extends ChangeNotifier {
  AppPreferences._();

  static final AppPreferences instance = AppPreferences._();

  late SharedPreferences _store;
  String _languageCode = 'system';
  ThemeMode _themeMode = ThemeMode.dark;

  String get languageCode => _languageCode;
  Locale? get locale =>
      _languageCode == 'system' ? null : Locale(_languageCode);
  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    _store = await SharedPreferences.getInstance();
    final savedLanguage = _store.getString('ui_language') ?? 'system';
    _languageCode = const {'system', 'en', 'ru', 'uz'}.contains(savedLanguage)
        ? savedLanguage
        : 'system';
    // A first install starts with the new navy/blue dark experience. An
    // existing saved user choice (including System) is kept unchanged.
    final savedTheme = _store.getString('ui_theme') ?? 'dark';
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == savedTheme,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setLanguageCode(String value) async {
    if (!const {'system', 'en', 'ru', 'uz'}.contains(value)) return;
    _languageCode = value;
    await _store.setString('ui_language', value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    await _store.setString('ui_theme', value.name);
    notifyListeners();
  }
}
