import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

import 'app_colors.dart';

/// App theme configuration using the Material 3 design system.
ThemeData _theme(Brightness brightness) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
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

/// Light theme.
final ThemeData appThemeLight = _theme(Brightness.light);

/// Dark theme.
final ThemeData appThemeDark = _theme(Brightness.dark);
