import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/data/models/usage_preset_model.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_behavior_picker.dart';
import 'package:seed_app/features/energy/presentation/widgets/usage_editor_sheet.dart';

EnergyBehavior _behavior(
  String id, {
  required String group,
  required String en,
  EnergyUnit unit = EnergyUnit.use,
  EnergyCarrier carrier = EnergyCarrier.electricity,
  double kwh = 1,
  String confidence = 'high',
  List<UsagePreset> presets = const [],
  String defaultPresetId = '',
}) => EnergyBehavior(
  id: id,
  comparableGroup: group,
  carrier: carrier,
  unit: unit,
  kwhPerUnit: kwh,
  nameEn: en,
  nameJa: en,
  nameEs: en,
  presets: presets,
  defaultPresetId: defaultPresetId,
  confidence: confidence,
);

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  group('EnergyBehaviorPicker', () {
    final behaviors = [
      _behavior('bath_electric', group: 'hot_water', en: 'Bath'),
      _behavior(
        'shower_electric',
        group: 'hot_water',
        en: 'Shower',
        unit: EnergyUnit.minute,
        kwh: 0.248111,
      ),
      _behavior('wash_hot', group: 'laundry_wash', en: 'Hot wash'),
      _behavior(
        'standby',
        group: 'device',
        en: 'Standby',
        unit: EnergyUnit.day,
        kwh: 0.8,
        confidence: 'low',
      ),
    ];

    testWidgets('renders a heading per group', (tester) async {
      await tester.pumpWidget(
        _wrap(
          EnergyBehaviorPicker(
            behaviors: behaviors,
            onSelected: (_) {},
            onInfo: (_) {},
          ),
        ),
      );
      expect(find.text('Hot water'), findsOneWidget);
      expect(find.text('Laundry: washing'), findsOneWidget);
      expect(find.text('Devices'), findsOneWidget);
    });

    testWidgets('shows the kWh factor in the behavior unit', (tester) async {
      await tester.pumpWidget(
        _wrap(
          EnergyBehaviorPicker(
            behaviors: behaviors,
            onSelected: (_) {},
            onInfo: (_) {},
          ),
        ),
      );
      // Per minute for the shower, per day for standby: the unit is
      // part of the number's meaning.
      expect(find.text('0.248 kWh per minute'), findsOneWidget);
      // Trailing zeros stripped: "0.800" would claim precision the
      // standby figure does not have.
      expect(find.text('0.8 kWh per day'), findsOneWidget);
      expect(find.text('1 kWh per use'), findsWidgets);
    });

    testWidgets('flags the low-confidence entry on its own row', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          EnergyBehaviorPicker(
            behaviors: behaviors,
            onSelected: (_) {},
            onInfo: (_) {},
          ),
        ),
      );
      expect(find.text('Least certain figure in this dataset'), findsOneWidget);
    });

    testWidgets('recents appear above the groups and are not duplicated away', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          EnergyBehaviorPicker(
            behaviors: behaviors,
            recentIds: const ['wash_hot'],
            onSelected: (_) {},
            onInfo: (_) {},
          ),
        ),
      );
      expect(find.text('Recently used'), findsOneWidget);
      // Once as a recent, once in its own group: a shortcut, not a move.
      expect(find.text('Hot wash'), findsNWidgets(2));
    });

    testWidgets('tapping a tile selects it, info button does not', (
      tester,
    ) async {
      EnergyBehavior? picked;
      EnergyBehavior? informed;
      await tester.pumpWidget(
        _wrap(
          EnergyBehaviorPicker(
            behaviors: behaviors,
            onSelected: (b) => picked = b,
            onInfo: (b) => informed = b,
          ),
        ),
      );
      await tester.tap(find.text('Bath'));
      expect(picked?.id, 'bath_electric');
      expect(informed, isNull);

      await tester.tap(find.byIcon(Icons.info_outline).first);
      expect(informed, isNotNull);
    });

    testWidgets('an unknown recent id is skipped rather than crashing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          EnergyBehaviorPicker(
            behaviors: behaviors,
            recentIds: const ['deleted_behavior'],
            onSelected: (_) {},
            onInfo: (_) {},
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Recently used'), findsNothing);
    });
  });

  group('UsageEditorSheet', () {
    final shower = _behavior(
      'shower_electric',
      group: 'hot_water',
      en: 'Shower',
      unit: EnergyUnit.minute,
      kwh: 0.248111,
      presets: const [
        UsagePreset(
          id: 'quick_5min',
          nameEn: 'A quick shower (5 min)',
          nameJa: '5分',
          nameEs: '5 min',
          units: 5,
        ),
        UsagePreset(
          id: 'typical_10min',
          nameEn: 'A typical shower (10 min)',
          nameJa: '10分',
          nameEs: '10 min',
          units: 10,
        ),
      ],
      defaultPresetId: 'typical_10min',
    );

    /// What the sheet popped, readable once it has closed.
    ///
    /// Not [open]'s return value: that call comes back while the sheet
    /// is still up, so awaiting it there always yielded null and the
    /// assertion on it proved nothing.
    double? returned;

    Future<void> open(WidgetTester tester, {double? initialUnits}) async {
      returned = null;
      await tester.pumpWidget(
        ProviderScope(
          child: _wrap(
            Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  returned = await UsageEditorSheet.show(
                    context,
                    behavior: shower,
                    initialUnits: initialUnits,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('opens on the default preset', (tester) async {
      await open(tester);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, '10');
    });

    testWidgets('an existing entry opens on its own amount', (tester) async {
      await open(tester, initialUnits: 7);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, '7');
    });

    testWidgets('tapping a preset chip fills the amount field', (tester) async {
      await open(tester);
      await tester.tap(find.text('A quick shower (5 min)'));
      await tester.pump();
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, '5');
    });

    testWidgets('returns the typed amount', (tester) async {
      await open(tester);
      await tester.enterText(find.byType(TextField), '3');
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await tester.pumpAndSettle();
      // The sheet is closed and the caller has the value.
      expect(find.byType(TextField), findsNothing);
      expect(returned, 3);
    });

    testWidgets('a comma decimal survives the field and parses', (
      tester,
    ) async {
      // An ES/JA/FR keypad emits ',', which the old digits-and-dot
      // formatter stripped: "1,5" hours became 15 hours, silently.
      await open(tester);
      await tester.enterText(find.byType(TextField), '1,5');
      await tester.pump();
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, '1,5');
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await tester.pumpAndSettle();
      expect(returned, 1.5);
    });

    testWidgets('zero and blank are rejected rather than added', (
      tester,
    ) async {
      await open(tester);
      await tester.enterText(find.byType(TextField), '0');
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await tester.pump();
      expect(find.text('Enter a number greater than zero'), findsOneWidget);
      // Still open: nothing was added.
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await tester.pump();
      expect(find.text('Enter a number greater than zero'), findsOneWidget);
    });
  });
}
