import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/cach/appSharedPreferences.dart';


class LanguageProvider extends ChangeNotifier{

  late Locale _locale ;
  AppSharedPreferences appSettingsPreferences = AppSharedPreferences.getInstance();
  LanguageProvider(){
    _locale = appSettingsPreferences.getCurrentLocale();
  }
  List <Locale>  getSupportedLocales(){
    return [
      Locale("en"),
      Locale("ar")
    ];
  }
  Locale getSelectedLocale(){
    return _locale;
  }

  void changeLocale(Locale newLang){
    _locale = newLang;
    appSettingsPreferences.saveLocale(_locale);
    notifyListeners();

  }
}