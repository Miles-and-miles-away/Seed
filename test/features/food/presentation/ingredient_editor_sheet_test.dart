import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/serving_preset_model.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/food/presentation/widgets/ingredient_editor_sheet.dart';

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

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        foodItemsProvider.overrideWith((_) async => const [_chicken]),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        // The item is picked from the pool before the sheet opens, so
        // the sheet is only ever the quantity form.
        home: const Scaffold(body: IngredientEditorSheet(item: _chicken)),
      ),
    );
  }

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
}
