import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/energy/energy.dart';
import 'package:seed_app/features/transport/transport.dart';
import 'package:seed_app/shared/widgets/science_sheet.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/test_helpers.dart';

typedef _Sheet = ({
  String id,
  String notes,
  void Function(BuildContext context) show,
});

/// Every transport and energy science sheet with its translated notes, at
/// the stress width and text scales.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<TransportMode> modes;
  late List<EnergyBehavior> behaviors;
  late void Function(BuildContext context) open;

  setUpAll(() async {
    modes = await loadTransportModes();
    behaviors = await loadEnergyBehaviors();
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  List<_Sheet> sheets(String languageCode) {
    String pick(String ja, String es) => languageCode == 'ja' ? ja : es;
    return [
      for (final mode in modes)
        (
          id: mode.id,
          notes: pick(mode.calculationNotesJa, mode.calculationNotesEs),
          show: (context) => showTransportScienceSheet(
            context,
            mode: mode,
            languageCode: languageCode,
          ),
        ),
      for (final behavior in behaviors)
        (
          id: behavior.id,
          notes: pick(behavior.calculationNotesJa, behavior.calculationNotesEs),
          show: (context) => showEnergyScienceSheet(
            context,
            behavior: behavior,
            languageCode: languageCode,
          ),
        ),
    ];
  }

  stressWidthLayoutTests(
    // At 640 the half-height sheet cannot fit the longest ES titles at 2x.
    height: 800,
    (locale, theme) => createTestWidget(
      locale: locale,
      theme: theme,
      scaffold: true,
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () => open(context),
          child: const Text('info'),
        ),
      ),
    ),
    act: (tester, locale) async {
      for (final sheet in sheets(locale.languageCode)) {
        open = sheet.show;
        await tester.tap(find.text('info'));
        await tester.pumpAndSettle();
        printOnFailure('sheet ${sheet.id}');
        // The note whole, so no markdown syntax swallowed a character.
        final note = find.textContaining(sheet.notes);
        await tester.scrollUntilVisible(
          note,
          200,
          scrollable: find
              .descendant(
                of: find.byType(ScienceSheet),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(tester.takeException(), isNull, reason: sheet.id);
        expect(note, findsOneWidget, reason: sheet.id);
        Navigator.of(tester.element(find.byType(ScienceSheet))).pop();
        await tester.pumpAndSettle();
      }
    },
  );
}
