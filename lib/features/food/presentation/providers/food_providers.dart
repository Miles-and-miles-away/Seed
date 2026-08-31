import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';

import 'package:seed_app/features/food/data/food_items_data.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';

part 'food_providers.g.dart';

// Pure data loads stay autoDispose: rootBundle caches the source
// string and drops it under memory pressure, which a decoded cache
// here would not. The 838 KB parse runs in an isolate, so a revisit
// costs no jank (json_asset_loader).

/// All food items from the bundled dataset.
@riverpod
Future<List<FoodItem>> foodItems(Ref ref) => loadFoodItems();

/// Ids of items picked this session, most recent first.
///
/// keepAlive so the list survives closing the picker, but memory-only
/// like everything else in the calculator -- persisting it would mean
/// adding a local-storage dependency for a convenience, and the payoff
/// is within a session anyway: building two comparable meals means
/// reaching for the same handful of items twice.
@Riverpod(keepAlive: true)
class RecentFoodItemIds extends _$RecentFoodItemIds {
  /// Enough to cover a two-meal comparison without pushing the grouped
  /// list off screen.
  static const maxRecents = 8;

  @override
  List<String> build() => const [];

  /// Records a pick, moving a repeat to the front rather than
  /// duplicating it.
  void record(String itemId) {
    state = List.unmodifiable(
      [itemId, ...state.where((id) => id != itemId)].take(maxRecents),
    );
  }
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
