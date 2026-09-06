import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';

import '../../../../helpers/test_helpers.dart';

Future<ProviderContainer> _container({
  AppUserModel? user,
  List<MascotModel>? mascots,
  MascotModel? active,
  List<MascotSpeciesModel>? species,
}) async {
  final c = await pumpedContainer([
    userOverride(user),
    if (mascots != null)
      allMascotsProvider.overrideWith((_) => Stream.value(mascots)),
    if (active != null)
      activeMascotProvider.overrideWith((_) => Stream.value(active)),
    if (species != null)
      mascotSpeciesDataProvider.overrideWith((_) async => species),
  ]);
  // The overridden streams must emit before derived providers read them.
  c
    ..listen(allMascotsProvider, (_, _) {})
    ..listen(activeMascotProvider, (_, _) {})
    ..listen(mascotSpeciesDataProvider, (_, _) {});
  await Future<void>.delayed(Duration.zero);
  return c;
}

void main() {
  group('egg providers', () {
    test('currentEgg and hasEgg are null/false when user has no egg', () async {
      final c = await _container(
        user: const AppUserModel(uid: 'u', email: 'e'),
      );

      expect(c.read(currentEggProvider), isNull);
      expect(c.read(hasEggProvider), isFalse);
    });

    test('currentEgg returns the user egg model', () async {
      final egg = EggModel(
        receivedAt: DateTime.utc(2026),
        hatchingStreakDays: 5,
      );
      final c = await _container(
        user: AppUserModel(uid: 'u', email: 'e', egg: egg),
      );

      expect(c.read(currentEggProvider), egg);
      expect(c.read(hasEggProvider), isTrue);
    });

    test(
      'eggHatchingProgress is 0 when no egg, normalizes otherwise',
      () async {
        // No egg
        final noEgg = await _container(
          user: const AppUserModel(uid: 'u', email: 'e'),
        );
        expect(noEgg.read(eggHatchingProgressProvider), 0);

        // Half-way
        final halfEgg = await _container(
          user: AppUserModel(
            uid: 'u',
            email: 'e',
            egg: EggModel(
              receivedAt: DateTime.utc(2026),
              hatchingStreakDays: AppConstants.eggHatchingStreakRequired ~/ 2,
            ),
          ),
        );
        expect(halfEgg.read(eggHatchingProgressProvider), closeTo(0.5, 0.02));

        // Over-full (should clamp to 1.0)
        final past = await _container(
          user: AppUserModel(
            uid: 'u',
            email: 'e',
            egg: EggModel(
              receivedAt: DateTime.utc(2026),
              hatchingStreakDays: AppConstants.eggHatchingStreakRequired + 5,
            ),
          ),
        );
        expect(past.read(eggHatchingProgressProvider), 1.0);
      },
    );

    test('shouldShowEggDiscovery reads the flag from user', () async {
      final c = await _container(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          eggPendingDiscovery: true,
        ),
      );

      expect(c.read(shouldShowEggDiscoveryProvider), isTrue);
    });
  });

  group('hasMascotProvider', () {
    test('false when mascot list is empty', () async {
      final c = await _container(mascots: const []);

      expect(c.read(hasMascotProvider), isFalse);
    });

    test('true when list has mascots', () async {
      final c = await _container(
        mascots: const [MascotModel(id: 'm1', speciesId: 'seed')],
      );

      expect(c.read(hasMascotProvider), isTrue);
    });
  });

  group('active* derived providers', () {
    const stages = [
      EvolutionStageModel(
        level: 1,
        assetPath: 'a/1.png',
        nameEn: 'Seed',
        nameJa: 'シード',
        nameEs: 'Semilla',
      ),
      EvolutionStageModel(
        level: 10,
        assetPath: 'a/2.png',
        nameEn: 'Sprout',
        nameJa: '芽',
      ),
      EvolutionStageModel(
        level: 25,
        assetPath: 'a/3.png',
        nameEn: 'Tree',
        nameJa: '木',
      ),
    ];
    const species = [
      MascotSpeciesModel(
        id: 'seed',
        nameEn: 'Seed',
        nameJa: 'シード',
        descriptionEn: '',
        descriptionJa: '',
        evolutionStages: stages,
      ),
    ];

    test('activeMascotStage picks the right 1-based index by level', () async {
      // Level 12 -> stage 2.
      final c = await _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 12),
        species: species,
      );

      expect(c.read(activeMascotStageProvider), 2);
    });

    test('activeMascotAssetPath returns the current stage asset', () async {
      final c = await _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 30),
        species: species,
      );

      expect(c.read(activeMascotAssetPathProvider), 'a/3.png');
    });

    test('activeNextStageData returns the upcoming stage or null', () async {
      final midway = await _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 8),
        species: species,
      );
      expect(midway.read(activeNextStageDataProvider)!.level, 10);

      final atMax = await _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 50),
        species: species,
      );
      expect(atMax.read(activeNextStageDataProvider), isNull);
    });

    test('hasNewEvolution compares lastSeenStage to current stage', () async {
      final stale = await _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 12),
        species: species,
      );
      expect(stale.read(hasNewEvolutionProvider), isTrue);

      final current = await _container(
        active: const MascotModel(
          id: 'm1',
          speciesId: 'seed',
          mascotLevel: 12,
          lastSeenStage: 2,
        ),
        species: species,
      );
      expect(current.read(hasNewEvolutionProvider), isFalse);
    });

    test(
      'stageLocalizedName falls back to English for unknown locale',
      () async {
        final c = await _container(
          active: const MascotModel(id: 'm1', speciesId: 'seed'),
          species: species,
        );

        expect(c.read(stageLocalizedNameProvider('fr')), 'Seed');
        expect(c.read(stageLocalizedNameProvider('ja')), 'シード');
        expect(c.read(stageLocalizedNameProvider('es')), 'Semilla');
      },
    );
  });

  group('MascotNotifier', () {
    const stages = [
      EvolutionStageModel(level: 1, assetPath: 'a/1', nameEn: '1', nameJa: ''),
      EvolutionStageModel(level: 10, assetPath: 'a/2', nameEn: '2', nameJa: ''),
      EvolutionStageModel(level: 25, assetPath: 'a/3', nameEn: '3', nameJa: ''),
    ];
    const species = [
      MascotSpeciesModel(
        id: 'seed',
        nameEn: 'Seed',
        nameJa: '',
        descriptionEn: '',
        descriptionJa: '',
        evolutionStages: stages,
      ),
    ];
    const m1 = MascotModel(
      id: 'm1',
      speciesId: 'seed',
      name: 'One',
      mascotLevel: 12,
    );
    const m2 = MascotModel(id: 'm2', speciesId: 'seed', name: 'Two');
    const user = AppUserModel(
      uid: 'u',
      email: 'e',
      mascots: [m1, m2],
      activeMascotId: 'm2',
      eggPendingDiscovery: true,
    );

    late FakeFirebaseFirestore firestore;

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      await firestore.collection(AppConstants.collectionUsers).doc('u').set({
        'uid': 'u',
        AppConstants.fieldMascots: [m1.toJson(), m2.toJson()],
        AppConstants.fieldActiveMascotId: 'm2',
        AppConstants.fieldEggPendingDiscovery: true,
      });
    });

    Future<ProviderContainer> notifierContainer({
      AppUserModel? signedIn = user,
    }) async {
      final c = await pumpedContainer([
        userOverride(signedIn),
        firestoreProvider.overrideWithValue(firestore),
        mascotSpeciesDataProvider.overrideWith((_) async => species),
      ]);
      c
        ..listen(allMascotsProvider, (_, _) {})
        ..listen(activeMascotProvider, (_, _) {})
        ..listen(mascotSpeciesDataProvider, (_, _) {});
      await Future<void>.delayed(Duration.zero);
      return c;
    }

    Future<Map<String, dynamic>> userDoc() async =>
        (await firestore
                .collection(AppConstants.collectionUsers)
                .doc('u')
                .get())
            .data()!;

    Future<Map<String, dynamic>> storedMascot(String id) async =>
        ((await userDoc())[AppConstants.fieldMascots] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .singleWhere((m) => m[AppConstants.fieldId] == id);

    test('activeMascot resolves activeMascotId among several', () async {
      final c = await notifierContainer();

      expect(c.read(activeMascotProvider).value?.id, 'm2');
      expect(c.read(allMascotsProvider).value, hasLength(2));
    });

    test('renameMascot renames only the active mascot', () async {
      final c = await notifierContainer();

      await c.read(mascotProvider.notifier).renameMascot('Bud');

      expect((await storedMascot('m2'))[AppConstants.fieldName], 'Bud');
      expect((await storedMascot('m1'))[AppConstants.fieldName], 'One');
      expect(c.read(mascotProvider).hasValue, isTrue);
    });

    test('switchActiveMascot writes the new active id', () async {
      final c = await notifierContainer();

      await c.read(mascotProvider.notifier).switchActiveMascot('m1');

      expect((await userDoc())[AppConstants.fieldActiveMascotId], 'm1');
    });

    test('nameHatchedMascot names the mascot and makes it active', () async {
      final c = await notifierContainer();

      await c.read(mascotProvider.notifier).nameHatchedMascot('m1', 'Sprout');

      expect((await storedMascot('m1'))[AppConstants.fieldName], 'Sprout');
      expect((await userDoc())[AppConstants.fieldActiveMascotId], 'm1');
    });

    test('markEvolutionSeen stores the current stage', () async {
      final c = await notifierContainer(
        signedIn: user.copyWith(activeMascotId: 'm1'),
      );
      expect(c.read(activeMascotStageProvider), 2);

      await c.read(mascotProvider.notifier).markEvolutionSeen();

      expect((await storedMascot('m1'))[AppConstants.fieldLastSeenStage], 2);
      expect((await storedMascot('m2'))[AppConstants.fieldLastSeenStage], 1);
    });

    test(
      'acknowledgeEggDiscovery creates the egg and clears the flag',
      () async {
        final c = await notifierContainer();

        await c.read(mascotProvider.notifier).acknowledgeEggDiscovery();

        final doc = await userDoc();
        expect(doc[AppConstants.fieldEgg], isA<Map<String, dynamic>>());
        expect(doc[AppConstants.fieldEggPendingDiscovery], isFalse);
      },
    );

    test('signed out: state errors and nothing is written', () async {
      final c = await notifierContainer(signedIn: null);

      await c.read(mascotProvider.notifier).switchActiveMascot('m1');

      expect(c.read(mascotProvider).hasError, isTrue);
      expect((await userDoc())[AppConstants.fieldActiveMascotId], 'm2');
    });
  });

  group('animation triggers', () {
    test('triggerBounce pulses true and resets after the instant', () async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final seen = <bool>[];
      c.listen(
        mascotAnimationTriggerProvider,
        (_, next) => seen.add(next),
        fireImmediately: true,
      );

      c.read(mascotAnimationTriggerProvider.notifier).triggerBounce();
      expect(seen, [false, true]);

      await Future<void>.delayed(durationInstant * 2);
      expect(seen, [false, true, false]);
    });

    test('triggerSmile pulses true and resets after the instant', () async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final seen = <bool>[];
      c.listen(
        mascotSmileTriggerProvider,
        (_, next) => seen.add(next),
        fireImmediately: true,
      );

      c.read(mascotSmileTriggerProvider.notifier).triggerSmile();
      expect(seen, [false, true]);

      await Future<void>.delayed(durationInstant * 2);
      expect(seen, [false, true, false]);
    });
  });

  group('fallbacks while loading or signed out', () {
    test('hasMascot is false while the mascot list is loading', () async {
      final c = await pumpedContainer([
        allMascotsProvider.overrideWith(
          (_) => StreamController<List<MascotModel>>().stream,
        ),
      ], warm: allMascotsProvider);

      expect(c.read(hasMascotProvider), isFalse);
    });

    test('shouldShowEggDiscovery is false when signed out', () async {
      final c = await _container();

      expect(c.read(shouldShowEggDiscoveryProvider), isFalse);
    });

    test('hasNewEvolution is false without an active mascot', () async {
      final c = await _container(
        user: const AppUserModel(uid: 'u', email: 'e'),
      );

      expect(c.read(hasNewEvolutionProvider), isFalse);
    });

    test('activeMascotStage is 1 while species data is loading', () async {
      final c = await pumpedContainer([
        activeMascotProvider.overrideWith(
          (_) => Stream.value(
            const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 30),
          ),
        ),
        mascotSpeciesDataProvider.overrideWith(
          (_) => Completer<List<MascotSpeciesModel>>().future,
        ),
      ], warm: activeMascotProvider);

      expect(c.read(activeMascotStageProvider), 1);
    });
  });
}
