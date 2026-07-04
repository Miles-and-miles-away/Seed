import 'dart:math' as math;

import 'package:flutter/painting.dart';

const double _kWcagAaContrast = 4.5;
const double _kLightnessStep = 0.02;
const int _kMaxSteps = 50;

/// Returns [brand] adjusted in HSL lightness until it meets [minContrast]
/// against [surface] (defaults to WCAG AA for body text, 4.5:1).
///
/// Why: official palette colors (SDG, action category) include low-luminance
/// yellows that fail contrast as link/text on light surfaces. Keep the brand
/// hue for badges/icons and run text usages through this helper.
Color readableOn(
  Color brand,
  Color surface, {
  double minContrast = _kWcagAaContrast,
}) {
  if (_contrast(brand, surface) >= minContrast) return brand;

  final shouldDarken = surface.computeLuminance() > brand.computeLuminance();

  var hsl = HSLColor.fromColor(brand);
  for (var i = 0; i < _kMaxSteps; i++) {
    final next =
        hsl.lightness + (shouldDarken ? -_kLightnessStep : _kLightnessStep);
    if (next <= 0 || next >= 1) break;
    hsl = hsl.withLightness(next);
    final candidate = hsl.toColor();
    if (_contrast(candidate, surface) >= minContrast) return candidate;
  }
  return hsl.toColor();
}

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}
