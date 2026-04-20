import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/readable_color.dart';

double _rel(double v) =>
    v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();

double _luminance(Color c) =>
    0.2126 * _rel(c.r) + 0.7152 * _rel(c.g) + 0.0722 * _rel(c.b);

double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  const white = Color(0xFFFFFFFF);
  const black = Color(0xFF000000);

  group('readableOn', () {
    test('returns brand unchanged when contrast already meets minimum', () {
      // Black on white is maximum contrast.
      final result = readableOn(black, white);

      expect(result, black);
    });

    test('darkens a low-contrast yellow when surface is white', () {
      const yellow = Color(0xFFFCC30B);

      final result = readableOn(yellow, white);

      expect(_contrast(result, white), greaterThanOrEqualTo(4.5));
      // The returned colour must differ from the input because the
      // original yellow fails AA on white.
      expect(result, isNot(yellow));
    });

    test('honours a custom minContrast', () {
      const yellow = Color(0xFFFCC30B);

      final loose = readableOn(yellow, white, minContrast: 3);
      final strict = readableOn(yellow, white, minContrast: 7);

      expect(_contrast(loose, white), greaterThanOrEqualTo(3));
      expect(_contrast(strict, white), greaterThanOrEqualTo(7));
      // Stricter threshold must be at least as dark (higher contrast).
      expect(
        _contrast(strict, white),
        greaterThanOrEqualTo(_contrast(loose, white)),
      );
    });

    test('lightens a mid-tone colour when surface is dark', () {
      const maroon = Color(0xFF5A1A1A);

      final result = readableOn(maroon, black);

      expect(_contrast(result, black), greaterThanOrEqualTo(4.5));
    });

    test('returns best-effort value when no adjustment reaches target', () {
      // Asking 21:1 against white forces stepping all the way to black.
      const grey = Color(0xFF808080);

      final result = readableOn(grey, white, minContrast: 21);

      // Result should be very dark even though we can't quite hit 21:1.
      expect(_luminance(result), lessThan(_luminance(grey)));
    });
  });
}
