import 'package:flutter/material.dart';

/// Shared text styles on top of the theme's roles.
extension AppTextStyles on ThemeData {
  /// A label above a value or a section. Callers uppercase the text.
  TextStyle? get overline => textTheme.labelMedium?.copyWith(
    color: colorScheme.onSurfaceVariant,
    letterSpacing: 1,
  );

  /// Secondary text below what it describes.
  TextStyle? get caption =>
      textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant);
}
