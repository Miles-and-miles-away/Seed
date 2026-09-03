import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/energy.dart';
import 'package:seed_app/shared/widgets/comparison_widgets.dart';

const _oneUse = UsagePreset(
  id: 'one',
  nameEn: '1 use',
  nameJa: '',
  nameEs: '',
  units: 1,
);

EnergyBehavior _behavior(
  String id,
  String group,
  EnergyCarrier carrier,
  double kwh, {
  EnergyUnit unit = EnergyUnit.use,
}) => EnergyBehavior(
  id: id,
  comparableGroup: group,
  carrier: carrier,
  unit: unit,
  kwhPerUnit: kwh,
  nameEn: id,
  nameJa: '',
  nameEs: '',
  presets: const [_oneUse],
  defaultPresetId: 'one',
);

final _behaviors = [
  _behavior('heater', 'space_heat', EnergyCarrier.electricity, 1.2),
  _behavior('kotatsu', 'space_heat', EnergyCarrier.electricity, 0.15),
  _behavior('kettle', 'boil', EnergyCarrier.electricity, 0.116278),
  _behavior('gas_hob', 'boil', EnergyCarrier.gas, 0.282389),
  _behavior('bath_gas', 'hot_water', EnergyCarrier.gas, 7.526854),
  _behavior('shower_gas', 'hot_water', EnergyCarrier.gas, 3.28036),
  _behavior('line_dry', 'laundry_dry', EnergyCarrier.none, 0),
  _behavior('dryer', 'laundry_dry', EnergyCarrier.electricity, 4.5),
  _behavior('phone_charge', 'device', EnergyCarrier.electricity, 0.015271),
];

double _contrast(Color a, Color b) {
  final high = a.computeLuminance() > b.computeLuminance()
      ? a.computeLuminance()
      : b.computeLuminance();
  final low = a.computeLuminance() > b.computeLuminance()
      ? b.computeLuminance()
      : a.computeLuminance();
  return (high + 0.05) / (low + 0.05);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        energyBehaviorsProvider.overrideWith((_) async => _behaviors),
        energyCarrierFactorsProvider.overrideWith(
          (_) async => const CarrierFactors(grid: 458, gas: 182),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: EnergyCalculatorScreen(),
      ),
    );
  }

  /// Adds a usage through the shipped path: the per-column "Add"
  /// button opens the picker, then the quantity editor confirms with
  /// its own "Add" button (the last one in the tree while the sheet
  /// is up).
  Future<void> addUsage(
    WidgetTester tester, {
    required String behaviorName,
    int column = 0,
    String? amount,
  }) async {
    await tester.tap(find.text('Add').at(column));
    await tester.pumpAndSettle();
    // Scoped to the picker sheet so a column card with the same name
    // never intercepts. The list builds lazily, so a first-time pick
    // may need scrolling; a re-pick is already built in the recents
    // row at the top. scrollUntilVisible wants exactly one match,
    // which holds for first-time picks (no recents entry yet).
    final inPicker = find.descendant(
      of: find.byType(EnergyBehaviorPicker),
      matching: find.text(behaviorName),
    );
    if (inPicker.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        inPicker,
        200,
        scrollable: find.byType(Scrollable).last,
      );
    }
    await tester.tap(inPicker.first);
    await tester.pumpAndSettle();
    if (amount != null) {
      await tester.enterText(find.byType(TextField).last, amount);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Add').last);
    await tester.pumpAndSettle();
  }

  group('EnergyCalculatorScreen', () {
    testWidgets('starts with two empty columns and no result', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
      expect(find.text('Build both options to compare them'), findsOneWidget);
      expect(
        find.text('Add something you do at home to build this routine'),
        findsNWidgets(2),
      );
      expect(find.byType(OptionEntryCard), findsNothing);
    });

    testWidgets('a passing verdict leads with the kWh ratio (E7)', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'heater');
      await addUsage(tester, behaviorName: 'kotatsu', column: 1);

      // 1.2 / 0.15 kWh: the multiple leads, the gram saving and the
      // phone-charge equivalency follow, the basis notes close.
      expect(
        find.text('Option A costs 8.0x as much CO2e as Option B'),
        findsOneWidget,
      );
      // (1.2 - 0.15) kWh x 458 = 481 g; / 0.015271 kWh = 69 charges.
      expect(
        find.text("That's 481g saved, about 69 phone charges of electricity"),
        findsOneWidget,
      );
      // The any-grid clause ships only where a multiple is on screen.
      expect(
        find.textContaining(
          'world-average grid, 458 g CO2e/kWh (Ember, 2025 data); the '
          'multiple holds on any grid',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'This calculator is for learning. It awards no points and '
          'logs nothing.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('a single phone charge reads singular', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'phone_charge');
      await addUsage(
        tester,
        behaviorName: 'phone_charge',
        column: 1,
        amount: '2',
      );

      // One charge of delta rounds to 1, which shipped as "1 phone
      // charges" until the count got an ICU plural.
      expect(
        find.text("That's 7g saved, about 1 phone charge of electricity"),
        findsOneWidget,
      );
    });

    testWidgets('a same-carrier gas pair gets a ratio but no phone charges', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'bath_gas');
      await addUsage(tester, behaviorName: 'shower_gas', column: 1);

      // 7.526854 / 3.28036 kWh = 2.29x. A gas kWh is fuel input, so
      // the delta is never converted to phone charges (rule 27).
      expect(
        find.text('Option A costs 2.3x as much CO2e as Option B'),
        findsOneWidget,
      );
      expect(find.textContaining('phone charges'), findsNothing);
      expect(find.textContaining('saved'), findsOneWidget);
    });

    testWidgets('a zero-kWh winner falls back to the gram delta', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'line_dry');
      await addUsage(tester, behaviorName: 'dryer', column: 1);

      // Line drying has no multiple; the honest form is the delta
      // sentence, and the phone-charge line still applies (4.5 kWh).
      expect(find.textContaining('x as much CO2e'), findsNothing);
      expect(
        find.textContaining('less than Option B (100% lower)'),
        findsOneWidget,
      );
      expect(
        find.text("That's about 295 phone charges of electricity"),
        findsOneWidget,
      );
    });

    testWidgets('a mixed-carrier pair falls back to the gram delta', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'gas_hob');
      await addUsage(tester, behaviorName: 'kettle');
      await addUsage(tester, behaviorName: 'gas_hob', column: 1, amount: '3');
      await addUsage(tester, behaviorName: 'kettle', column: 1);

      // Same group set and carrier set on both sides, so the verdict
      // passes -- but a mixed routine's CO2e multiple moves with the
      // grid, so no invariant multiple exists to state (rule 26).
      expect(find.textContaining('x as much CO2e'), findsNothing);
      expect(find.textContaining('less than Option B'), findsOneWidget);
      // ...so the basis note must not claim one holds on any grid: a
      // mixed pair's CO2e multiple is exactly what moves with the grid.
      expect(
        find.textContaining('the multiple holds on any grid'),
        findsNothing,
      );
      expect(find.textContaining('world-average grid, 458'), findsOneWidget);
    });

    // Each refusal must explain its own reason, not a generic one: the
    // switch routes everything unmatched to the too-close copy through a
    // wildcard arm, so a mis-mapped block would otherwise be invisible.
    //
    // The reason is on screen with the title, not behind a "Why not?"
    // dialog (2026-09-02): a refusal you have to tap to understand
    // reads as a dead end.
    Future<void> expectRefusal(WidgetTester tester, String bodyFragment) async {
      expect(find.text('No winner here'), findsOneWidget);
      expect(find.byType(ComparisonDeltaCard), findsNothing);
      expect(find.text('Why not?'), findsNothing);
      expect(find.textContaining(bodyFragment), findsOneWidget);
      // Stated loudly enough to be read: the title used to be
      // body-small grey, smaller than the copy beneath it.
      final title = tester.widget<Text>(find.text('No winner here'));
      expect(title.style!.fontWeight, FontWeight.bold);
      expect(title.style!.fontSize, greaterThan(14));
    }

    testWidgets('a cross-group pair refuses as a category error', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'heater');
      await addUsage(tester, behaviorName: 'kettle', column: 1);
      await expectRefusal(tester, 'category error');
    });

    testWidgets('a cross-carrier pair refuses with the crossover copy', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'kettle');
      await addUsage(tester, behaviorName: 'gas_hob', column: 1);
      await expectRefusal(tester, '241 g CO2e per kWh');
    });

    testWidgets('a sub-20% pair refuses naming the bar', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'kettle');
      await addUsage(tester, behaviorName: 'kettle', column: 1, amount: '1.1');
      await expectRefusal(tester, 'within 20% of each other');
    });

    testWidgets('the delta card wears the energy colour, readably', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'heater');
      await addUsage(tester, behaviorName: 'kotatsu', column: 1);

      final card = tester.widget<Card>(
        find
            .descendant(
              of: find.byType(ComparisonDeltaCard),
              matching: find.byType(Card),
            )
            .first,
      );
      // A tint of the category colour behind readable ink of the same
      // hue -- not the scheme's primaryContainer.
      expect(
        card.color,
        ActionCategory.energy.color.withValues(alpha: opacitySubtle),
      );
      expect(
        tester
            .widget<Text>(
              find.text('Option A costs 8.0x as much CO2e as Option B'),
            )
            .style!
            .color,
        ActionCategory.energy.textColorOn(Brightness.light, large: true),
      );
    });

    testWidgets('the add button wears the energy colour', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // It was the scheme's tonal blue on all three calculators.
      final button = tester.widget<FilledButton>(
        find
            .ancestor(
              of: find.text('Add').first,
              matching: find.byType(FilledButton),
            )
            .first,
      );
      final style = button.style!;
      const states = <WidgetState>{};
      // Solid category colour with dark ink on it: white on amber is
      // 1.9:1, near-black 11:1.
      expect(
        style.backgroundColor!.resolve(states),
        ActionCategory.energy.color,
      );
      final label = style.foregroundColor!.resolve(states)!;
      expect(
        _contrast(label, ActionCategory.energy.color),
        greaterThanOrEqualTo(4.5),
        reason: 'the label has to read on the fill',
      );
    });

    testWidgets('the column bars wear the energy category colour', (
      tester,
    ) async {
      // The bars were the scheme's primary in all three calculators, so
      // nothing on screen said which domain you were in.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'heater');
      await addUsage(tester, behaviorName: 'kotatsu', column: 1);

      final bars = tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .toList();
      expect(bars, hasLength(2));
      final energy = ActionCategory.energy.color;
      expect(bars.map((b) => b.valueColor!.value).toSet(), {
        energy,
        energy.withValues(alpha: opacityMuted),
      });
    });

    testWidgets('removing a usage empties the column again', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addUsage(tester, behaviorName: 'kettle');

      await tester.tap(find.byTooltip('Remove'));
      await tester.pumpAndSettle();
      expect(find.byType(OptionEntryCard), findsNothing);
    });
  });
}
