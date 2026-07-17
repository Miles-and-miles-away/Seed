import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

import 'app_colors.dart';

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
  appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  cardTheme: CardThemeData(
    elevation: 0,
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
