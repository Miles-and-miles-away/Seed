import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/energy.dart';

import '../../../helpers/test_helpers.dart';

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
  double kwh,
) => EnergyBehavior(
  id: id,
  comparableGroup: group,
  carrier: carrier,
  unit: EnergyUnit.use,
  kwhPerUnit: kwh,
  nameEn: id,
  nameJa: '',
  nameEs: '',
  presets: const [_oneUse],
  defaultPresetId: 'one',
);

// All four explore baselines, plus a big row, a zero row and a gas row.
final _behaviors = [
  _behavior('led_bulb', 'lighting', EnergyCarrier.electricity, 0.0085),
  _behavior('phone_charge', 'device', EnergyCarrier.electricity, 0.015271),
  _behavior('kettle', 'boil', EnergyCarrier.electricity, 0.116278),
  _behavior('fan', 'space_cool', EnergyCarrier.electricity, 0.022),
  _behavior('dryer', 'laundry_dry', EnergyCarrier.electricity, 4.5),
  _behavior('line_dry', 'laundry_dry', EnergyCarrier.none, 0),
  _behavior('bath_gas', 'hot_water', EnergyCarrier.gas, 7.526854),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp({List<EnergyBehavior>? behaviors}) => ProviderScope(
    overrides: [
      energyBehaviorsProvider.overrideWith(
        (_) async => behaviors ?? _behaviors,
      ),
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
      home: EnergyExploreScreen(),
    ),
  );

  /// Opens a row's sheet, scrolling it into view first: the list is
  /// longer than the test window.
  Future<void> openRow(WidgetTester tester, String name) async {
    await tester.scrollUntilVisible(find.text(name), 300);
    await tester.ensureVisible(find.text(name));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  Future<void> closeSheet(WidgetTester tester) async {
    await tester.tap(
      find.descendant(
        of: find.byType(EnergyExploreSheet),
        matching: find.byIcon(Icons.close),
      ),
    );
    await tester.pumpAndSettle();
  }

  // A phone-shaped window: the wall sizes its icons to fill the width,
  // so at the default 800x600 everything sits on the maximum size and
  // the ladder never shows itself.
  setUp(
    () => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..physicalSize = const Size(402, 1600)
      ..devicePixelRatio = 1.0,
  );

  tearDown(
    () => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio(),
  );

  group('EnergyExploreScreen', () {
    testWidgets('opens on the LED baseline with bars and the footnote', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('the energy in an hour of LED light'),
        findsOne,
      );
      // 4.5 / 0.0085 = 529x; 0.116278 / 0.0085 = 14x; the anchor 1.0x.
      expect(find.text('529x'), findsOneWidget);
      expect(find.text('14x'), findsOneWidget);
      expect(find.text('1.0x'), findsOneWidget);
      // Every row gets a bar, gas included: one ranking, by energy.
      expect(find.byType(FractionallySizedBox), findsNWidgets(7));
      // Bars and row icons wear the energy category colour rather than
      // the scheme's primary, which follows the mascot's species.
      expect(
        tester
            .widget<ColoredBox>(
              find
                  .descendant(
                    of: find.byType(FractionallySizedBox),
                    matching: find.byType(ColoredBox),
                  )
                  .first,
            )
            .color,
        ActionCategory.energy.color,
      );
      expect(
        tester
            .widget<Icon>(
              find
                  .descendant(
                    of: find.byType(EnergyRankedTable),
                    matching: find.byType(Icon),
                  )
                  .first,
            )
            .color,
        ActionCategory.energy.color,
      );
      // The sqrt distortion is stated wherever the bars are drawn.
      await tester.scrollUntilVisible(
        find.textContaining('Bar lengths use a square-root scale'),
        300,
      );
      expect(
        find.textContaining('Bar lengths use a square-root scale'),
        findsOneWidget,
      );
    });

    testWidgets('the baseline buttons are one size and carry the colour', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Two per row, all four the same size: a Wrap of chips sized each
      // one to its own label, which read as a ragged pile.
      final buttons = <Rect>[
        for (final label in const [
          'LED hour',
          'Phone charge',
          'Kettle litre',
          'Fan hour',
        ])
          tester.getRect(
            find.ancestor(of: find.text(label), matching: find.byType(InkWell)),
          ),
      ];
      expect(buttons.map((r) => r.size).toSet(), hasLength(1));
      expect(buttons[0].top, buttons[1].top);
      expect(buttons[2].top, greaterThan(buttons[0].bottom - 1));

      // The selected one is filled with the energy category's own
      // yellow, not the scheme's default chip colour.
      final selected = tester.widget<Material>(
        find
            .ancestor(
              of: find.text('LED hour'),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(
        selected.color,
        ActionCategory.energy.color.withValues(alpha: opacityLight),
      );
    });

    testWidgets('switching baseline re-expresses every ranked row', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Phone charge'));
      await tester.pumpAndSettle();

      // 4.5 / 0.015271 = 295x; 0.116278 / 0.015271 = 7.6x.
      expect(find.text('295x'), findsOneWidget);
      expect(find.text('7.6x'), findsOneWidget);
      expect(find.text('529x'), findsNothing);
      // The intro names the baseline it is measuring against.
      expect(
        find.textContaining('the energy in a full phone charge'),
        findsOneWidget,
      );
    });

    testWidgets('the gas row ranks by energy, above its electric twin', (
      tester,
    ) async {
      // 7.526854 kWh of gas outranks the 4.5 kWh dryer here, and the
      // note under the list carries what a rank cannot say: those kWh
      // emit less than electric ones on today's average grid.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('bath_gas'), 300);
      expect(
        tester.getTopLeft(find.text('bath_gas')).dy,
        lessThan(tester.getTopLeft(find.text('dryer')).dy),
      );
      expect(find.text('886x'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.textContaining('uses more energy than an electric one'),
        300,
      );
      expect(
        find.textContaining('uses more energy than an electric one'),
        findsOneWidget,
      );
    });

    testWidgets('the rows state energy only, never grams', (tester) async {
      // Grams are grid-dependent and would contradict the order they
      // sit in; the row's sheet carries them instead.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      for (final grams in ['2.6kg', '2.1kg', '1.4kg', '0g']) {
        expect(find.text(grams), findsNothing, reason: '$grams in a row');
      }
    });

    testWidgets('a dataset without a baseline hides that chip', (tester) async {
      await tester.pumpWidget(
        buildApp(
          behaviors: _behaviors.where((b) => b.id != 'led_bulb').toList(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('LED hour'), findsNothing);
      // It falls back to the first baseline the list does have.
      expect(find.text('Phone charge'), findsOneWidget);
      expect(
        find.textContaining('the energy in a full phone charge'),
        findsOneWidget,
      );
      expect(find.text('295x'), findsOneWidget);
    });

    testWidgets('tapping a row opens the what-if sheet on that behavior', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('dryer'));
      await tester.pumpAndSettle();

      expect(find.byType(EnergyExploreSheet), findsOneWidget);
      // The multiple leads with its baseline named, grams follow.
      expect(find.text('529x an hour of LED light'), findsOneWidget);
      expect(find.text('2.1kg'), findsAtLeast(1));
      expect(find.text('1 use'), findsAtLeast(1));
    });

    testWidgets('the sheet can always be closed', (tester) async {
      // A wall of a few thousand icons filled the screen, leaving no
      // barrier to tap and no way back off the sheet.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('dryer'));
      await tester.pumpAndSettle();
      expect(find.byType(EnergyExploreSheet), findsOneWidget);

      await closeSheet(tester);
      expect(find.byType(EnergyExploreSheet), findsNothing);
    });

    testWidgets('the wall fills the width and shrinks as it grows', (
      tester,
    ) async {
      // The size follows from how many icons fill a row, so the block
      // always spans the width and grows downward. Sizing off the
      // slider's maximum instead drew every state of a row the same: a
      // TV row topping out at 112 icons looked identical at 9 and 112.
      double sizeOf() =>
          tester.widget<Text>(find.byKey(wallKey)).style!.fontSize!;

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await openRow(tester, 'kettle');
      final fewIcons = sizeOf();
      final fewWidth = tester.getSize(find.byKey(wallKey)).width;

      // Ten times the amount, ten times the icons.
      await tester.drag(find.byType(Slider), const Offset(500, 0));
      await tester.pumpAndSettle();
      final manyIcons = sizeOf();
      final manyWidth = tester.getSize(find.byKey(wallKey)).width;

      expect(
        manyIcons,
        lessThan(fewIcons),
        reason: 'more icons must never mean bigger icons',
      );
      // Both states span the row rather than trailing off short.
      final available = tester.getSize(find.byType(EnergyExploreSheet)).width;
      expect(fewWidth, greaterThan(available * 0.8));
      expect(manyWidth, greaterThan(available * 0.8));
    });

    testWidgets('the wall icons match the ranked bars exactly', (tester) async {
      // Same colour, same background: a darkened wall beside raw-amber
      // bars read as two different palettes.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      final barColour = tester
          .widget<ColoredBox>(
            find
                .descendant(
                  of: find.byType(FractionallySizedBox),
                  matching: find.byType(ColoredBox),
                )
                .first,
          )
          .color;

      await openRow(tester, 'kettle');
      expect(tester.widget<Text>(find.byKey(wallKey)).style!.color, barColour);
      expect(barColour, ActionCategory.energy.color);
    });

    testWidgets('a handful of icons is drawn large, not tiny', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // led_bulb against itself is one icon at one hour: it gets the
      // full size rather than a lonely 12pt speck.
      await openRow(tester, 'led_bulb');
      expect(
        tester.widget<Text>(find.byKey(wallKey)).style!.fontSize,
        greaterThan(24),
      );
    });

    testWidgets('under one baseline draws one icon at that fraction', (
      tester,
    ) async {
      // Half a phone charge is half an icon, not a rounded-away zero.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kettle litre'));
      await tester.pumpAndSettle();

      // fan is 0.022 / 0.116278 = 0.19 of a kettle litre.
      await openRow(tester, 'fan');
      // Counted in runes, not by splitting: ''.split() returns a
      // one-element list, so an empty wall would pass a length check --
      // and an icon codepoint is two UTF-16 units, so length would not
      // read 1 either.
      final glyphs = tester.widget<Text>(find.byKey(wallKey)).data!;
      expect(glyphs.runes, hasLength(1));
      final size = tester.widget<Text>(find.byKey(wallKey)).style!.fontSize!;
      expect(size, lessThan(24), reason: 'a fraction draws a smaller icon');
      expect(size, greaterThanOrEqualTo(8), reason: 'but never a speck');
    });

    testWidgets('a tall sheet still leaves the barrier reachable', (
      tester,
    ) async {
      // The way out of a modal sheet is the barrier above it. A wall of
      // hundreds of icons made the sheet full-height and took that away.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await openRow(tester, 'dryer');

      final screen = tester.getSize(find.byType(MaterialApp));
      final sheet = tester.getRect(find.byType(EnergyExploreSheet));
      expect(sheet.height, lessThanOrEqualTo(screen.height * 0.9));
      expect(sheet.top, greaterThan(0), reason: 'no barrier left to tap');
    });

    testWidgets('the sheet slider wears the energy colour', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('dryer'));
      await tester.pumpAndSettle();

      // Track, thumb and the value bubble were still the scheme's
      // primary, which follows the mascot species.
      final slider = tester.widget<SliderTheme>(
        find
            .ancestor(
              of: find.byType(Slider),
              matching: find.byType(SliderTheme),
            )
            .first,
      );
      // One colour across the sheet: track, thumb, bubble, headline and
      // wall all wear the category colour as it is.
      const raw = ActionCategory.energy;
      expect(slider.data.activeTrackColor, raw.color);
      expect(slider.data.thumbColor, raw.color);
      expect(slider.data.valueIndicatorColor, raw.color);
      // ...and the bubble's own label has to read on that fill.
      expect(
        contrastRatio(slider.data.valueIndicatorTextStyle!.color!, raw.color),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        tester
            .widget<Text>(find.text('529x an hour of LED light'))
            .style!
            .color,
        raw.color,
      );
    });

    testWidgets('the slider moves the multiple, the grams and the wall', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('dryer'));
      await tester.pumpAndSettle();

      // One icon per baseline, the whole count: an earlier version
      // scaled the icons-per-glyph to the current value, so a 10x drag
      // redrew the same 37 icons and the wall never appeared to move.
      int wallCount() {
        final glyphs = tester.widget<Text>(find.byKey(wallKey)).data!;
        return glyphs.runes.length;
      }

      expect(find.text('Each icon is an hour of LED light'), findsOneWidget);
      expect(wallCount(), 529);
      // 529 icons: past the last anchor, so these sit on the floor.
      double iconSize() =>
          tester.widget<Text>(find.byKey(wallKey)).style!.fontSize!;
      expect(iconSize(), closeTo(12, 0.1));

      // Far right of a 1-10 use range: 10 x 4.5 kWh.
      await tester.drag(find.byType(Slider), const Offset(500, 0));
      await tester.pumpAndSettle();

      // 45 / 0.0085 = 5,294x; 45 kWh x 458 g = 20.6kg.
      expect(find.text('5,294x an hour of LED light'), findsOneWidget);
      expect(find.text('20.6kg'), findsOneWidget);
      expect(find.text('10 x'), findsOneWidget);
      // Ten times the amount really is ten times the icons.
      expect(wallCount(), 5294);
      // 5,294 icons is on the floor too: the floor is where the glyph
      // stays recognisable, not where the wall stays short.
      expect(iconSize(), closeTo(12, 0.1));
    });

    testWidgets('a tapped gas row explains itself', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('bath_gas'), 300);
      await tester.ensureVisible(find.text('bath_gas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('bath_gas'));
      await tester.pumpAndSettle();

      expect(find.byType(EnergyExploreSheet), findsOneWidget);
      Finder inSheet(Finder matching) => find.descendant(
        of: find.byType(EnergyExploreSheet),
        matching: matching,
      );
      // The multiple is an energy ratio, so a gas row carries it like
      // any other. 7.526854 / 0.0085 = 886x.
      expect(inSheet(find.text('886x an hour of LED light')), findsOneWidget);
      // Grams priced on the gas factor, not the grid: 7.526854 x 182.
      expect(inSheet(find.text('1.4kg')), findsOneWidget);
      // And this is where the phenomenon gets explained.
      expect(
        inSheet(find.textContaining('uses more energy than an electric one')),
        findsOneWidget,
      );
    });
  });
}
