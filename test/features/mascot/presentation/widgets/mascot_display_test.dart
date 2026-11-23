import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

import '../../../../helpers/test_helpers.dart';

const _svg = 'assets/images/mascot/seed_stage1.svg';
const _riv = 'assets/animations/coral_mascot.riv';
const _riveLoadTimeout = Duration(seconds: 30);
const _rivePollInterval = Duration(milliseconds: 25);

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

/// Call inside `runAsync`: Rive decodes on the real event loop.
Future<void> _pumpUntilRiveLoaded(WidgetTester tester) async {
  final riveWidget = find.byType(rive.RiveWidget);
  final deadline = DateTime.now().add(_riveLoadTimeout);
  while (!tester.any(riveWidget) && DateTime.now().isBefore(deadline)) {
    await Future<void>.delayed(_rivePollInterval);
    await tester.pump();
  }
  expect(riveWidget, findsOneWidget);
  await tester.pump();
}

double _smileHold(WidgetTester tester) {
  final vm = tester
      .widget<rive.RiveWidget>(find.byType(rive.RiveWidget))
      .controller
      .stateMachine
      .boundRuntimeViewModelInstance!;
  return vm.number('face/$mascotVmSmileHold')!.value;
}

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

    testWidgets('reduced motion freezes the mascot with no jump or smile', (
      tester,
    ) async {
      var jumped = false;
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: _wrap(
              MascotDisplay(
                size: 100,
                jumpOnLoad: true,
                onJump: () => jumped = true,
              ),
              assetPath: _riv,
            ),
          ),
        );
        await _pumpUntilRiveLoaded(tester);
        final controller = tester
            .widget<rive.RiveWidget>(find.byType(rive.RiveWidget))
            .controller;
        expect(controller.active, isFalse);
        expect(controller.stateMachine.boundRuntimeViewModelInstance, isNull);
        expect(jumped, isFalse);
      });
      await tearDownTree(tester);
    });

    group('welcome back', () {
      final now = DateTime(2026, 3, 10, 9);
      final overrides = [
        userOverride(
          AppUserModel(uid: 'u', email: 'e', lastActionDate: DateTime(2026, 3)),
        ),
        clockProvider.overrideWithValue(() => now),
      ];

      Widget display({bool tickerOn = true}) => TickerMode(
        enabled: tickerOn,
        child: _wrap(
          const MascotDisplay(size: 100, welcomesBack: true),
          assetPath: _riv,
          overrides: overrides,
        ),
      );

      bool smiled(WidgetTester tester) =>
          ProviderScope.containerOf(
            tester.element(find.byType(MascotDisplay)),
          ).read(welcomeBackSmiledProvider) !=
          null;

      testWidgets('smiles once loaded when due, and records it', (
        tester,
      ) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(display());
          await _pumpUntilRiveLoaded(tester);
          expect(_smileHold(tester), 1);
          expect(smiled(tester), isTrue);
        });
        await tearDownTree(tester);
      });

      testWidgets('a short smile trigger does not end the longer hold', (
        tester,
      ) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(display());
          await _pumpUntilRiveLoaded(tester);
          expect(_smileHold(tester), 1);

          ProviderScope.containerOf(
            tester.element(find.byType(MascotDisplay)),
          ).read(mascotSmileTriggerProvider.notifier).triggerSmile();
          await tester.pump();
          await Future<void>.delayed(durationInstant * 2);
          await tester.pump();

          expect(_smileHold(tester), 1);

          await Future<void>.delayed(durationCelebration);
          await tester.pump();
          expect(_smileHold(tester), 0);
        });
        await tearDownTree(tester);
      });

      testWidgets('waits until its ticker is on', (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(display(tickerOn: false));
          await _pumpUntilRiveLoaded(tester);
          expect(_smileHold(tester), 0);
          expect(smiled(tester), isFalse);

          await tester.pumpWidget(display());
          await tester.pump();
          expect(_smileHold(tester), 1);
          expect(smiled(tester), isTrue);
        });
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
