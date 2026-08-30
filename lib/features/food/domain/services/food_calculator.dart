import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';

/// Pure CO2e arithmetic for meals.
///
/// Educational feature: results are never converted to points or logged
/// CO2 savings inside the calculator (No Fake Points principle, Phase 8
/// plan). Banking a chosen meal is a separate, explicit user action.
class FoodCalculator {
  const FoodCalculator._();

  /// CO2e grams for a single ingredient.
  ///
  /// [FoodItem.kgCo2ePerKg] is kg CO2e per kg of food, so per gram it is
  /// numerically the same value in grams CO2e -- hence `factor * grams`.
  /// Throws [ArgumentError] on negative grams.
  static double ingredientCo2eGrams(FoodItem item, MealIngredient ingredient) {
    if (ingredient.grams < 0) {
      throw ArgumentError.value(ingredient.grams, 'grams', 'must be >= 0');
    }
    return item.kgCo2ePerKg * ingredient.grams;
  }

  /// The item an ingredient names, or [ArgumentError] if the dataset
  /// does not have it. The dataset is static, so a miss is a
  /// programming error.
  ///
  /// Every path uses this. [mealCo2eGrams] threw while [checkVerdict]
  /// skipped, so an unknown id dropped that ingredient from the tier
  /// set, the statistic scan and the flattened totals -- making the
  /// gate more permissive than the totals it is supposed to guard.
  static FoodItem _require(Map<String, FoodItem> itemsById, String itemId) {
    final item = itemsById[itemId];
    if (item == null) {
      throw ArgumentError.value(itemId, 'itemId', 'unknown food item');
    }
    return item;
  }

  /// Total CO2e grams for a meal.
  ///
  /// Throws [ArgumentError] if an ingredient references an unknown item
  /// id.
  static double mealCo2eGrams(
    Map<String, FoodItem> itemsById,
    List<MealIngredient> ingredients,
  ) {
    var total = 0.0;
    for (final ingredient in ingredients) {
      total += ingredientCo2eGrams(
        _require(itemsById, ingredient.itemId),
        ingredient,
      );
    }
    return total;
  }

  /// Index for [mealCo2eGrams] lookups.
  static Map<String, FoodItem> byId(List<FoodItem> items) => {
    for (final i in items) i.id: i,
  };

  /// Minimum reduction, in percent, before the comparison is allowed to
  /// name a winner (the comparative-copy rule in
  /// PDR_FOOD_CALCULATOR.md).
  ///
  /// Below this the two meals sit inside the dataset's own resolution:
  /// a great many items are statistically tied by construction (whole
  /// clusters share one Poore & Nemecek category value), so a verdict
  /// would be reading precision the sources do not have.
  static const verdictMinPercent = 20.0;

  /// Minimum reduction when the two meals do not draw on the same
  /// source tier -- a doubling, not 20%.
  ///
  /// A tier-2 row (the species-resolved seafood, for instance) is
  /// measured to a narrower boundary than the Poore & Nemecek tier-1
  /// rows, so it reads systematically low against them. Only a gap far
  /// wider than that offset survives the mismatch.
  static const crossTierMinPercent = 50.0;

  /// Whether the comparison may state a verdict, and if not, why.
  ///
  /// The reason is part of the answer: a user who is told "not enough
  /// difference" deserves to know whether that is because the meals are
  /// genuinely close, or because one ingredient's own evidence is too
  /// wide to rank on.
  static VerdictCheck checkVerdict(
    ComparisonSummary summary,
    Map<String, FoodItem> itemsById,
    List<List<MealIngredient>> options,
  ) {
    if (summary.deltaGrams <= 0) {
      return const VerdictCheck(VerdictBlock.tooClose, verdictMinPercent);
    }
    final tiers = <int>{};
    FoodItem? widest;
    var widestRatio = 0.0;
    for (final option in options) {
      for (final ingredient in option) {
        final item = _require(itemsById, ingredient.itemId);
        tiers.add(item.sourceTier);
        final ratio = item.statisticRatio;
        if (ratio != null && ratio > widestRatio) {
          widest = item;
          widestRatio = ratio;
        }
      }
    }
    // An item whose own two published figures differ by `ratio` can only
    // be ranked once the gap outruns that spread: the better meal has to
    // emit less than 1/ratio of the other. Blanket-blocking these was
    // too blunt -- a beef portion beats a chocolate serving 6x over,
    // which no statistic choice reverses.
    if (widest != null) {
      final required = (1 - 1 / widestRatio) * 100;
      if (summary.deltaPercent < required) {
        return VerdictCheck(VerdictBlock.uncertainItem, required, widest);
      }
    }
    final floor = tiers.length > 1 ? crossTierMinPercent : verdictMinPercent;
    // Ahead of the tie-group check: a gap already inside the floor is
    // too close on its own terms, and blaming a tie group for it told
    // the user their ingredients disagree when they hold one value.
    if (summary.deltaPercent < floor) {
      return VerdictCheck(
        tiers.length > 1 ? VerdictBlock.crossSource : VerdictBlock.tooClose,
        floor,
      );
    }
    // Items sharing a tie group carry one source row between them, so
    // where two of them disagree the disagreement is an artefact of the
    // derivation rather than a measured difference. Re-run the
    // comparison with those flattened: a verdict that does not survive
    // was reading the artefact. Tree nuts (0.43, and only that low
    // because of an orchard land-use credit) against peanuts (3.23) is
    // the case this exists for.
    final flattened = _totalsWithTiesFlattened(itemsById, options);
    if (flattened != null) {
      final tied = compareTotals(flattened);
      if (tied != null && tied.bestIndex != summary.bestIndex) {
        return VerdictCheck(VerdictBlock.tiedBasisFlips, floor);
      }
      if (tied == null || tied.deltaPercent < floor) {
        return VerdictCheck(VerdictBlock.tiedBasis, floor);
      }
    }
    return const VerdictCheck(VerdictBlock.none, 0);
  }

  /// Option totals with every tie group that spans the options flattened
  /// to its lowest member factor, or null when no group spans them.
  ///
  /// A tie group confined to one option adds the same mass to that
  /// option either way, so it cannot manufacture a delta; only groups
  /// appearing on both sides can.
  static List<double>? _totalsWithTiesFlattened(
    Map<String, FoodItem> itemsById,
    List<List<MealIngredient>> options,
  ) {
    final sides = <String, Set<int>>{};
    for (var i = 0; i < options.length; i++) {
      for (final ingredient in options[i]) {
        final group = _require(itemsById, ingredient.itemId).tieGroup;
        if (group != null) (sides[group] ??= <int>{}).add(i);
      }
    }
    final floors = <String, double>{};
    for (final option in options) {
      for (final ingredient in option) {
        final item = _require(itemsById, ingredient.itemId);
        final group = item.tieGroup;
        if (group == null) continue;
        if ((sides[group]?.length ?? 0) < 2) continue;
        final current = floors[group];
        if (current == null || item.kgCo2ePerKg < current) {
          floors[group] = item.kgCo2ePerKg;
        }
      }
    }
    if (floors.isEmpty) return null;
    return [
      for (final option in options)
        option.fold<double>(0, (sum, ingredient) {
          final item = _require(itemsById, ingredient.itemId);
          final group = item.tieGroup;
          final factor = group == null
              ? item.kgCo2ePerKg
              : floors[group] ?? item.kgCo2ePerKg;
          return sum + factor * ingredient.grams;
        }),
    ];
  }
}

/// Why a comparison may not name a winner.
enum VerdictBlock {
  /// It may.
  none,

  /// The two meals are inside the dataset's own resolution.
  tooClose,

  /// The meals draw on sources with different boundaries.
  crossSource,

  /// One ingredient's own published figures are too far apart.
  uncertainItem,

  /// The gap rests on items that share one derivation basis, and
  /// closes once that basis is held to a single value.
  tiedBasis,

  /// Which option wins swaps when the shared derivation basis is held
  /// to a single value, so the winner is an artefact of the source.
  tiedBasisFlips,
}

/// The verdict decision, with enough detail to explain itself.
class VerdictCheck {
  const VerdictCheck(this.block, this.requiredPercent, [this.item]);

  final VerdictBlock block;

  /// The reduction this comparison would have needed, in percent.
  final double requiredPercent;

  /// The ingredient responsible, when [block] is
  /// [VerdictBlock.uncertainItem].
  final FoodItem? item;
}
