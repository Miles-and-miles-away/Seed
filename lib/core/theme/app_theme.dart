import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

import 'app_colors.dart';

/// The app's five font sizes. Every Material role maps onto one of them,
/// so screens keep using `textTheme` roles and never set `fontSize`.
const fontSizeSmall = 12.0;
const fontSizeBody = 14.0;
const fontSizeTitle = 16.0;
const fontSizeLarge = 22.0;
const fontSizeHero = 28.0;

/// Sizes only: [ThemeData] merges this over the Material defaults, which
/// keep their weights, tracking and line heights.
const _textTheme = TextTheme(
  displayLarge: TextStyle(fontSize: fontSizeHero),
  displayMedium: TextStyle(fontSize: fontSizeHero),
  displaySmall: TextStyle(fontSize: fontSizeHero),
  headlineLarge: TextStyle(fontSize: fontSizeHero),
  headlineMedium: TextStyle(fontSize: fontSizeHero),
  headlineSmall: TextStyle(fontSize: fontSizeLarge),
  titleLarge: TextStyle(fontSize: fontSizeLarge),
  titleMedium: TextStyle(fontSize: fontSizeTitle),
  titleSmall: TextStyle(fontSize: fontSizeBody),
  bodyLarge: TextStyle(fontSize: fontSizeTitle),
  bodyMedium: TextStyle(fontSize: fontSizeBody),
  bodySmall: TextStyle(fontSize: fontSizeSmall),
  labelLarge: TextStyle(fontSize: fontSizeBody),
  labelMedium: TextStyle(fontSize: fontSizeSmall),
  labelSmall: TextStyle(fontSize: fontSizeSmall),
);

/// App theme configuration using the Material 3 design system.
///
/// [seedColor] follows the active mascot species (see
/// AppColors.speciesThemeSeeds), so the whole scheme tints per
/// character.
ThemeData appTheme(Brightness brightness, {Color? seedColor}) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor ?? AppColors.primary,
    brightness: brightness,
  ),
  textTheme: _textTheme,
  appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  cardTheme: CardThemeData(
    elevation: 0,
    margin: const EdgeInsets.all(cardMargin),
    shape: RoundedRectangleBorder(borderRadius: borderRadiusLg),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(borderRadius: borderRadiusMd),
  ),
);
