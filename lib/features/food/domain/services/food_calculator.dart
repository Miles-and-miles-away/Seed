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

  /// Total CO2e grams for a meal.
  ///
  /// Throws [ArgumentError] if an ingredient references an unknown item
  /// id -- the dataset is static, so that is a programming error.
  static double mealCo2eGrams(
    Map<String, FoodItem> itemsById,
    List<MealIngredient> ingredients,
  ) {
    var total = 0.0;
    for (final ingredient in ingredients) {
      final item = itemsById[ingredient.itemId];
      if (item == null) {
        throw ArgumentError.value(
          ingredient.itemId,
          'itemId',
          'unknown food item',
        );
      }
      total += ingredientCo2eGrams(item, ingredient);
    }
    return total;
  }

  /// Index for [mealCo2eGrams] lookups.
  static Map<String, FoodItem> byId(List<FoodItem> items) => {
    for (final i in items) i.id: i,
  };

  /// Minimum reduction, in percent, before the comparison is allowed to
  /// name a winner (RESEARCH_FOOD.md section 8, rule 4).
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
        final item = itemsById[ingredient.itemId];
        if (item == null) continue;
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
    if (summary.deltaPercent < floor) {
      return VerdictCheck(
        tiers.length > 1 ? VerdictBlock.crossSource : VerdictBlock.tooClose,
        floor,
      );
    }
    return const VerdictCheck(VerdictBlock.none, 0);
  }

  /// Ties are not a failure to compute -- they are the honest answer,
  /// and the feature exists to surface real differences rather than
  /// manufacture them.
  static bool mayStateVerdict(
    ComparisonSummary summary,
    Map<String, FoodItem> itemsById,
    List<List<MealIngredient>> options,
  ) => checkVerdict(summary, itemsById, options).block == VerdictBlock.none;
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
