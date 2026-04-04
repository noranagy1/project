import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static late SharedPreferences _sharedPreferences;

  static const String themeKey = "theme";
  static const String localeKey = "locale";

  static const String light = "light";
  static const String dark = "dark";

  AppSharedPreferences._();

  static AppSharedPreferences? _instance;

  static Future<void> init() async {
    if (_instance == null) {
      _instance = AppSharedPreferences._();
      await _instance!._initSharedPreferences();
    }
  }

  static AppSharedPreferences getInstance() {
    if (_instance == null) {
      throw Exception("Call init() first");
    }
    return _instance!;
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> saveTheme(ThemeMode mode) async {
    final themeName = mode == ThemeMode.dark ? dark : light;
    await _sharedPreferences.setString(themeKey, themeName);
  }

  ThemeMode getCurrentTheme() {
    final themeName = _sharedPreferences.getString(themeKey);

    if (themeName == dark) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  Future<void> saveLocale(Locale locale) async {
    await _sharedPreferences.setString(localeKey, locale.languageCode);
  }

  Locale getCurrentLocale() {
    final langCode = _sharedPreferences.getString(localeKey);

    return langCode == null
        ? const Locale("en")
        : Locale(langCode);
  }
}