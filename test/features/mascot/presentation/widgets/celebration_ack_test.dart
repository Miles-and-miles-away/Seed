import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/repositories/mascot_repository.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/egg_discovery_celebration.dart';
import 'package:seed_app/features/mascot/presentation/widgets/egg_hatching_celebration.dart';
import 'package:seed_app/features/mascot/presentation/widgets/evolution_celebration.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';

import '../../../../helpers/test_helpers.dart';

class _MockMascotRepository extends Mock implements MascotRepository {}

const _mascot = MascotModel(id: 'm', speciesId: 'seed', name: 'Bud');
const _user = AppUserModel(
  uid: 'u',
  email: 'e',
  mascots: [_mascot],
  activeMascotId: 'm',
  eggPendingDiscovery: true,
);

/// Every celebration here is closed while its write is still pending:
/// offline, a Firestore write only completes on server ack.
void main() {
  late _MockMascotRepository repo;

  setUpAll(() {
    registerFallbackValue(EggModel(receivedAt: DateTime(2026)));
  });

  setUp(() {
    repo = _MockMascotRepository();
  });

  List<Override> overrides() => [
    userOverride(_user),
    mascotRepositoryProvider.overrideWithValue(repo),
    mascotSpeciesDataProvider.overrideWith((_) async => const []),
    activeMascotAssetPathProvider.overrideWith((_) => null),
    activeStageDataProvider.overrideWith((_) => null),
  ];

  Future<void> pumpHost(
    WidgetTester tester,
    void Function(BuildContext context, WidgetRef ref) show,
  ) async {
    sizeViewport(tester);
    await tester.pumpWidget(
      createTestWidget(
        overrides: overrides(),
        child: Consumer(
          builder: (context, ref, _) => ElevatedButton(
            onPressed: () => show(context, ref),
            child: const Text('show'),
          ),
        ),
      ),
    );
    ProviderScope.containerOf(
      tester.element(find.byType(ElevatedButton)),
    ).listen(currentUserProvider, (_, _) {});
    await tester.pump();
    await tester.tap(find.text('show'));
    await tester.pump();
  }

  Future<void> revealButton(WidgetTester tester) async {
    await tester.pump(durationNormal);
    await tester.pump(durationShowcase);
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
  }

  Future<void> systemBack(WidgetTester tester) =>
      tester.state<NavigatorState>(find.byType(Navigator)).maybePop();

  // Drops the looping glow and confetti, then flushes their timers.
  Future<void> flush(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('egg discovery', () {
    setUp(() {
      when(
        () => repo.createEgg(any(), any()),
      ).thenAnswer((_) => Completer<void>().future);
    });

    testWidgets('the button closes it before the egg is written', (
      tester,
    ) async {
      await pumpHost(tester, showEggDiscoveryCelebration);
      expect(find.byType(EggDiscoveryCelebration), findsOneWidget);

      await revealButton(tester);
      await tester.tap(find.byType(CelebrationButton));
      await settle(tester);

      expect(find.byType(EggDiscoveryCelebration), findsNothing);
      verify(() => repo.createEgg('u', any())).called(1);
      await flush(tester);
    });

    testWidgets('system back still writes the egg', (tester) async {
      await pumpHost(tester, showEggDiscoveryCelebration);
      await revealButton(tester);

      await systemBack(tester);
      await settle(tester);

      expect(find.byType(EggDiscoveryCelebration), findsNothing);
      verify(() => repo.createEgg('u', any())).called(1);
      await flush(tester);
    });
  });

  group('evolution', () {
    setUp(() {
      when(
        () => repo.updateLastSeenStage(any(), any(), any()),
      ).thenAnswer((_) => Completer<void>().future);
    });

    testWidgets('the button closes it before the stage is written', (
      tester,
    ) async {
      await pumpHost(tester, showEvolutionCelebration);
      expect(find.byType(EvolutionCelebration), findsOneWidget);

      await revealButton(tester);
      await tester.tap(find.byType(CelebrationButton));
      await settle(tester);

      expect(find.byType(EvolutionCelebration), findsNothing);
      verify(() => repo.updateLastSeenStage('u', 'm', any())).called(1);
      await flush(tester);
    });

    testWidgets('system back still writes the stage', (tester) async {
      await pumpHost(tester, showEvolutionCelebration);
      await revealButton(tester);

      await systemBack(tester);
      await settle(tester);

      expect(find.byType(EvolutionCelebration), findsNothing);
      verify(() => repo.updateLastSeenStage('u', 'm', any())).called(1);
      await flush(tester);
    });
  });

  testWidgets('naming a hatched mascot dismisses before the write lands', (
    tester,
  ) async {
    when(
      () => repo.updateMascotName(any(), any(), any()),
    ).thenAnswer((_) => Completer<void>().future);
    var dismissed = false;
    sizeViewport(tester);
    await tester.pumpWidget(
      createTestWidget(
        overrides: overrides(),
        child: EggHatchingCelebration(
          hatchedMascot: _mascot,
          onDismiss: () => dismissed = true,
        ),
      ),
    );
    ProviderScope.containerOf(
      tester.element(find.byType(EggHatchingCelebration)),
    ).listen(currentUserProvider, (_, _) {});
    await tester.pump(durationReveal);
    await tester.pump(durationCelebration);

    await tester.pump(const Duration(milliseconds: 500));

    await tester.enterText(find.byType(TextField), 'Pip');
    tester.widget<FilledButton>(find.byType(FilledButton)).onPressed!();
    await settle(tester);

    expect(dismissed, isTrue);
    verify(() => repo.updateMascotName('u', 'm', 'Pip')).called(1);
    await flush(tester);
  });
}
