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

/// Every ingredient in a meal, heaviest-emitting first, joined for the
/// banked action name ("Beef + Rice").
///
/// Used only where the meal has to describe itself outside the
/// two-column screen -- chiefly the logged custom action, which lands
/// in the action history with no columns around it. On screen the
/// options are named "Option A" / "Option B"; naming a single
/// dominant ingredient there read as an arbitrary pick from the list.
String mealSummaryLabel(
  List<MealIngredient> ingredients,
  Map<String, FoodItem> itemsById,
  String locale,
) {
  final ranked = <(String, double)>[];
  for (final ingredient in ingredients) {
    final item = itemsById[ingredient.itemId];
    if (item == null) continue;
    ranked.add((
      item.name(locale),
      FoodCalculator.ingredientCo2eGrams(item, ingredient),
    ));
  }
  ranked.sort((a, b) => b.$2.compareTo(a.$2));
  final parts = <String>[];
  for (final (name, _) in ranked) {
    if (!parts.contains(name)) parts.add(name);
  }
  return parts.join(' + ');
}

/// Short label for a comparison option: the name of the ingredient
/// contributing the most CO2e.
///
/// Retained for the analytics event; user-facing copy uses
/// [mealSummaryLabel] or the column names.
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

/// Accent-insensitive, case-insensitive key for search matching.
///
/// A Spanish user types "platano", not "plátano", and "jalapeno" for
/// "jalapeño" -- without folding, the two most common ES queries miss.
String foldForSearch(String value) {
  final buffer = StringBuffer();
  for (final rune in value.toLowerCase().runes) {
    buffer.write(_diacritics[rune] ?? String.fromCharCode(rune));
  }
  return buffer.toString();
}

const _diacritics = <int, String>{
  0xE1: 'a', 0xE0: 'a', 0xE2: 'a', 0xE4: 'a', 0xE3: 'a', // á à â ä ã
  0xE9: 'e', 0xE8: 'e', 0xEA: 'e', 0xEB: 'e', // é è ê ë
  0xED: 'i', 0xEC: 'i', 0xEE: 'i', 0xEF: 'i', // í ì î ï
  0xF3: 'o', 0xF2: 'o', 0xF4: 'o', 0xF6: 'o', 0xF5: 'o', // ó ò ô ö õ
  0xFA: 'u', 0xF9: 'u', 0xFB: 'u', 0xFC: 'u', // ú ù û ü
  0xF1: 'n', 0xE7: 'c', // ñ ç
};

/// Items matching [query], ranked: name-prefix hits first, then any
/// other hit, each preserving dataset order.
///
/// Matches all three locale names, not just the active one, so a user
/// who knows a food by its Japanese or Spanish name still finds it --
/// the dataset is deliberately multi-market. Returns every item, in
/// dataset order, for a blank query.
List<FoodItem> searchFoodItems(List<FoodItem> items, String query) {
  final needle = foldForSearch(query.trim());
  if (needle.isEmpty) return items;
  final prefix = <FoodItem>[];
  final contains = <FoodItem>[];
  final aliasPrefix = <FoodItem>[];
  final aliasContains = <FoodItem>[];
  for (final item in items) {
    final names = [item.nameEn, item.nameJa, item.nameEs].map(foldForSearch);
    if (names.any((n) => n.startsWith(needle))) {
      prefix.add(item);
    } else if (names.any((n) => n.contains(needle)) ||
        foldForSearch(item.id).contains(needle)) {
      contains.add(item);
    } else {
      // Aliases rank last: "carrots" must find Root vegetables, but an
      // item whose own name matches should always outrank one that
      // merely lists the word as a member. Within aliases a whole-term
      // hit beats a substring, so "chips" finds Potatoes rather than
      // whatever item happens to list "fish and chips".
      final terms = item.searchTerms.map(foldForSearch);
      if (terms.any((t) => t.startsWith(needle))) {
        aliasPrefix.add(item);
      } else if (terms.any((t) => t.contains(needle))) {
        aliasContains.add(item);
      }
    }
  }
  return [...prefix, ...contains, ...aliasPrefix, ...aliasContains];
}
