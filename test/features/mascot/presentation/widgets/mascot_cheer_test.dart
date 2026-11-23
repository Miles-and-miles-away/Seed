import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_cheer.dart';

import 'package:seed_app/shared/widgets/celebration_overlay.dart';

import '../../../../helpers/test_helpers.dart';

const _svg = 'assets/images/mascot/seed_stage1.svg';

void main() {
  group('MascotCheer.show', () {
    Future<BuildContext> pumpHost(
      WidgetTester tester, {
      String? asset = _svg,
    }) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            activeMascotAssetPathProvider.overrideWith((_) => asset),
            activeStageDataProvider.overrideWith((_) => null),
            mascotCelebrationPendingProvider.overrideWith((_) => false),
          ],
          child: const SizedBox.shrink(),
        ),
      );
      return tester.element(find.byType(SizedBox));
    }

    // Rise, stay and sink, then the frame that removes the entry.
    Future<void> runOut(WidgetTester tester) async {
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
    }

    testWidgets('a second show while one plays is ignored', (tester) async {
      final context = await pumpHost(tester);

      MascotCheer.show(context);
      MascotCheer.show(context);
      await tester.pump();

      expect(find.byType(MascotCheer), findsOneWidget);
      await runOut(tester);
    });

    testWidgets('the entry goes once it has sunk, freeing the next show', (
      tester,
    ) async {
      final context = await pumpHost(tester);

      MascotCheer.show(context);
      await tester.pump();
      await runOut(tester);
      expect(find.byType(MascotCheer), findsNothing);

      MascotCheer.show(context);
      await tester.pump();
      expect(find.byType(MascotCheer), findsOneWidget);
      await runOut(tester);
    });

    testWidgets('an early teardown still frees the next show', (tester) async {
      MascotCheer.show(await pumpHost(tester));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());

      MascotCheer.show(await pumpHost(tester));
      await tester.pump();
      expect(find.byType(MascotCheer), findsOneWidget);
      await runOut(tester);
    });

    testWidgets('stands aside for a celebration, before or after', (
      tester,
    ) async {
      final context = await pumpHost(tester);
      MascotCheer.show(context);
      await tester.pump();
      expect(find.byType(MascotCheer), findsOneWidget);

      late VoidCallback dismiss;
      final closed = showCelebrationOverlay(context, (onDismiss) {
        dismiss = onDismiss;
        return const Placeholder();
      });
      await tester.pump();
      await tester.pump();
      expect(find.byType(Placeholder), findsOneWidget);
      expect(find.byType(MascotCheer), findsNothing);

      MascotCheer.show(context);
      await tester.pump();
      expect(find.byType(MascotCheer), findsNothing);

      dismiss();
      await closed;
      await tester.pump();
      MascotCheer.show(context);
      await tester.pump();
      expect(find.byType(MascotCheer), findsOneWidget);
      await runOut(tester);
    });

    testWidgets('with a streak it says the streak once it has risen', (
      tester,
    ) async {
      final context = await pumpHost(tester);
      MascotCheer.show(context, streakDays: 1);
      await tester.pump();
      final bubble = find.ancestor(
        of: find.text('Streak started!'),
        matching: find.byType(AnimatedOpacity),
      );
      expect(tester.widget<AnimatedOpacity>(bubble).opacity, 0);

      await tester.pump(const Duration(seconds: 1));
      expect(tester.widget<AnimatedOpacity>(bubble).opacity, 1);
      await runOut(tester);
    });

    testWidgets('shows nothing without a mascot asset', (tester) async {
      MascotCheer.show(await pumpHost(tester, asset: null));
      await tester.pump();

      expect(find.byType(MascotCheer), findsNothing);
    });
  });
}
