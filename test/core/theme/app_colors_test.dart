import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

/// WCAG AA for body text.
const _minContrast = 4.5;

/// The darkest surface the dark theme paints text on.
const _darkSurface = Color(0xFF121212);

double _contrast(Color a, Color b) {
  final high = a.computeLuminance() > b.computeLuminance()
      ? a.computeLuminance()
      : b.computeLuminance();
  final low = a.computeLuminance() > b.computeLuminance()
      ? b.computeLuminance()
      : a.computeLuminance();
  return (high + 0.05) / (low + 0.05);
}

void main() {
  group('readableTextColor', () {
    test('every category colour clears the text bar on both themes', () {
      // The calculators and the quiz colour their figures by domain, so
      // the whole palette has to be readable, not just the three the
      // calculators use today.
      for (final category in ActionCategory.values) {
        expect(
          _contrast(category.textColorOn(Brightness.light), Colors.white),
          greaterThanOrEqualTo(_minContrast),
          reason: '${category.name} on the light theme',
        );
        expect(
          _contrast(category.textColorOn(Brightness.dark), _darkSurface),
          greaterThanOrEqualTo(_minContrast),
          reason: '${category.name} on the dark theme',
        );
      }
    });

    test('large text and graphics clear their own 3:1 bar', () {
      // WCAG lets 18pt text, 14pt bold, and graphics sit at 3:1, so the
      // large tone keeps more of the colour than body text can.
      for (final category in ActionCategory.values) {
        expect(
          _contrast(
            category.textColorOn(Brightness.light, large: true),
            Colors.white,
          ),
          greaterThanOrEqualTo(3),
          reason: '${category.name} as large text on the light theme',
        );
        expect(
          _contrast(
            category.textColorOn(Brightness.dark, large: true),
            _darkSurface,
          ),
          greaterThanOrEqualTo(3),
          reason: '${category.name} as large text on the dark theme',
        );
      }
    });

    test('the large tone is more vivid than the body tone', () {
      // The whole point of the second tone: a headline should not be
      // muddied down to the body-text bar it does not have to meet.
      for (final category in ActionCategory.values) {
        final body = HSLColor.fromColor(category.textColorOn(Brightness.light));
        final large = HSLColor.fromColor(
          category.textColorOn(Brightness.light, large: true),
        );
        expect(large.lightness, greaterThan(body.lightness));
      }
    });

    test('the raw category colours are fills, which is why it exists', () {
      // Amber as ink on white is 1.6:1. If this ever passes on its own,
      // the palette changed and the helper may no longer be needed.
      expect(
        _contrast(ActionCategory.energy.color, Colors.white),
        lessThan(_minContrast),
      );
      expect(
        _contrast(ActionCategory.food.color, Colors.white),
        lessThan(_minContrast),
      );
      // Under even the relaxed bar, which is why a headline cannot use
      // the raw colour either.
      expect(_contrast(ActionCategory.energy.color, Colors.white), lessThan(3));
    });

    test('keeps the hue it was given', () {
      for (final category in ActionCategory.values) {
        expect(
          HSLColor.fromColor(category.textColorOn(Brightness.light)).hue,
          // A couple of degrees of drift from the 8-bit round trip.
          closeTo(HSLColor.fromColor(category.color).hue, 2),
          reason: '${category.name} should stay its own colour',
        );
      }
    });

    test('darkens for a light surface and lightens for a dark one', () {
      final light = readableTextColor(
        ActionCategory.energy.color,
        Brightness.light,
      );
      final dark = readableTextColor(
        ActionCategory.energy.color,
        Brightness.dark,
      );
      expect(light.computeLuminance(), lessThan(dark.computeLuminance()));
    });
  });
}
