import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';

/// Icon for a food group (dataset `group` values).
IconData foodGroupIcon(String group) => switch (group) {
  'meat' => Icons.lunch_dining,
  'seafood' => Icons.set_meal,
  'dairy_eggs' => Icons.egg,
  'plant_protein' => Icons.grass,
  'staples' => Icons.rice_bowl,
  'vegetables' => Icons.eco,
  'fruit' => Icons.apple,
  'drinks' => Icons.local_cafe,
  'treats' => Icons.cookie,
  'oils' => Icons.water_drop,
  _ => Icons.restaurant,
};

/// Localized label for a food group. Unknown groups fall back to the
/// raw id so a dataset addition degrades readably.
String foodGroupLabel(AppLocalizations l10n, String group) => switch (group) {
  'meat' => l10n.foodGroupMeat,
  'seafood' => l10n.foodGroupSeafood,
  'dairy_eggs' => l10n.foodGroupDairyEggs,
  'plant_protein' => l10n.foodGroupPlantProtein,
  'staples' => l10n.foodGroupStaples,
  'vegetables' => l10n.foodGroupVegetables,
  'fruit' => l10n.foodGroupFruit,
  'drinks' => l10n.foodGroupDrinks,
  'treats' => l10n.foodGroupTreats,
  'oils' => l10n.foodGroupOils,
  _ => group,
};

/// Emission-factor line for an item row: kg CO2e per kg as-purchased.
String foodItemFactorLabel(AppLocalizations l10n, FoodItem item) =>
    l10n.foodItemFactorPerKg(_factorText(item.kgCo2ePerKg));

/// One decimal below 10 (e.g. "9.9"), whole numbers above (e.g. "99")
/// -- enough precision for a row subtitle without false exactness.
String _factorText(double kgPerKg) =>
    kgPerKg >= 10 ? kgPerKg.round().toString() : kgPerKg.toStringAsFixed(1);

/// Short label for a comparison option: the name of the ingredient
/// contributing the most CO2e, so "Beef" vs "Chicken" vs "Bean" reads
/// at a glance. Empty meals yield an empty string (guarded by the
/// caller, which never stages an empty meal).
String mealOptionLabel(
  List<MealIngredient> ingredients,
  Map<String, FoodItem> itemsById,
  String locale,
) {
  FoodItem? dominant;
  var maxGrams = -1.0;
  for (final ingredient in ingredients) {
    final item = itemsById[ingredient.itemId];
    if (item == null) continue;
    final grams = FoodCalculator.ingredientCo2eGrams(item, ingredient);
    if (grams > maxGrams) {
      maxGrams = grams;
      dominant = item;
    }
  }
  return dominant?.name(locale) ?? '';
}
