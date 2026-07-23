import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/features/food/presentation/screens/meal_comparison_screen.dart';
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';

const _beef = FoodItem(
  id: 'beef',
  group: 'meat',
  nameEn: 'Beef',
  nameJa: '',
  nameEs: '',
  kgCo2ePerKg: 99.48,
);
const _chicken = FoodItem(
  id: 'chicken',
  group: 'meat',
  nameEn: 'Chicken',
  nameJa: '',
  nameEs: '',
  kgCo2ePerKg: 9.87,
);
const _bean = FoodItem(
  id: 'bean',
  group: 'plant_protein',
  nameEn: 'Bean',
  nameJa: '',
  nameEs: '',
  kgCo2ePerKg: 1.79,
);

final _itemsById = FoodCalculator.byId(const [_beef, _chicken, _bean]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp(List<List<MealIngredient>> options) {
    return ProviderScope(
      overrides: [
        impactEquivalenciesDataProvider.overrideWith(
          (_) async => const [
            EquivalencyMetadata(
              type: EquivalencyType.carKm,
              gramsPerUnit: 170,
              sourceName: 'DEFRA',
              sourceUrl: 'https://example.org',
            ),
          ],
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: MealComparisonScreen(options: options, itemsById: _itemsById),
      ),
    );
  }

  testWidgets('draws a bar per option and the "emits less" delta', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(const [
        [MealIngredient(itemId: 'beef', grams: 100)],
        [MealIngredient(itemId: 'bean', grams: 100)],
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    // Copy rule: "emits ... less than <worst>", never "saves".
    expect(find.textContaining('emits'), findsOneWidget);
    expect(find.textContaining('less than Beef'), findsOneWidget);
    expect(find.textContaining('saves'), findsNothing);
  });

  // Three options: beef 9948g, chicken 987g, bean 179g (100g each).
  // Best=bean, worst=beef.
  const threeOptions = [
    [MealIngredient(itemId: 'beef', grams: 100)],
    [MealIngredient(itemId: 'chicken', grams: 100)],
    [MealIngredient(itemId: 'bean', grams: 100)],
  ];

  testWidgets('banks the chosen-vs-baseline delta, not always best-vs-worst', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildApp(threeOptions));
    await tester.pumpAndSettle();

    // Default: ate bean, instead of beef -> 9948 - 179 = 9769 g.
    expect(find.textContaining('bank the 9.8kg'), findsOneWidget);

    // Change the avoided alternative to chicken (987 g): banked saving
    // drops to 987 - 179 = 808 g.
    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<int>).at(1),
        matching: find.text('Chicken'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('bank the 808g'), findsOneWidget);
    expect(find.textContaining('bank the 9.8kg'), findsNothing);
  });

  testWidgets('disables banking when the two picks are the same meal', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildApp(threeOptions));
    await tester.pumpAndSettle();

    // Set the avoided alternative to bean -- the same as what was eaten.
    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<int>).at(1),
        matching: find.text('Bean'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Pick two different meals'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });
}
