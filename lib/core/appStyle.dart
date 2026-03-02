import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
class AppStyle{
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: ColorManager.background,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: ColorManager.background,
      centerTitle: true,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: ColorManager.darkBackground,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: ColorManager.darkBackground,
      centerTitle: true,
    ),
  );
}