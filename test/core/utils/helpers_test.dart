import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/helpers.dart';

void main() {
  group('level curve reachability', () {
    test('full evolution is reachable within ~5 months of daily use', () {
      // Guard against curve re-tuning that makes stage 4 (and the egg
      // system behind it) unreachable: ~150 points/day for 150 days.
      const plausibleLifetimePoints = 150 * 150;
      expect(
        calculatePointsForLevel(AppConstants.maxEvolutionLevel),
        lessThan(plausibleLifetimePoints),
      );
    });

    test('stage 2 is reachable within ~2 weeks of daily use', () {
      const twoWeeksPoints = 150 * 14;
      // Stage 2 unlocks at level 10 (mascot_species.json evolution stages).
      const stage2Level = 10;
      expect(
        calculatePointsForLevel(stage2Level),
        lessThan(twoWeeksPoints),
      );
    });
  });

  group('calculateLevel', () {
    test('returns 1 for 0 points', () {
      expect(calculateLevel(0), 1);
    });

    test('returns 1 for negative points', () {
      expect(calculateLevel(-100), 1);
    });

    test('returns 1 for points below first threshold', () {
      expect(calculateLevel(50), 1);
    });

    test('returns 2 when points reach level 2 threshold', () {
      // Level 2 requires 100 points (base)
      expect(calculateLevel(100), 2);
    });

    test('returns correct level for higher point values', () {
      // Level 3 requires 100 + 105 = 205 points
      expect(calculateLevel(205), 3);
      // Level 5 requires ~431 points
      expect(calculateLevel(475), 5);
    });

    test('handles large point values', () {
      final level = calculateLevel(100000);
      expect(level, greaterThan(10));
    });
  });

  group('calculatePointsForLevel', () {
    test('returns 0 for level 1', () {
      expect(calculatePointsForLevel(1), 0);
    });

    test('returns 0 for level 0 or negative', () {
      expect(calculatePointsForLevel(0), 0);
      expect(calculatePointsForLevel(-1), 0);
    });

    test('returns base points for level 2', () {
      // Level 2 requires pointsPerLevel (100) points
      expect(calculatePointsForLevel(2), 100);
    });

    test('returns scaled points for level 3', () {
      // Level 3 requires 100 + 105 = 205 points
      expect(calculatePointsForLevel(3), 205);
    });

    test('increases monotonically with level', () {
      var previous = 0;
      for (var level = 1; level <= 10; level++) {
        final points = calculatePointsForLevel(level);
        expect(points, greaterThanOrEqualTo(previous));
        previous = points;
      }
    });
  });

  group('calculatePointsToNextLevel', () {
    test('returns points needed from 0', () {
      // At 0 points, level is 1, next level (2) requires 100 points
      expect(calculatePointsToNextLevel(0), 100);
    });

    test('returns remaining points when partially through level', () {
      // At 50 points, still level 1, need 50 more to reach level 2
      expect(calculatePointsToNextLevel(50), 50);
    });

    test('returns full requirement when just reaching new level', () {
      // At 100 points, level is 2, next level (3) requires 205 total
      // So need 205 - 100 = 105 more
      expect(calculatePointsToNextLevel(100), 105);
    });

    test('returns positive value for any valid points', () {
      for (final points in [0, 50, 100, 500, 1000, 5000]) {
        expect(calculatePointsToNextLevel(points), greaterThan(0));
      }
    });
  });

  group('calculateLevelProgress', () {
    test('returns 0.0 at start of level', () {
      // At exactly 100 points (start of level 2)
      expect(calculateLevelProgress(100), closeTo(0.0, 0.01));
    });

    test('returns value between 0 and 1 when partially through level', () {
      // Level 2 is 100-205 points (105 point range)
      // At 152 points, we're ~52/105 = ~0.5 through
      final progress = calculateLevelProgress(152);
      expect(progress, greaterThan(0.0));
      expect(progress, lessThan(1.0));
      expect(progress, closeTo(0.5, 0.01));
    });

    test('returns close to 1.0 near end of level', () {
      // Just before level 4 (314 points out of 315 needed)
      final progress = calculateLevelProgress(314);
      expect(progress, greaterThan(0.9));
      expect(progress, lessThanOrEqualTo(1.0));
    });

    test('clamps to 1.0 maximum', () {
      final progress = calculateLevelProgress(0);
      expect(progress, greaterThanOrEqualTo(0.0));
      expect(progress, lessThanOrEqualTo(1.0));
    });

    test('never returns negative', () {
      expect(calculateLevelProgress(-100), greaterThanOrEqualTo(0.0));
    });
  });

  group('formatCO2Compact', () {
    test('formats grams below 1000 with g suffix', () {
      expect(formatCO2Compact(500), '500g');
      expect(formatCO2Compact(0), '0g');
      expect(formatCO2Compact(999), '999g');
    });

    test('formats kilograms for 1000+ grams with kg suffix', () {
      expect(formatCO2Compact(1000), '1.0kg');
      expect(formatCO2Compact(1500), '1.5kg');
      expect(formatCO2Compact(2500), '2.5kg');
    });

    test('does not include spaces', () {
      expect(formatCO2Compact(500), isNot(contains(' ')));
      expect(formatCO2Compact(1500), isNot(contains(' ')));
    });
  });

  group('formatPoints', () {
    test('formats small values without suffix', () {
      expect(formatPoints(0), '0');
      expect(formatPoints(100), '100');
      expect(formatPoints(999), '999');
    });

    test('formats thousands with K suffix', () {
      expect(formatPoints(1000), '1.0K');
      expect(formatPoints(1500), '1.5K');
      expect(formatPoints(10000), '10.0K');
      expect(formatPoints(999999), '1000.0K');
    });

    test('formats millions with M suffix', () {
      expect(formatPoints(1000000), '1.0M');
      expect(formatPoints(1500000), '1.5M');
      expect(formatPoints(10000000), '10.0M');
    });

    test('uses one decimal place', () {
      expect(formatPoints(1234), '1.2K');
      expect(formatPoints(1234567), '1.2M');
    });
  });
}
