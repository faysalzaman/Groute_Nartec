import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.2.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Use our custom colors
    colors: FlexSchemeColor.from(
      primary: AppColors.primaryBlue, // Deep teal
      secondary: AppColors.secondary, // Coral red
      brightness: Brightness.light,
      swapOnMaterial3: true,
    ),
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      chipSchemeColor: SchemeColor.primary,
      tooltipSchemeColor: SchemeColor.primaryContainer,
      bottomNavigationBarElevation: 2,
      bottomNavigationBarOpacity: 0.95,
      cardRadius: 12,
      popupMenuRadius: 8,
      dialogRadius: 16,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    useMaterial3: true, // Enable Material 3 design
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Use our custom colors for dark mode too
    colors: FlexSchemeColor.from(
      primary: AppColors.primaryBlue, // Deep teal
      secondary: AppColors.secondary, // Coral red
      brightness: Brightness.dark,
      swapOnMaterial3: true,
    ).defaultError.toDark(30, true),
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      chipSchemeColor: SchemeColor.primary,
      tooltipSchemeColor: SchemeColor.inversePrimary,
      bottomNavigationBarElevation: 2,
      bottomNavigationBarOpacity: 0.95,
      cardRadius: 12,
      popupMenuRadius: 8,
      dialogRadius: 16,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    useMaterial3: true, // Enable Material 3 design
  );
}
