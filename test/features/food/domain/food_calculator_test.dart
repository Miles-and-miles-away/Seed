import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';

FoodItem item(String id, double kgPerKg) => FoodItem(
  id: id,
  group: 'test',
  nameEn: id,
  nameJa: id,
  nameEs: id,
  kgCo2ePerKg: kgPerKg,
);

void main() {
  group('ingredientCo2eGrams', () {
    test('factor x grams gives grams CO2e', () {
      // beef 99.48 kg/kg over a 113 g patty.
      final grams = FoodCalculator.ingredientCo2eGrams(
        item('beef', 99.48),
        const MealIngredient(itemId: 'beef', grams: 113),
      );
      expect(grams, closeTo(11241.24, 1e-6));
    });

    test('zero grams is zero', () {
      expect(
        FoodCalculator.ingredientCo2eGrams(
          item('chicken', 9.87),
          const MealIngredient(itemId: 'chicken', grams: 0),
        ),
        0,
      );
    });

    test('negative grams throws', () {
      expect(
        () => FoodCalculator.ingredientCo2eGrams(
          item('chicken', 9.87),
          const MealIngredient(itemId: 'chicken', grams: -1),
        ),
        throwsArgumentError,
      );
    });
  });

  group('mealCo2eGrams', () {
    final byId = FoodCalculator.byId([
      item('chicken', 9.87),
      item('potatoes', 0.46),
      item('beer', 1.2),
    ]);

    test('sums every ingredient', () {
      final total = FoodCalculator.mealCo2eGrams(byId, const [
        MealIngredient(itemId: 'chicken', grams: 170),
        MealIngredient(itemId: 'potatoes', grams: 200),
        MealIngredient(itemId: 'beer', grams: 330),
      ]);
      // 1677.9 + 92 + 396 = 2165.9 g
      expect(total, closeTo(2165.9, 1e-6));
    });

    test('empty meal is zero', () {
      expect(FoodCalculator.mealCo2eGrams(byId, const []), 0);
    });

    test('unknown item id throws', () {
      expect(
        () => FoodCalculator.mealCo2eGrams(byId, const [
          MealIngredient(itemId: 'unicorn', grams: 100),
        ]),
        throwsArgumentError,
      );
    });
  });
}
