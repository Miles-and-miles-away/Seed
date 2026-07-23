import 'package:riverpod_annotation/riverpod_annotation.dart';

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

/// Maximum meal options a comparison holds (Phase 8.9: 2-3).
// ponytail: mirrors the transport cap; a plan-level product constant.
const comparisonMaxOptions = 3;

/// Ephemeral meal ingredients for the builder screen.
///
/// autoDispose by design: meals are screen state, never persisted
/// (Phase 8 plan), so leaving the calculator resets the meal.
@riverpod
class MealBuilder extends _$MealBuilder {
  @override
  List<MealIngredient> build() => const [];

  /// Appends an ingredient to the meal.
  void addIngredient(MealIngredient ingredient) =>
      state = [...state, ingredient];

  /// Replaces the ingredient at [index].
  void updateIngredient(int index, MealIngredient ingredient) {
    final ingredients = [...state];
    ingredients[index] = ingredient;
    state = ingredients;
  }

  /// Removes the ingredient at [index].
  void removeIngredient(int index) {
    final ingredients = [...state]..removeAt(index);
    state = ingredients;
  }

  /// Empties the meal (e.g. after staging it for comparison).
  void clear() => state = const [];
}

/// Snapshotted meals staged for side-by-side comparison (8.9).
///
/// autoDispose like [MealBuilder]: comparisons are ephemeral screen
/// state, never persisted (Phase 8 plan).
@riverpod
class MealComparison extends _$MealComparison {
  @override
  List<List<MealIngredient>> build() => const [];

  /// Snapshots [ingredients] as a new option, capped at
  /// [comparisonMaxOptions]. No-ops on an empty meal or when full (the
  /// UI hides the action at the cap; this is the belt-and-braces guard).
  void add(List<MealIngredient> ingredients) {
    if (ingredients.isEmpty || state.length >= comparisonMaxOptions) return;
    state = [...state, List.unmodifiable(ingredients)];
  }

  /// Removes the option at [index].
  void removeAt(int index) {
    final options = [...state]..removeAt(index);
    state = options;
  }

  /// Clears all staged options.
  void clear() => state = const [];
}
