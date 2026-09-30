import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

import '../../../../helpers/test_helpers.dart';

const _svg = 'assets/images/mascot/seed_stage1.svg';

Widget _wrap(Widget child, {String? assetPath}) => createTestWidget(
  overrides: [activeMascotAssetPathProvider.overrideWith((_) => assetPath)],
  scaffold: true,
  child: Center(child: child),
);

void main() {
  group('MascotDisplay', () {
    testWidgets('shows a loading spinner while asset path is null', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const MascotDisplay(size: 100)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Drops the looping glow and float, then flushes their timers.
    Future<void> tearDownTree(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox.shrink());
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('a bounce keeps the same mascot element mounted', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const MascotDisplay(size: 100), assetPath: _svg),
      );
      await tester.pump();
      final before = tester.element(find.byType(MascotImage));

      ProviderScope.containerOf(
        tester.element(find.byType(MascotDisplay)),
      ).read(mascotAnimationTriggerProvider.notifier).triggerBounce();
      await tester.pump();
      await tester.pump();

      expect(tester.element(find.byType(MascotImage)), same(before));
      await tester.pump(const Duration(milliseconds: 500));
      await tearDownTree(tester);
    });

    testWidgets('reduced motion drops the glow and float loops', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const MascotDisplay(size: 100), assetPath: _svg),
      );
      await tester.pump();
      expect(find.byType(Animate), findsNWidgets(2));

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: _wrap(const MascotDisplay(size: 100), assetPath: _svg),
        ),
      );
      await tester.pump();
      expect(find.byType(Animate), findsNothing);
      expect(find.byType(MascotImage), findsOneWidget);
      await tearDownTree(tester);
    });
  });
}
