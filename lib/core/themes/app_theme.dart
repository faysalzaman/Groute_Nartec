import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      primary: AppColors.primaryBlue, // Rich navy blue
      primaryContainer: AppColors.primaryLight, // Medium blue
      secondary: AppColors.secondary, // Vibrant orange
      secondaryContainer: AppColors.secondaryLight, // Amber
      tertiary: AppColors.secondaryDark, // Burnt orange
      brightness: Brightness.light,
      swapOnMaterial3: true,
    ),
    // Custom surface and background colors
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    // Component theme configurations for light mode.
    subThemesData: FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 8.0,
      inputDecoratorUnfocusedHasBorder: true,
      inputDecoratorFocusedBorderWidth: 2.0,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      chipSchemeColor: SchemeColor.primary,
      tooltipSchemeColor: SchemeColor.primaryContainer,
      bottomNavigationBarElevation: 3,
      bottomNavigationBarOpacity: 0.95,
      navigationBarHeight: 60,
      navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      appBarCenterTitle: true,
      cardRadius: 12,
      popupMenuRadius: 8,
      dialogRadius: 16,
      tooltipRadius: 4,
      tabBarItemSchemeColor: SchemeColor.primary,
      elevatedButtonRadius: 8,
      // Additional text theme customization
      blendTextTheme: true,
      textButtonRadius: 8,
      outlinedButtonRadius: 8,
      outlinedButtonBorderWidth: 1.5,
      // Menu and popup customization
      popupMenuOpacity: 0.95,
      // Toggle and selection control customization
      switchSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
      radioSchemeColor: SchemeColor.primary,
    ),
    // Typography and text theme
    textTheme: GoogleFonts.interTextTheme(),
    primaryTextTheme: GoogleFonts.interTextTheme(),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    useMaterial3: true, // Enable Material 3 design
    // Additional customization
    keyColors: const FlexKeyColors(useSecondary: true, useTertiary: true),
    tones: FlexTones.vivid(Brightness.light),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Use our custom colors
    colors: FlexSchemeColor.from(
      primary: AppColors.primaryBlue, // Rich navy blue
      primaryContainer: AppColors.primaryLight, // Medium blue
      secondary: AppColors.secondary, // Vibrant orange
      secondaryContainer: AppColors.secondaryLight, // Amber
      tertiary: AppColors.secondaryDark, // Burnt orange
      brightness: Brightness.dark,
      swapOnMaterial3: true,
    ).defaultError.toDark(30, true),
    // Custom surface and background colors
    darkIsTrueBlack: false,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    // Component theme configurations for dark mode.
    subThemesData: FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 8.0,
      inputDecoratorUnfocusedHasBorder: true,
      inputDecoratorFocusedBorderWidth: 2.0,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      chipSchemeColor: SchemeColor.primary,
      tooltipSchemeColor: SchemeColor.inversePrimary,
      bottomNavigationBarElevation: 3,
      bottomNavigationBarOpacity: 0.95,
      navigationBarHeight: 60,
      navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      appBarCenterTitle: true,
      cardRadius: 12,
      popupMenuRadius: 8,
      dialogRadius: 16,
      tooltipRadius: 4,
      tabBarItemSchemeColor: SchemeColor.primary,
      elevatedButtonRadius: 8,
      // Additional text theme customization
      blendTextTheme: true,
      textButtonRadius: 8,
      outlinedButtonRadius: 8,
      outlinedButtonBorderWidth: 1.5,
      // Menu and popup customization
      popupMenuOpacity: 0.95,
      // Toggle and selection control customization
      switchSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
      radioSchemeColor: SchemeColor.primary,
      // Card customization
      cardElevation: 2,
    ),
    // Typography and text theme
    textTheme: GoogleFonts.interTextTheme(),
    primaryTextTheme: GoogleFonts.interTextTheme(),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    useMaterial3: true, // Enable Material 3 design
    // Additional customization
    keyColors: const FlexKeyColors(useSecondary: true, useTertiary: true),
    tones: FlexTones.vivid(Brightness.dark),
  );
}
