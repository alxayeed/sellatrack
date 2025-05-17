import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette (Teal)
  static const Color primary = Color(0xFF26A69A);
  static const Color primaryDarker = Color(0xFF00796B);
  static const Color primaryLighter = Color(0xFF80CBC4);

  // Secondary Palette (Amber)
  static const Color secondary = Color(0xFFFFC107);
  static const Color secondaryDarker = Color(0xFFFFA000);
  static const Color secondaryLighter = Color(0xFFFFECB3);

  // Neutral & Backgrounds - Light Theme
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFF000000);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color outlineLight = Color(0xFFBDBDBD);

  // Neutral & Backgrounds - Dark Theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // For Dark Theme, Material Design often suggests using lighter shades of primary/secondary
  static const Color primaryDarkTheme = Color(0xFF4DB6AC);
  static const Color secondaryDarkTheme = Color(0xFFFFCA28);
  static const Color onPrimaryDark = Color(0xFF000000);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);
  static const Color outlineDark = Color(0xFF424242);

  // Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFE57373);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF388E3C);
  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color warning = Color(0xFFFFA000);
  static const Color onWarning = Color(0xFF000000);

  // Other common colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color transparent = Colors.transparent;
}
