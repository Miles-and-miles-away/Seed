import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  group('RecentFoodItemIds', () {
    test('record moves a repeat to the front without duplicating it', () {
      container.read(recentFoodItemIdsProvider.notifier)
        ..record('rice')
        ..record('tofu')
        ..record('rice');

      expect(container.read(recentFoodItemIdsProvider), ['rice', 'tofu']);
    });

    test('record keeps only the newest maxRecents ids', () {
      final notifier = container.read(recentFoodItemIdsProvider.notifier);
      for (var i = 0; i < RecentFoodItemIds.maxRecents + 2; i++) {
        notifier.record('item-$i');
      }

      final recent = container.read(recentFoodItemIdsProvider);
      expect(recent, hasLength(RecentFoodItemIds.maxRecents));
      expect(recent.first, 'item-${RecentFoodItemIds.maxRecents + 1}');
      expect(recent, isNot(contains('item-0')));
      expect(recent, isNot(contains('item-1')));
    });
  });

  group('MealOptions', () {
    const rice = MealIngredient(itemId: 'rice', grams: 100);
    const tofu = MealIngredient(itemId: 'tofu', grams: 50);

    test('adds, updates and removes within one option', () {
      final notifier = container.read(mealOptionsProvider.notifier)
        ..addIngredient(optionA, rice)
        ..addIngredient(optionB, tofu)
        ..updateIngredient(optionA, 0, tofu);
      expect(container.read(mealOptionsProvider), [
        [tofu],
        [tofu],
      ]);

      notifier.removeIngredient(optionB, 0);
      expect(container.read(mealOptionsProvider), [
        [tofu],
        <MealIngredient>[],
      ]);
    });

    test('ignores out-of-range options and indices', () {
      container.read(mealOptionsProvider.notifier)
        ..addIngredient(optionA, rice)
        ..addIngredient(optionCount, tofu)
        ..updateIngredient(optionA, 1, tofu)
        ..updateIngredient(optionCount, 0, tofu)
        ..removeIngredient(optionA, 1)
        ..removeIngredient(optionA, -1)
        ..removeIngredient(-1, 0);

      expect(container.read(mealOptionsProvider), [
        [rice],
        <MealIngredient>[],
      ]);
    });

    test('starts with exactly optionCount empty options', () {
      expect(container.read(mealOptionsProvider), hasLength(optionCount));
      expect(
        container.read(mealOptionsProvider).every((o) => o.isEmpty),
        isTrue,
      );
    });

    test('clear empties both options', () {
      container.read(mealOptionsProvider.notifier)
        ..addIngredient(optionA, rice)
        ..addIngredient(optionB, tofu)
        ..clear();

      expect(
        container.read(mealOptionsProvider).every((o) => o.isEmpty),
        isTrue,
      );
    });
  });
}
