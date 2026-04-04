import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'AppColor.dart';

abstract class AppTheme {
  static var lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColor.primary,
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      titleLarge: GoogleFonts.roboto(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColor.royalBlue,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        color: AppColor.gray,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        color: AppColor.gray,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: AppColor.royalBlue,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 13,
        color: AppColor.black,

      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 18,
        color: AppColor.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            backgroundColor: AppColor.elv
        )
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColor.softGray, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColor.black, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColor.red, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: AppColor.gray,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.inter(
        color: AppColor.gray,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      suffixStyle: TextStyle(
          color: AppColor.gray,
          fontSize: 16,
          fontWeight: FontWeight.w500
      ),
      focusColor: AppColor.softGray,
      contentPadding: EdgeInsets.all(10),
      prefixIconColor: AppColor.gray,
    ),
  );

  static var darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColor.darkBackground,
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      titleLarge: GoogleFonts.roboto(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColor.white,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        color: AppColor.softGray,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        color: AppColor.gray,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: AppColor.royalBlue,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 13,
        color: AppColor.white,

      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 18,
        color: AppColor.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.darkBackground,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            backgroundColor: AppColor.elv
        )
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColor.softGray, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColor.gray, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColor.red, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: AppColor.gray,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.inter(
        color: AppColor.gray,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      suffixStyle: TextStyle(
          color: AppColor.gray,
          fontSize: 16,
          fontWeight: FontWeight.w500
      ),
      focusColor: AppColor.softGray,
      contentPadding: EdgeInsets.all(10),
      prefixIconColor: AppColor.gray,
    ),
  );
}