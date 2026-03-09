import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  LocaleProvider() {
    _loadLocale();
  }
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('locale') ?? 'en';
    _locale = Locale(lang);
    notifyListeners();
  }
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }
}