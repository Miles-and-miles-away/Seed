import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/food.dart';
import 'package:seed_app/shared/widgets/comparison_widgets.dart';

const _beef = FoodItem(
  id: 'beef',
  group: 'meat',
  nameEn: 'Beef',
  nameJa: '',
  nameEs: '',
  kgCo2ePerKg: 99.48,
);

const _beans = FoodItem(
  id: 'beans',
  group: 'plant_protein',
  nameEn: 'Beans',
  nameJa: '',
  nameEs: '',
  kgCo2ePerKg: 1.79,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        foodItemsProvider.overrideWith((_) async => const [_beef, _beans]),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: FoodCalculatorScreen(),
      ),
    );
  }

  /// Adds an ingredient through the shipped path: the per-column
  /// "Add ingredient" button opens the picker, and because the column
  /// is already known the editor confirms with a single Save.
  Future<void> addIngredient(
    WidgetTester tester, {
    required String itemName,
    required String grams,
    int column = 0,
  }) async {
    await tester.tap(find.text('Add ingredient').at(column));
    await tester.pumpAndSettle();
    await tester.tap(find.text(itemName).last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, grams);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  group('FoodCalculatorScreen', () {
    testWidgets('starts with two empty columns and no verdict', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
      expect(find.text('Build both options to compare them'), findsOneWidget);
      expect(find.byType(OptionEntryCard), findsNothing);
    });

    testWidgets('builds a multi-ingredient meal in one column', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addIngredient(tester, itemName: 'Beans', grams: '150');
      await addIngredient(tester, itemName: 'Beef', grams: '50');

      expect(find.byType(OptionEntryCard), findsNWidgets(2));
      expect(find.text('150 g'), findsOneWidget);
      expect(find.text('50 g'), findsOneWidget);
    });

    testWidgets('both columns built shows the delta and the bank action', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addIngredient(tester, itemName: 'Beans', grams: '200');
      await addIngredient(tester, itemName: 'Beef', grams: '200', column: 1);

      // The summary names the columns, not one ingredient from inside
      // them -- naming the dominant item read as an arbitrary pick.
      expect(find.text('Build both options to compare them'), findsNothing);
      expect(find.textContaining('less than Option B'), findsOneWidget);
      expect(find.text('I chose Option A'), findsOneWidget);
      expect(find.textContaining('less than Beef'), findsNothing);
    });

    testWidgets('a sub-20% gap gets no verdict and no bank action', (
      tester,
    ) async {
      // Same item both sides, 200 g vs 220 g: a real 9.1% delta that
      // the gate must refuse to call (RESEARCH_FOOD.md section 8
      // rule 4). Before the gate this shipped a verdict and a reward.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addIngredient(tester, itemName: 'Beans', grams: '200');
      await addIngredient(tester, itemName: 'Beans', grams: '220', column: 1);

      expect(find.textContaining('too close to call'), findsOneWidget);
      expect(find.textContaining('less than'), findsNothing);
      expect(find.text('I chose Option A'), findsNothing);
    });

    testWidgets('removing an ingredient empties the column again', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addIngredient(tester, itemName: 'Beans', grams: '150');

      await tester.tap(find.byTooltip('Remove'));
      await tester.pumpAndSettle();
      expect(find.byType(OptionEntryCard), findsNothing);
    });

    testWidgets('a CO2e total links to a definition of the unit', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Co2eAmount).first);
      await tester.pumpAndSettle();
      expect(find.text('What is CO2e?'), findsOneWidget);
    });
  });
}
