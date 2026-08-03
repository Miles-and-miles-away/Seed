import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/food/data/food_items_data.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';

/// Exercises the model + loader (the raw-JSON contract is validated
/// separately in food_items_data_test.dart, which must not be weakened
/// to model parsing -- defaults would mask a missing field there).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<FoodItem> items;

  setUpAll(() async {
    items = await loadFoodItems();
  });

  test('loads every item as a typed model', () {
    expect(items.length, FOOD_ITEM_COUNT);
  });

  test('parses factors, servings and sources into typed fields', () {
    final beef = items.firstWhere((i) => i.id == 'beef');
    expect(beef.group, 'meat');
    expect(beef.kgCo2ePerKg, 70.3608);
    expect(beef.nameEn, isNotEmpty);
    expect(beef.servings, isNotEmpty);
    expect(beef.servings.first.grams, greaterThan(0));
    expect(beef.sources, isNotEmpty);
    expect(beef.sources.first.url, startsWith('https://'));
  });

  test('name() falls back to English for a blank locale field', () {
    final item = items.first;
    expect(item.name('en'), item.nameEn);
    expect(item.name('xx'), item.nameEn);
  });
}
