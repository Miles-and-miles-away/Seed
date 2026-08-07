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

  /// Whether the comparison may state a verdict and offer to bank the
  /// difference, or must show the bars without calling a winner.
  ///
  /// Ties are not a failure to compute -- they are the honest answer,
  /// and the feature exists to surface real differences rather than
  /// manufacture them.
  static bool mayStateVerdict(
    ComparisonSummary summary,
    Map<String, FoodItem> itemsById,
    List<List<MealIngredient>> options,
  ) {
    if (summary.deltaGrams <= 0) return false;
    final tiers = <int>{};
    for (final option in options) {
      for (final ingredient in option) {
        final item = itemsById[ingredient.itemId];
        if (item == null) continue;
        // A food whose own mean and median differ by 2x or more carries
        // that ambiguity into any total it joins, and no threshold
        // clears it: cheese and dark chocolate are 48.8% apart on means
        // and still swap places on medians.
        if (item.statisticSensitive) return false;
        tiers.add(item.sourceTier);
      }
    }
    // More than one tier anywhere in the comparison -- across the two
    // meals or inside one of them -- means the totals are not on one
    // measurement basis.
    final floor = tiers.length > 1 ? crossTierMinPercent : verdictMinPercent;
    return summary.deltaPercent >= floor;
  }
}
