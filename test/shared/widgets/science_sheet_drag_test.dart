import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/actions.dart';
import 'package:seed_app/features/energy/energy.dart';
import 'package:seed_app/features/transport/transport.dart';
import 'package:seed_app/shared/widgets/science_sheet.dart';

import '../../helpers/test_helpers.dart';

/// The longest ES action name in the action library.
const _longAction = ActionModel(
  id: 'donate_women_climate_org',
  nameEn: 'Donate to a Women-Led Climate Organization',
  nameJa: '',
  nameEs: 'Donar a organización climática liderada por mujeres',
  category: 'community',
  points: 5,
  descriptionLongEs: 'La ciencia.',
);

/// Both science sheets scroll their title and body on the sheet's own
/// controller: a drag grows the sheet, and a long title cannot pin the
/// body out of view.
void main() {
  late List<TransportMode> modes;
  late List<EnergyBehavior> behaviors;
  late void Function(BuildContext context) open;

  setUpAll(() async {
    await loadTestFonts();
    modes = await loadTransportModes();
    behaviors = await loadEnergyBehaviors();
  });

  Future<void> pumpOpen(
    WidgetTester tester,
    void Function(BuildContext context) show, {
    Locale locale = const Locale('en'),
  }) async {
    open = show;
    await tester.pumpWidget(
      createTestWidget(
        locale: locale,
        scaffold: true,
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => open(context),
            child: const Text('info'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('info'));
    await tester.pumpAndSettle();
  }

  Future<void> expectDragGrows(WidgetTester tester, Finder title) async {
    final before = tester.getSize(find.byType(BottomSheet)).height;
    await tester.drag(title, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(BottomSheet)).height,
      greaterThan(before + 100),
    );
  }

  testWidgets('dragging the science sheet grows it', (tester) async {
    sizeViewport(tester, size: const Size(320, 640));
    await pumpOpen(
      tester,
      (context) => ScienceSheet.show(
        context,
        title: 'Kettle',
        markdown: List.filled(40, 'A line of notes.').join('\n\n'),
      ),
    );
    await expectDragGrows(tester, find.text('Kettle'));
  });

  testWidgets('dragging the action science sheet grows it', (tester) async {
    sizeViewport(tester, size: const Size(320, 640));
    await pumpOpen(
      tester,
      (context) => ActionScienceBottomSheet.show(
        context,
        action: _longAction.copyWith(
          descriptionLongEn: List.filled(40, 'A line.').join('\n\n'),
        ),
        languageCode: 'en',
      ),
    );
    await expectDragGrows(tester, find.text(_longAction.nameEn));
  });

  group('at text scale 2.0', () {
    // Already at full height on open: a drag up has nothing left to grow.
    Future<void> expectOpensFull(
      WidgetTester tester,
      void Function(BuildContext context) show,
      Finder title,
    ) async {
      sizeViewport(tester, size: const Size(320, 640));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpOpen(tester, show);
      final opened = tester.getSize(find.byType(BottomSheet)).height;
      await tester.drag(title, const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(BottomSheet)).height, opened);
    }

    testWidgets('the science sheet opens at full height', (tester) async {
      await expectOpensFull(
        tester,
        (context) => ScienceSheet.show(
          context,
          title: 'Kettle',
          markdown: List.filled(40, 'A line of notes.').join('\n\n'),
        ),
        find.text('Kettle'),
      );
    });

    testWidgets('the action science sheet opens at full height', (
      tester,
    ) async {
      await expectOpensFull(
        tester,
        (context) => ActionScienceBottomSheet.show(
          context,
          action: _longAction.copyWith(
            descriptionLongEn: List.filled(40, 'A line.').join('\n\n'),
          ),
          languageCode: 'en',
        ),
        find.text(_longAction.nameEn),
      );
    });
  });

  group('long ES titles at 320x640 and text scale 2.0', () {
    Future<void> expectNoOverflow(
      WidgetTester tester,
      void Function(BuildContext context) show,
    ) async {
      sizeViewport(tester, size: const Size(320 * robotoToSfWidthFactor, 640));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpOpen(tester, show, locale: const Locale('es'));
      expect(tester.takeException(), isNull);
    }

    for (final id in ['flight_shorthaul', 'flight_longhaul']) {
      testWidgets(id, (tester) async {
        final mode = modes.firstWhere((m) => m.id == id);
        await expectNoOverflow(
          tester,
          (context) => showTransportScienceSheet(
            context,
            mode: mode,
            languageCode: 'es',
          ),
        );
      });
    }

    testWidgets('shower_heatpump', (tester) async {
      final behavior = behaviors.firstWhere((b) => b.id == 'shower_heatpump');
      await expectNoOverflow(
        tester,
        (context) => showEnergyScienceSheet(
          context,
          behavior: behavior,
          languageCode: 'es',
        ),
      );
    });

    testWidgets('the longest action name', (tester) async {
      await expectNoOverflow(
        tester,
        (context) => ActionScienceBottomSheet.show(
          context,
          action: _longAction,
          languageCode: 'es',
        ),
      );
    });
  });
}
