import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';

FoodItem item(
  String id,
  double kgPerKg, {
  int sourceTier = 1,
  double? statisticRatio,
}) => FoodItem(
  id: id,
  group: 'test',
  nameEn: id,
  nameJa: id,
  nameEs: id,
  kgCo2ePerKg: kgPerKg,
  sourceTier: sourceTier,
  statisticRatio: statisticRatio,
);

/// One ingredient per option, so the gate's inputs read plainly.
List<List<MealIngredient>> meals(String a, String b) => [
  [MealIngredient(itemId: a, grams: 100)],
  [MealIngredient(itemId: b, grams: 100)],
];

void main() {
  group('ingredientCo2eGrams', () {
    test('factor x grams gives grams CO2e', () {
      // beef 99.48 kg/kg over a 113 g patty.
      final grams = FoodCalculator.ingredientCo2eGrams(
        item('beef', 99.48),
        const MealIngredient(itemId: 'beef', grams: 113),
      );
      expect(grams, closeTo(11241.24, 1e-6));
    });

    test('zero grams is zero', () {
      expect(
        FoodCalculator.ingredientCo2eGrams(
          item('chicken', 9.87),
          const MealIngredient(itemId: 'chicken', grams: 0),
        ),
        0,
      );
    });

    test('negative grams throws', () {
      expect(
        () => FoodCalculator.ingredientCo2eGrams(
          item('chicken', 9.87),
          const MealIngredient(itemId: 'chicken', grams: -1),
        ),
        throwsArgumentError,
      );
    });
  });

  group('mealCo2eGrams', () {
    final byId = FoodCalculator.byId([
      item('chicken', 9.87),
      item('potatoes', 0.46),
      item('beer', 1.2),
    ]);

    test('sums every ingredient', () {
      final total = FoodCalculator.mealCo2eGrams(byId, const [
        MealIngredient(itemId: 'chicken', grams: 170),
        MealIngredient(itemId: 'potatoes', grams: 200),
        MealIngredient(itemId: 'beer', grams: 330),
      ]);
      // 1677.9 + 92 + 396 = 2165.9 g
      expect(total, closeTo(2165.9, 1e-6));
    });

    test('empty meal is zero', () {
      expect(FoodCalculator.mealCo2eGrams(byId, const []), 0);
    });

    test('unknown item id throws', () {
      expect(
        () => FoodCalculator.mealCo2eGrams(byId, const [
          MealIngredient(itemId: 'unicorn', grams: 100),
        ]),
        throwsArgumentError,
      );
    });
  });

  group('mayStateVerdict', () {
    // RESEARCH_FOOD.md section 8 rule 4: no "X emits less than Y"
    // below a 20% delta, because whole clusters of the dataset are
    // statistically tied by construction. Rule R6 additionally
    // requires a doubling when the two sides are not on one source
    // tier -- a tier-2 row is measured to a narrower boundary and
    // reads systematically low against the tier-1 anchors.
    final byId = FoodCalculator.byId([
      item('beef', 70.3608),
      item('chicken', 9.87),
      item('eggs', 4.67),
      item('rice', 4.45),
      item('white_fish', 5.1250386, sourceTier: 2),
    ]);

    bool gate(String a, String b) {
      final options = meals(a, b);
      final totals = options
          .map((o) => FoodCalculator.mealCo2eGrams(byId, o))
          .toList();
      return FoodCalculator.mayStateVerdict(
        compareTotals(totals)!,
        byId,
        options,
      );
    }

    test('a wide, same-tier gap gets a verdict', () {
      // chicken vs beef: 86% reduction.
      expect(gate('chicken', 'beef'), isTrue);
    });

    test('the eggs-vs-rice tie gets none', () {
      // 4.67 vs 4.45 = 4.7%. This pair is on the never-pin list
      // precisely because it is inside the dataset's resolution.
      expect(gate('rice', 'eggs'), isFalse);
    });

    test('20% exactly is enough', () {
      final byId = FoodCalculator.byId([item('a', 10), item('b', 12.5)]);
      final options = meals('a', 'b');
      final totals = options
          .map((o) => FoodCalculator.mealCo2eGrams(byId, o))
          .toList();
      // 1250 -> 1000 is a 20.0% reduction.
      expect(compareTotals(totals)!.deltaPercent, closeTo(20, 1e-9));
      expect(
        FoodCalculator.mayStateVerdict(compareTotals(totals)!, byId, options),
        isTrue,
      );
    });

    test('a cross-tier gap needs a doubling, not 20%', () {
      // white_fish (tier 2) vs chicken (tier 1): 9.87 -> 5.125 is a
      // 48.1% reduction, over the 20% bar but under the 2x one, and
      // the tier-2 boundary offset could account for it.
      expect(gate('white_fish', 'chicken'), isFalse);
      // vs beef the gap is 92.7% -- far wider than the offset.
      expect(gate('white_fish', 'beef'), isTrue);
    });

    test('an identical pair gets none', () {
      expect(gate('beef', 'beef'), isFalse);
    });
  });

  group('statistic-sensitive items', () {
    // Dark chocolate's own mean and median are 46.65 and 18.7, a 2.49x
    // divergence: a minority of deforestation-linked producers sets its
    // average. A gap involving it is only safe once it outruns that
    // spread, i.e. the better meal emits under 1/2.49 of the other,
    // about a 60% reduction.
    final byId = FoodCalculator.byId([
      item('dark_chocolate', 46.65, statisticRatio: 2.4947),
      item('cheese', 23.88),
      item('beef', 70.3608),
    ]);

    VerdictCheck check(List<MealIngredient> a, List<MealIngredient> b) {
      final options = [a, b];
      final totals = options
          .map((o) => FoodCalculator.mealCo2eGrams(byId, o))
          .toList();
      return FoodCalculator.checkVerdict(compareTotals(totals)!, byId, options);
    }

    test('per kg, cheese vs chocolate is refused despite a 48% gap', () {
      // The pair that disproved a flat threshold: 48.8% apart on means
      // and still swaps under medians.
      final result = check(
        const [MealIngredient(itemId: 'cheese', grams: 100)],
        const [MealIngredient(itemId: 'dark_chocolate', grams: 100)],
      );
      expect(result.block, VerdictBlock.uncertainItem);
      expect(result.item?.id, 'dark_chocolate');
      expect(result.requiredPercent, closeTo(59.9, 0.1));
    });

    test('per serving, a beef portion still beats a chocolate serving', () {
      // The blanket block got this wrong. A 114 g beef portion is
      // 8.02 kg against 1.40 kg for a 30 g chocolate serving -- an 83%
      // reduction, far past anything the statistic choice could undo.
      final result = check(
        const [MealIngredient(itemId: 'dark_chocolate', grams: 30)],
        const [MealIngredient(itemId: 'beef', grams: 114)],
      );
      expect(result.block, VerdictBlock.none);
    });

    test('the required gap comes from the ratio, not a constant', () {
      final result = check(
        const [MealIngredient(itemId: 'cheese', grams: 100)],
        const [MealIngredient(itemId: 'dark_chocolate', grams: 100)],
      );
      // (1 - 1/2.4947) x 100
      expect(result.requiredPercent, closeTo((1 - 1 / 2.4947) * 100, 1e-6));
    });
  });
}
