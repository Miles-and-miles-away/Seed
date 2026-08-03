import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';

import 'package:seed_app/features/food/data/food_items_data.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';

part 'food_providers.g.dart';

// Pure data loads stay autoDispose: the food asset is small, so
// re-parsing on a screen revisit is cheaper than pinning it for the
// app's lifetime (mirrors the transport providers).

/// All food items from the bundled dataset.
@riverpod
Future<List<FoodItem>> foodItems(Ref ref) => loadFoodItems();

/// Dataset metadata (scope statement, primary source) for the
/// methodology sheet (Phase 8.10).
@riverpod
Future<Map<String, dynamic>> foodMetadata(Ref ref) => loadFoodMetadata();

/// Items indexed by id for calculator lookups.
@riverpod
Future<Map<String, FoodItem>> foodItemsById(Ref ref) async {
  final items = await ref.watch(foodItemsProvider.future);
  return FoodCalculator.byId(items);
}

/// The ingredients of both meal options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back, which autoDispose silently wiped. Still memory-only --
/// nothing is persisted (Phase 8 plan).
@Riverpod(keepAlive: true)
class MealOptions extends _$MealOptions {
  @override
  List<List<MealIngredient>> build() => List.unmodifiable([
    for (var i = 0; i < optionCount; i++) const <MealIngredient>[],
  ]);

  bool _valid(int option) => option >= 0 && option < optionCount;

  List<List<MealIngredient>> _withOption(
    int option,
    List<MealIngredient> ingredients,
  ) => List.unmodifiable([
    for (var i = 0; i < optionCount; i++)
      if (i == option)
        List<MealIngredient>.unmodifiable(ingredients)
      else
        state[i],
  ]);

  /// Appends an ingredient to [option].
  void addIngredient(int option, MealIngredient ingredient) {
    if (!_valid(option)) return;
    state = _withOption(option, [...state[option], ingredient]);
  }

  /// Replaces the ingredient at [index] within [option].
  void updateIngredient(int option, int index, MealIngredient ingredient) {
    if (!_valid(option) || index < 0 || index >= state[option].length) return;
    final ingredients = [...state[option]];
    ingredients[index] = ingredient;
    state = _withOption(option, ingredients);
  }

  /// Removes the ingredient at [index] within [option].
  void removeIngredient(int option, int index) {
    if (!_valid(option) || index < 0 || index >= state[option].length) return;
    final ingredients = [...state[option]]..removeAt(index);
    state = _withOption(option, ingredients);
  }

  /// Empties both options (after banking a choice).
  void clear() => state = build();
}
