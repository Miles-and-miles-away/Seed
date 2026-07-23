import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_ingredient_model.freezed.dart';

/// One ingredient of a meal: a food item in a quantity of grams (ml for
/// liquids, at density 1.0). Ephemeral screen state, never persisted.
@freezed
abstract class MealIngredient with _$MealIngredient {
  const factory MealIngredient({
    required String itemId,
    required double grams,
  }) = _MealIngredient;
}
