import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';

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
}
