import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';

void main() {
  group('compareTotals', () {
    test('returns null with fewer than two options', () {
      expect(compareTotals([]), isNull);
      expect(compareTotals([100]), isNull);
    });

    test('finds best and worst and the delta', () {
      final s = compareTotals([122000, 81000, 10000])!;
      expect(s.bestIndex, 2);
      expect(s.worstIndex, 0);
      expect(s.deltaGrams, 112000);
      expect(s.deltaPercent, closeTo(91.8, 0.1));
    });

    test('all-zero comparison has no percentage', () {
      final s = compareTotals([0, 0])!;
      expect(s.deltaGrams, 0);
      expect(s.deltaPercent, 0);
    });

    test('first minimum and maximum win ties', () {
      final s = compareTotals([50, 50, 50])!;
      expect(s.bestIndex, 0);
      expect(s.worstIndex, 0);
      expect(s.deltaGrams, 0);
    });
  });

  group('choicePoints', () {
    test('floors at 1 for zero or negative CO2', () {
      expect(choicePoints(0), 1);
      expect(choicePoints(-5), 1);
    });

    test('applies the CO2^0.4 term with neutral multipliers', () {
      expect(choicePoints(112000), max(1, pow(112000, 0.4).round()));
    });

    test('is non-decreasing in CO2', () {
      var last = 0;
      for (final g in [100, 1000, 10000, 100000, 1000000]) {
        final p = choicePoints(g);
        expect(p, greaterThanOrEqualTo(last));
        last = p;
      }
    });
  });
}
