import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/widgets/calculator_chooser_sheet.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../walkthrough/walkthrough_test_support.dart';

void main() {
  Widget buildSheet() =>
      createTestWidget(scaffold: true, child: const CalculatorChooserSheet());

  group('walkthrough spotlight', () {
    List<double> tileOpacities(WidgetTester tester) => tester
        .widgetList<AnimatedOpacity>(
          find.descendant(
            of: find.byType(CalculatorChooserSheet),
            matching: find.byType(AnimatedOpacity),
          ),
        )
        .map((w) => w.opacity)
        .toList();

    testWidgets('leaves the sheet uncovered and dims the other tiles', (
      tester,
    ) async {
      sizeViewport(tester);
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          locale: const Locale('en'),
          overrides: walkthroughOverrides(
            settings: Stream.value(settingsWith([WalkthroughItem.intro])),
          ),
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CalculatorChooserSheet.show(context),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('open'));
      // Frame by frame, as on a device: the explanation must wait for the
      // sheet to finish sliding in or its spotlight lands mid-transition.
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final overlay = tester.widget<CelebrationOverlay>(
        find.byType(CelebrationOverlay),
      );
      expect(overlay.backdropBottom, isNotNull);
      expect(overlay.backdropBottom, greaterThan(0));
      expect(
        overlay.backdropBottom,
        lessThanOrEqualTo(
          tester.getTopLeft(find.byType(CalculatorChooserSheet)).dy,
        ),
      );
      expect(tileOpacities(tester), [1, opacityMuted, opacityMuted]);

      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(tileOpacities(tester), [opacityMuted, 1, opacityMuted]);

      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(tileOpacities(tester), [opacityMuted, opacityMuted, 1]);

      // The fourth page points outside the sheet, so nothing is lit.
      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(tileOpacities(tester), [opacityMuted, opacityMuted, opacityMuted]);

      await tester.tap(find.text('Got it'));
      await tester.pump();
      await tester.pump();
      expect(find.byType(WalkthroughOverlay), findsNothing);
      expect(tileOpacities(tester), [1, 1, 1]);
      await flushOverlayTimers(tester);
    });
  });

  group('CalculatorChooserSheet', () {
    testWidgets('offers all three calculators', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Home energy'), findsOneWidget);
    });

    testWidgets('each tile wears its own category colour', (tester) async {
      // All three used to be the same primaryContainer blue, which said
      // nothing about which domain each one leads to.
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      Color avatarColour(String label) => tester
          .widget<CircleAvatar>(
            find
                .ancestor(
                  of: find.byType(Icon),
                  matching: find.byType(CircleAvatar),
                )
                .at(const ['Transport', 'Food', 'Home energy'].indexOf(label)),
          )
          .backgroundColor!;

      for (final (label, category) in const [
        ('Transport', ActionCategory.transport),
        ('Food', ActionCategory.food),
        ('Home energy', ActionCategory.energy),
      ]) {
        expect(
          avatarColour(label),
          category.color.withValues(alpha: opacityLight),
          reason: '$label tile should carry its category colour',
        );
      }
      // ...and three distinct colours, not one repeated.
      expect({
        for (final l in const ['Transport', 'Food', 'Home energy'])
          avatarColour(l),
      }, hasLength(3));
    });
  });
}
