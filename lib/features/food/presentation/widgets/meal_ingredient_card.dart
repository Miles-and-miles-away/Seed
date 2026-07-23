import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';

/// One ingredient row in the meal builder: item, quantity, and the
/// ingredient's CO2e. Displayed only -- never converted to points or
/// logged savings (No Fake Points).
class MealIngredientCard extends StatelessWidget {
  const MealIngredientCard({
    required this.ingredient,
    required this.item,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  /// The ingredient to display.
  final MealIngredient ingredient;

  /// The ingredient's resolved food item.
  final FoodItem item;

  /// Opens the ingredient editor.
  final VoidCallback onTap;

  /// Removes the ingredient from the meal.
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final grams = FoodCalculator.ingredientCo2eGrams(item, ingredient);
    return Card(
      margin: const EdgeInsets.only(bottom: spacingSm),
      child: ListTile(
        leading: Icon(
          foodGroupIcon(item.group),
          color: theme.colorScheme.primary,
        ),
        title: Text(item.name(locale)),
        subtitle: Text(l10n.foodGramsValue(_gramsText(ingredient.grams))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatCO2Compact(grams.round()),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.foodRemoveIngredient,
              onPressed: onRemove,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

/// Whole grams drop the decimal; fractional show one place.
String _gramsText(double grams) => grams == grams.roundToDouble()
    ? grams.round().toString()
    : grams.toStringAsFixed(1);
