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
  String? tieGroup,
}) => FoodItem(
  id: id,
  group: 'test',
  nameEn: id,
  nameJa: id,
  nameEs: id,
  kgCo2ePerKg: kgPerKg,
  sourceTier: sourceTier,
  statisticRatio: statisticRatio,
  tieGroup: tieGroup,
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

  group('verdict gating', () {
    // The comparative-copy rule (PDR_FOOD_CALCULATOR.md):
    // no "X emits less than Y"
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

    VerdictBlock gate(String a, String b) {
      final options = meals(a, b);
      final totals = options
          .map((o) => FoodCalculator.mealCo2eGrams(byId, o))
          .toList();
      return FoodCalculator.checkVerdict(
        compareTotals(totals)!,
        byId,
        options,
      ).block;
    }

    test('a wide, same-tier gap gets a verdict', () {
      // chicken vs beef: 86% reduction.
      expect(gate('chicken', 'beef'), VerdictBlock.none);
    });

    test('the eggs-vs-rice tie gets none', () {
      // 4.67 vs 4.45 = 4.7%. This pair is on the never-pin list
      // precisely because it is inside the dataset's resolution.
      expect(gate('rice', 'eggs'), VerdictBlock.tooClose);
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
        FoodCalculator.checkVerdict(
          compareTotals(totals)!,
          byId,
          options,
        ).block,
        VerdictBlock.none,
      );
    });

    test('50% exactly is enough cross-tier', () {
      final byId = FoodCalculator.byId([
        item('a', 10, sourceTier: 2),
        item('b', 20),
      ]);
      final options = meals('a', 'b');
      final totals = options
          .map((o) => FoodCalculator.mealCo2eGrams(byId, o))
          .toList();
      // 2000 -> 1000 is a 50.0% reduction, exactly on the bar.
      expect(compareTotals(totals)!.deltaPercent, closeTo(50, 1e-9));
      expect(
        FoodCalculator.checkVerdict(
          compareTotals(totals)!,
          byId,
          options,
        ).block,
        VerdictBlock.none,
      );
      // A hair under it is refused, so the bar cannot drift.
      final under = FoodCalculator.byId([
        item('a', 10.1, sourceTier: 2),
        item('b', 20),
      ]);
      final underTotals = meals(
        'a',
        'b',
      ).map((o) => FoodCalculator.mealCo2eGrams(under, o)).toList();
      expect(
        FoodCalculator.checkVerdict(
          compareTotals(underTotals)!,
          under,
          meals('a', 'b'),
        ).block,
        VerdictBlock.crossSource,
      );
    });

    test('a cross-tier gap needs a doubling, not 20%', () {
      // white_fish (tier 2) vs chicken (tier 1): 9.87 -> 5.125 is a
      // 48.1% reduction, over the 20% bar but under the 2x one, and
      // the tier-2 boundary offset could account for it.
      // Refused as crossSource, not tooClose: it clears the 20% bar
      // and is blocked by the tier mismatch alone.
      expect(gate('white_fish', 'chicken'), VerdictBlock.crossSource);
      // vs beef the gap is 92.7% -- far wider than the offset.
      expect(gate('white_fish', 'beef'), VerdictBlock.none);
    });

    test('an identical pair gets none', () {
      expect(gate('beef', 'beef'), VerdictBlock.tooClose);
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

  group('tie groups', () {
    // Shipped values. Tree nuts sit at 0.43 only because of an orchard
    // land-use credit; without it they are ~3.69, just above peanuts.
    final tied = FoodCalculator.byId([
      item('tree_nuts', 0.43, statisticRatio: 2.15, tieGroup: 'nuts_luc'),
      item('peanuts', 3.23, tieGroup: 'nuts_luc'),
      item('carrots', 0.43, tieGroup: 'root_veg'),
      item('beetroot', 0.43, tieGroup: 'root_veg'),
      item('mushrooms', 2.13, tieGroup: 'mushroom_lca'),
      item('dried_shiitake', 18.61701923076923, tieGroup: 'mushroom_lca'),
      item('beef', 70.3608),
      item('tofu', 3.16),
      item('olive_oil', 10),
    ]);

    VerdictCheck check(List<MealIngredient> a, List<MealIngredient> b) =>
        FoodCalculator.checkVerdict(
          compareTotals([
            FoodCalculator.mealCo2eGrams(tied, a),
            FoodCalculator.mealCo2eGrams(tied, b),
          ])!,
          tied,
          [a, b],
        );

    test('tree nuts are not ranked against peanuts', () {
      // 86.7% apart, which clears both the 20% floor and tree nuts'
      // own 53.5% statistic bar -- so nothing else in the gate catches
      // it. Flattened to one nut figure the meals are identical.
      final result = check(
        const [MealIngredient(itemId: 'tree_nuts', grams: 100)],
        const [MealIngredient(itemId: 'peanuts', grams: 100)],
      );
      expect(result.block, VerdictBlock.tiedBasis);
    });

    test('a tie group inside one option cannot block it', () {
      // Both nuts on one side add the same mass either way, so the
      // beef comparison is untouched.
      final result = check(
        const [
          MealIngredient(itemId: 'tree_nuts', grams: 100),
          MealIngredient(itemId: 'peanuts', grams: 100),
        ],
        const [MealIngredient(itemId: 'beef', grams: 100)],
      );
      expect(result.block, VerdictBlock.none);
    });

    test('tie mates on one shared value do not block anything', () {
      // carrots and beetroot are the same number, so flattening is a
      // no-op and the beef-vs-tofu answer stands.
      final result = check(
        const [
          MealIngredient(itemId: 'beef', grams: 100),
          MealIngredient(itemId: 'carrots', grams: 100),
        ],
        const [
          MealIngredient(itemId: 'tofu', grams: 100),
          MealIngredient(itemId: 'beetroot', grams: 100),
        ],
      );
      expect(result.block, VerdictBlock.none);
    });

    test('an incidental tie does not veto a real difference', () {
      // The mushrooms differ 8.7x across the sides, but beef vs tofu
      // dominates: flattened the gap widens rather than closing.
      final result = check(
        const [
          MealIngredient(itemId: 'beef', grams: 100),
          MealIngredient(itemId: 'mushrooms', grams: 100),
        ],
        const [
          MealIngredient(itemId: 'tofu', grams: 100),
          MealIngredient(itemId: 'dried_shiitake', grams: 100),
        ],
      );
      expect(result.block, VerdictBlock.none);
    });

    test('a verdict the flattening reverses is refused', () {
      // A is 143 g CO2e against B's 323, so A wins on shipped values.
      // Flatten the nut pair and A is 143 against B's 43 -- B wins.
      // A winner that swaps under its own tie group is not a winner,
      // and it gets its own block: the tiedBasis copy would promise
      // the two sides land within the floor, which here they do not.
      final result = check(
        const [
          MealIngredient(itemId: 'tree_nuts', grams: 100),
          MealIngredient(itemId: 'olive_oil', grams: 10),
        ],
        const [MealIngredient(itemId: 'peanuts', grams: 100)],
      );
      expect(result.block, VerdictBlock.tiedBasisFlips);
    });

    test('a flip 80% wide is not reported as landing within the floor', () {
      // Shipped mushroom pair: 1861.7 vs 1065.0 g, B ahead by 42.8%.
      // Flattened to 2.13 it is 213 vs 1065 -- A ahead by 80%. Naming
      // this tiedBasis told the user the meals land within 20% of each
      // other, which is false in both directions.
      final result = check(
        const [MealIngredient(itemId: 'dried_shiitake', grams: 100)],
        const [MealIngredient(itemId: 'mushrooms', grams: 500)],
      );
      expect(result.block, VerdictBlock.tiedBasisFlips);
    });

    test('a sub-floor gap is too close, not a tied basis', () {
      // Two tie mates on one shared factor, 9.1% apart on quantity
      // alone. Flattening is a no-op, so blaming the tie group told
      // the user their ingredients disagree when they hold one value.
      final byId = FoodCalculator.byId([
        item('cabbage', 0.51, tieGroup: 'pn_brassicas'),
        item('broccoli', 0.51, tieGroup: 'pn_brassicas'),
      ]);
      final options = [
        const [MealIngredient(itemId: 'cabbage', grams: 100)],
        const [MealIngredient(itemId: 'broccoli', grams: 110)],
      ];
      final summary = compareTotals([
        for (final o in options) FoodCalculator.mealCo2eGrams(byId, o),
      ])!;
      expect(summary.deltaPercent, closeTo(9.09, 0.01));
      expect(
        FoodCalculator.checkVerdict(summary, byId, options).block,
        VerdictBlock.tooClose,
      );
    });
  });

  group('unknown ids', () {
    final byId = FoodCalculator.byId([item('beef', 70.3608)]);

    test('checkVerdict throws rather than dropping the ingredient', () {
      // Skipping made the gate more permissive than the totals it
      // guards: the dropped item left the tier set, the statistic scan
      // and the flattened totals alike.
      const options = [
        [MealIngredient(itemId: 'unicorn', grams: 100)],
        [MealIngredient(itemId: 'beef', grams: 100)],
      ];
      expect(
        () => FoodCalculator.checkVerdict(
          const ComparisonSummary(
            bestIndex: 0,
            worstIndex: 1,
            deltaGrams: 100,
            deltaPercent: 90,
          ),
          byId,
          options,
        ),
        throwsArgumentError,
      );
    });
  });
}
