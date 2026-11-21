import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
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

/// Discovery and evolution close while their write is still pending:
/// offline, a Firestore write only completes on server ack. Hatching
/// waits for the name, which a transaction rejects fast offline.
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

  group('egg hatching', () {
    var dismissed = false;

    Future<void> nameIt(WidgetTester tester) async {
      dismissed = false;
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
    }

    testWidgets('it stays open while the name is written', (tester) async {
      when(
        () => repo.updateMascotName(any(), any(), any()),
      ).thenAnswer((_) => Completer<void>().future);

      await nameIt(tester);

      expect(dismissed, isFalse);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await flush(tester);
    });

    testWidgets('a failed write keeps it open with an error', (tester) async {
      when(
        () => repo.updateMascotName(any(), any(), any()),
      ).thenThrow(Exception('denied'));

      await nameIt(tester);

      expect(dismissed, isFalse);
      final l10n = AppLocalizations.of(
        tester.element(find.byType(EggHatchingCelebration)),
      );
      expect(find.text(l10n.errorGeneric), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      await flush(tester);
    });

    testWidgets('it closes once the name is stored, before activation', (
      tester,
    ) async {
      when(
        () => repo.updateMascotName(any(), any(), any()),
      ).thenAnswer((_) async {});
      when(
        () => repo.setActiveMascot(any(), any()),
      ).thenAnswer((_) => Completer<void>().future);

      await nameIt(tester);

      expect(dismissed, isTrue);
      verify(() => repo.updateMascotName('u', 'm', 'Pip')).called(1);
      verify(() => repo.setActiveMascot('u', 'm')).called(1);
      await flush(tester);
    });
  });
}
