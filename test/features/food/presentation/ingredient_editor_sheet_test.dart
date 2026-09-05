import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/serving_preset_model.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/food/presentation/widgets/ingredient_editor_sheet.dart';

import '../../../helpers/test_helpers.dart';

/// A dose-dominated item: 10 g of grounds against a 28.53 kg/kg factor,
/// so the grams field is a trap and the preset is the safe default.
const _coffee = FoodItem(
  id: 'coffee',
  group: 'drinks',
  nameEn: 'Coffee',
  nameJa: '',
  nameEs: '',
  kgCo2ePerKg: 28.53,
  entryMode: 'preset_only',
  defaultServingId: 'cup_10g',
  weightBasis: 'dry',
  servings: [
    ServingPreset(
      id: 'cup_10g',
      nameEn: '1 cup (10 g of grounds)',
      nameJa: '',
      nameEs: '',
      grams: 10,
    ),
  ],
);

const _chicken = FoodItem(
  id: 'chicken',
  group: 'meat',
  nameEn: 'Chicken',
  nameJa: '',
  nameEs: '',
  kgCo2ePerKg: 9.87,
  servings: [
    ServingPreset(
      id: 'breast',
      nameEn: '1 breast',
      nameJa: '',
      nameEs: '',
      grams: 170,
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // The item is picked from the pool before the sheet opens, so the
  // sheet is only ever the quantity form.
  Widget buildApp() => createTestWidget(
    overrides: [
      foodItemsProvider.overrideWith((_) async => const [_chicken]),
    ],
    scaffold: true,
    child: const IngredientEditorSheet(item: _chicken),
  );

  testWidgets('tapping a serving preset fills the editable grams field', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Field starts empty; the preset chip fills it with the preset grams.
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '',
    );
    await tester.tap(find.text('1 breast'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '170',
    );
  });

  group('dose-dominated items', () {
    Widget buildCoffee() => createTestWidget(
      overrides: [
        foodItemsProvider.overrideWith((_) async => const [_coffee]),
      ],
      scaffold: true,
      child: const IngredientEditorSheet(item: _coffee),
    );

    testWidgets('opens on the default preset instead of an empty field', (
      tester,
    ) async {
      // The shipped behaviour was an autofocused empty grams field, so
      // "250" (millilitres of drink) computed a 7.13 kg cup -- roughly
      // 25x the real one (the coffee per-cup rule,
      // PDR_FOOD_CALCULATOR.md).
      await tester.pumpWidget(buildCoffee());
      await tester.pumpAndSettle();

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, '10');
      expect(field.autofocus, isFalse);
    });

    testWidgets('states what to weigh', (tester) async {
      await tester.pumpWidget(buildCoffee());
      await tester.pumpAndSettle();
      expect(find.textContaining('Dry weight'), findsOneWidget);
    });
  });
}
