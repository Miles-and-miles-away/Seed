import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

import '../../helpers/test_helpers.dart';

/// WCAG AA for body text.
const _minContrast = 4.5;

/// WCAG 1.4.11: a glyph that carries meaning needs 3:1.
const _minIconContrast = 3.0;

/// The darkest surface the dark theme paints text on.
const _darkSurface = Color(0xFF121212);

void main() {
  group('readableTextColor', () {
    test('every category colour clears the text bar on both themes', () {
      // The calculators and the quiz colour their figures by domain, so
      // the whole palette has to be readable, not just the three the
      // calculators use today.
      for (final category in ActionCategory.values) {
        expect(
          contrastRatio(category.textColorOn(Brightness.light), Colors.white),
          greaterThanOrEqualTo(_minContrast),
          reason: '${category.name} on the light theme',
        );
        expect(
          contrastRatio(category.textColorOn(Brightness.dark), _darkSurface),
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
          contrastRatio(
            category.textColorOn(Brightness.light, large: true),
            Colors.white,
          ),
          greaterThanOrEqualTo(3),
          reason: '${category.name} as large text on the light theme',
        );
        expect(
          contrastRatio(
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
        contrastRatio(ActionCategory.energy.color, Colors.white),
        lessThan(_minContrast),
      );
      expect(
        contrastRatio(ActionCategory.food.color, Colors.white),
        lessThan(_minContrast),
      );
      // Under even the relaxed bar, which is why a headline cannot use
      // the raw colour either.
      expect(
        contrastRatio(ActionCategory.energy.color, Colors.white),
        lessThan(3),
      );
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

  group('info colours', () {
    ColorScheme schemeFor(Color seed, Brightness brightness) =>
        appTheme(brightness, seedColor: seed).colorScheme;

    List<Color> plainSurfaces(ColorScheme scheme) => [
      scheme.surface,
      scheme.surfaceContainerLow,
      scheme.surfaceContainerHigh,
      scheme.surfaceContainerHighest,
    ];

    test('infoColor picks the tone for the brightness', () {
      expect(infoColor(Brightness.light), AppColors.infoLight);
      expect(infoColor(Brightness.dark), AppColors.infoDark);
    });

    for (final MapEntry(key: species, value: seed)
        in AppColors.speciesThemeSeeds.entries) {
      test('infoLight clears the text bar on the light $species surfaces', () {
        for (final surface in plainSurfaces(
          schemeFor(seed, Brightness.light),
        )) {
          expect(
            contrastRatio(AppColors.infoLight, surface),
            greaterThanOrEqualTo(_minContrast),
          );
        }
      });

      test('infoDark clears the icon bar on the dark $species surfaces', () {
        for (final surface in plainSurfaces(schemeFor(seed, Brightness.dark))) {
          expect(
            contrastRatio(AppColors.infoDark, surface),
            greaterThanOrEqualTo(_minIconContrast),
          );
        }
      });

      for (final brightness in Brightness.values) {
        test('the glyph clears the icon bar on $species ${brightness.name} '
            'tinted panels', () {
          final scheme = schemeFor(seed, brightness);
          final info = infoColor(brightness);
          for (final category in ActionCategory.values) {
            final tint = Color.alphaBlend(
              category.color.withValues(alpha: opacityVeryFaint),
              scheme.surfaceContainerHigh,
            );
            expect(
              contrastRatio(info, tint),
              greaterThanOrEqualTo(_minIconContrast),
              reason: '${category.name} tint',
            );
          }
          final headerPanel = Color.alphaBlend(
            scheme.primaryContainer.withValues(alpha: opacityMuted),
            scheme.surface,
          );
          expect(
            contrastRatio(info, headerPanel),
            greaterThanOrEqualTo(_minIconContrast),
          );
        });
      }
    }
  });
}
