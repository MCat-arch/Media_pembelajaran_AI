import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: AppColors.background,
    ),
    textTheme: TextTheme(
      headlineLarge: AppFonts.heading,
      headlineMedium: AppFonts.subHeading,
      bodyLarge: AppFonts.body,
      bodyMedium: AppFonts.bodySecondary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: AppFonts.subHeading.copyWith(color: Colors.white),
      elevation: 0,
    ),
  );
}
