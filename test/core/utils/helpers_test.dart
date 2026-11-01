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
      expect(calculatePointsForLevel(stage2Level), lessThan(twoWeeksPoints));
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

  group('formatDecimal', () {
    test('uses the locale decimal and group separators', () {
      expect(formatDecimal(1234.5, 'en', maxDigits: 1), '1,234.5');
      expect(formatDecimal(1234.5, 'es', maxDigits: 1), '1.234,5');
      expect(formatDecimal(1234.5, 'ja', maxDigits: 1), '1,234.5');
    });

    test('drops trailing zeros beyond minDigits', () {
      expect(formatDecimal(0.8, 'es', maxDigits: 3), '0,8');
      expect(formatDecimal(2, 'en', maxDigits: 2), '2');
      expect(formatDecimal(2, 'en', minDigits: 1, maxDigits: 1), '2.0');
    });
  });

  group('formatCO2Compact', () {
    test('formats grams below 1000 with g suffix', () {
      expect(formatCO2Compact(500, 'en'), '500${unitSpace}g');
      expect(formatCO2Compact(0, 'en'), '0${unitSpace}g');
      expect(formatCO2Compact(999, 'en'), '999${unitSpace}g');
    });

    test('formats kilograms for 1000+ grams with kg suffix', () {
      expect(formatCO2Compact(1000, 'en'), '1.0${unitSpace}kg');
      expect(formatCO2Compact(1500, 'en'), '1.5${unitSpace}kg');
      expect(formatCO2Compact(2500, 'en'), '2.5${unitSpace}kg');
    });

    test('formats tonnes from a million grams', () {
      expect(formatCO2Compact(3400000, 'en'), '3.4${unitSpace}t');
    });

    test('switches to tonnes when the kilograms would round to 1000', () {
      expect(formatCO2Compact(999949, 'en'), '999.9${unitSpace}kg');
      expect(formatCO2Compact(999950, 'en'), '1.0${unitSpace}t');
      expect(formatCO2Compact(999950, 'es'), '1,0${unitSpace}t');
    });

    test('uses the decimal comma in Spanish', () {
      expect(formatCO2Compact(1500, 'es'), '1,5${unitSpace}kg');
    });

    test('joins the value to its unit with a no-break space only', () {
      expect(formatCO2Compact(500, 'en'), isNot(contains(' ')));
      expect(formatCO2Compact(1500, 'en').split(unitSpace), ['1.5', 'kg']);
    });
  });

  group('formatPoints', () {
    test('formats small values without suffix', () {
      expect(formatPoints(0, 'en'), '0');
      expect(formatPoints(100, 'en'), '100');
      expect(formatPoints(999, 'en'), '999');
    });

    test('uses compact notation for large values', () {
      expect(formatPoints(1000, 'en'), '1K');
      expect(formatPoints(1234, 'en'), '1.23K');
      expect(formatPoints(1234567, 'en'), '1.23M');
    });

    test('follows the locale convention', () {
      expect(formatPoints(12345, 'ja'), '1.23万');
      expect(formatPoints(1234, 'es'), '1,23\u00A0mil');
    });
  });

  group('keepUnitsTogether', () {
    test('joins a number to the unit after it', () {
      expect(
        keepUnitsTogether('1 cucharada (15 ml)'),
        '1 cucharada (15${unitSpace}ml)',
      );
      expect(keepUnitsTogether('100 g'), '100${unitSpace}g');
    });

    test('joins temperatures, watts and lumens', () {
      expect(keepUnitsTogether('1 hora a 20 °C'), '1 hora a 20$unitSpace°C');
      expect(keepUnitsTogether('cold (20 C)'), 'cold (20${unitSpace}C)');
      expect(keepUnitsTogether('60 W bulb'), '60${unitSpace}W bulb');
      expect(keepUnitsTogether('800 lm'), '800${unitSpace}lm');
    });

    test('leaves words that only start like a unit alone', () {
      expect(keepUnitsTogether('3 gatos'), '3 gatos');
      expect(keepUnitsTogether('2 hours'), '2 hours');
      expect(keepUnitsTogether('3 Watts, 2 Cats'), '3 Watts, 2 Cats');
    });
  });

  group('foldForSearch', () {
    test('strips case and accents', () {
      expect(foldForSearch('Plátano'), 'platano');
      expect(foldForSearch('JALAPEÑO'), 'jalapeno');
    });

    test('folds the marks city names carry beyond Latin-1', () {
      expect(foldForSearch('São Paulo'), 'sao paulo');
      expect(foldForSearch('Herāt'), 'herat');
      expect(foldForSearch('Kraków'), 'krakow');
      expect(foldForSearch('Reykjanesbær'), 'reykjanesbaer');
      expect(foldForSearch('Hafnarfjörður'), 'hafnarfjordur');
    });

    test('folds the marks the Spanish city names carry', () {
      // Shipped name_es values. The comma-below pair sits beside the
      // cedilla forms already in the table and was skipped, leaving
      // these unreachable from an ES query.
      expect(foldForSearch('Chișinău'), 'chisinau');
      expect(foldForSearch('Iași'), 'iasi');
      expect(foldForSearch('Rîbnița'), 'ribnita');
      expect(foldForSearch('Almatý'), 'almaty');
      expect(foldForSearch('Kōbe'), 'kobe');
    });

    test('drops combining marks and curly quotes', () {
      // Dart lowercases the Turkish dotted capital I to "i" plus a
      // combining dot, which no keyboard produces.
      expect(foldForSearch('İzmir'), 'izmir');
      expect(foldForSearch('Az̧ Z̧a‘āyin'), 'az zaayin');
      expect(foldForSearch('Namp’o'), 'nampo');
    });
  });
}
