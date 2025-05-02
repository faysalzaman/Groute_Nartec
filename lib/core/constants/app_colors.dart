import 'package:flutter/material.dart';

/// A collection of colors used throughout the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primaryBlue = Color(0xFF136F63); // Deep teal
  static const Color primaryLight = Color(0xFF22AAA1); // Medium teal
  static const Color primaryDark = Color(0xFF0B4D43); // Dark teal

  // Secondary colors
  static const Color secondary = Color(0xFFDB5461); // Coral red
  static const Color secondaryLight = Color(0xFFFF7E8A); // Light coral
  static const Color secondaryDark = Color(0xFFB2323E); // Dark coral

  // Background colors
  static const Color lightBackground = Color(0xFFF2F5F8); // Light blue-gray
  static const Color darkBackground = Color(0xFF1D2C38); // Deep blue-gray
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text colors
  static const Color textDark = Color(0xFF2C363F); // Dark slate
  static const Color textMedium = Color(0xFF5C6670); // Medium slate
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // Status colors
  static const Color success = Color(0xFF2E7D32); // Material green 800
  static const Color error = Color(0xFFD32F2F); // Material red 700
  static const Color warning = Color(0xFFF57C00); // Material orange 800
  static const Color info = primaryBlue;

  // Border and divider colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);

  // Common colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Grey palette
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Surface and overlay colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color overlay = Color(0x52000000); // 32% black
}
