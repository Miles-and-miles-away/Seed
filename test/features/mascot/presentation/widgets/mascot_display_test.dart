import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_speech_bubble.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

import '../../../../helpers/test_helpers.dart';

const _svg = 'assets/images/mascot/seed_stage1.svg';

Widget _wrap(
  Widget child, {
  String? assetPath,
  List<Override> overrides = const [],
}) => createTestWidget(
  overrides: [
    activeMascotAssetPathProvider.overrideWith((_) => assetPath),
    ...overrides,
  ],
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

    MascotPose drawnPose(WidgetTester tester) {
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(DrawnMascot),
          matching: find.byType(CustomPaint),
        ),
      );
      return (paint.painter! as DrawnMascotPainter).pose;
    }

    testWidgets('a code-drawn hero animates without the float and waves on '
        'its own tap', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MascotDisplay(size: 100, showGlow: false, wavesOnTap: true),
          assetPath: drawnMascotPath('seed', 2),
        ),
      );
      expect(
        tester.widget<DrawnMascot>(find.byType(DrawnMascot)).animate,
        isTrue,
      );
      expect(find.byType(Animate), findsNothing);

      await tester.tap(find.byType(DrawnMascot));
      for (var i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(drawnPose(tester).armR, greaterThan(1));
      await tearDownTree(tester);
    });

    testWidgets('a code-drawn hero that does not wave leaves the tap to '
        'an ancestor', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          GestureDetector(
            onTap: () => taps++,
            child: const MascotDisplay(size: 100, showGlow: false),
          ),
          assetPath: drawnMascotPath('seed', 2),
        ),
      );
      await tester.tap(find.byType(DrawnMascot));
      for (var i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(taps, 1);
      expect(drawnPose(tester).armR, lessThan(0.2));
      await tearDownTree(tester);
    });

    testWidgets('a code-drawn hero hops on load and reports the jump', (
      tester,
    ) async {
      var jumps = 0;
      await tester.pumpWidget(
        _wrap(
          MascotDisplay(
            size: 100,
            showGlow: false,
            jumpOnLoad: true,
            onJump: () => jumps++,
          ),
          assetPath: drawnMascotPath('seed', 2),
        ),
      );
      await tester.pump();
      expect(jumps, 1);
      for (var i = 0; i < 14; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(drawnPose(tester).squash, lessThan(-0.1));
      expect(jumps, 1);
      await tearDownTree(tester);
    });

    testWidgets('a code-drawn hero under reduced motion smiles in place of '
        'the hop', (tester) async {
      var jumped = false;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: _wrap(
            MascotDisplay(
              size: 100,
              showGlow: false,
              jumpOnLoad: true,
              onJump: () => jumped = true,
            ),
            assetPath: drawnMascotPath('seed', 2),
          ),
        ),
      );
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(jumped, isFalse);
      expect(drawnPose(tester).squash, 0);
      expect(drawnPose(tester).smile, greaterThan(0.8));
      // Local, so that the other visible mascots do not smile too.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(MascotDisplay)),
      );
      expect(container.read(mascotSmileTriggerProvider), isFalse);
      await tester.pump(durationCelebration);
      await tearDownTree(tester);
    });

    group('daily greeting', () {
      final now = DateTime(2026, 3, 10, 9);
      final overrides = [
        userOverride(
          AppUserModel(
            uid: 'u',
            email: 'e',
            currentStreak: 6,
            lastActionDate: DateTime(2026, 3, 9),
          ),
        ),
        clockProvider.overrideWithValue(() => now),
      ];

      Widget display({bool tickerOn = true, bool reduce = false}) => MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: TickerMode(
          enabled: tickerOn,
          child: _wrap(
            const Column(
              children: [
                MascotDisplay(size: 100, showGlow: false, greets: true),
                MascotGreetingBubble(child: Text('name')),
              ],
            ),
            assetPath: drawnMascotPath('seed', 2),
            overrides: overrides,
          ),
        ),
      );

      bool greeted(WidgetTester tester) =>
          ProviderScope.containerOf(
            tester.element(find.byType(MascotDisplay)),
          ).read(dailyGreetedProvider) !=
          null;

      Future<void> frames(WidgetTester tester, int count) async {
        for (var i = 0; i < count; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
      }

      testWidgets('the hero waves, says the streak, and records it', (
        tester,
      ) async {
        await tester.pumpWidget(display());
        await frames(tester, 30);
        expect(greeted(tester), isTrue);
        expect(drawnPose(tester).armR, greaterThan(1));
        expect(find.text('Welcome back!'), findsOneWidget);
        expect(
          find.text('6-day streak! Log an action to keep it.'),
          findsOneWidget,
        );

        await tester.pump(const Duration(seconds: 5));
        await tester.pump(durationMedium);
        await tester.pump(durationMedium);
        expect(find.text('Welcome back!'), findsNothing);
        await tearDownTree(tester);
      });

      testWidgets('under reduce motion it smiles in place of the wave', (
        tester,
      ) async {
        await tester.pumpWidget(display(reduce: true));
        await frames(tester, 30);
        expect(greeted(tester), isTrue);
        expect(drawnPose(tester).armR, lessThan(0.5));
        expect(drawnPose(tester).smile, greaterThan(0.8));
        expect(find.text('Welcome back!'), findsOneWidget);
        await tester.pump(const Duration(seconds: 5));
        await tearDownTree(tester);
      });

      testWidgets('waits until its ticker is on', (tester) async {
        await tester.pumpWidget(display(tickerOn: false));
        await tester.pump();
        expect(greeted(tester), isFalse);

        await tester.pumpWidget(display());
        await tester.pump();
        expect(greeted(tester), isTrue);
        await tester.pump(const Duration(seconds: 5));
        await tearDownTree(tester);
      });
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
