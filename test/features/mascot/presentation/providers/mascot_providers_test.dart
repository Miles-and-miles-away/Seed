import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';

ProviderContainer _container({
  AppUserModel? user,
  List<MascotModel>? mascots,
  MascotModel? active,
  List<MascotSpeciesModel>? species,
}) {
  return ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith((_) => Stream.value(user)),
      if (mascots != null)
        allMascotsProvider.overrideWith((_) => Stream.value(mascots)),
      if (active != null)
        activeMascotProvider.overrideWith((_) => Stream.value(active)),
      if (species != null)
        mascotSpeciesDataProvider.overrideWith((_) async => species),
    ],
  );
}

Future<void> _pump(ProviderContainer c) async {
  c
    ..listen(currentUserProvider, (_, __) {})
    ..listen(allMascotsProvider, (_, __) {})
    ..listen(activeMascotProvider, (_, __) {})
    ..listen(mascotSpeciesDataProvider, (_, __) {});
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('egg providers', () {
    test('currentEgg and hasEgg are null/false when user has no egg', () async {
      final c = _container(user: const AppUserModel(uid: 'u', email: 'e'));
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(currentEggProvider), isNull);
      expect(c.read(hasEggProvider), isFalse);
    });

    test('currentEgg returns the user egg model', () async {
      final egg = EggModel(
        receivedAt: DateTime.utc(2026),
        hatchingStreakDays: 5,
      );
      final c = _container(
        user: AppUserModel(uid: 'u', email: 'e', egg: egg),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(currentEggProvider), egg);
      expect(c.read(hasEggProvider), isTrue);
    });

    test('eggHatchingProgress is 0 when no egg, normalizes otherwise',
        () async {
      // No egg
      final noEgg = _container(user: const AppUserModel(uid: 'u', email: 'e'));
      addTearDown(noEgg.dispose);
      await _pump(noEgg);
      expect(noEgg.read(eggHatchingProgressProvider), 0);

      // Half-way
      final halfEgg = _container(
        user: AppUserModel(
          uid: 'u',
          email: 'e',
          egg: EggModel(
            receivedAt: DateTime.utc(2026),
            hatchingStreakDays: AppConstants.eggHatchingStreakRequired ~/ 2,
          ),
        ),
      );
      addTearDown(halfEgg.dispose);
      await _pump(halfEgg);
      expect(halfEgg.read(eggHatchingProgressProvider), closeTo(0.5, 0.02));

      // Over-full (should clamp to 1.0)
      final past = _container(
        user: AppUserModel(
          uid: 'u',
          email: 'e',
          egg: EggModel(
            receivedAt: DateTime.utc(2026),
            hatchingStreakDays: AppConstants.eggHatchingStreakRequired + 5,
          ),
        ),
      );
      addTearDown(past.dispose);
      await _pump(past);
      expect(past.read(eggHatchingProgressProvider), 1.0);
    });

    test('eggDaysRemaining clamps to the required streak count', () async {
      // No egg -> whole streak remaining
      final noEgg = _container(user: const AppUserModel(uid: 'u', email: 'e'));
      addTearDown(noEgg.dispose);
      await _pump(noEgg);
      expect(
        noEgg.read(eggDaysRemainingProvider),
        AppConstants.eggHatchingStreakRequired,
      );

      // 10 days in -> 20 remaining.
      final partway = _container(
        user: AppUserModel(
          uid: 'u',
          email: 'e',
          egg: EggModel(
            receivedAt: DateTime.utc(2026),
            hatchingStreakDays: 10,
          ),
        ),
      );
      addTearDown(partway.dispose);
      await _pump(partway);
      expect(
        partway.read(eggDaysRemainingProvider),
        AppConstants.eggHatchingStreakRequired - 10,
      );
    });

    test('shouldShowEggDiscovery reads the flag from user', () async {
      final c = _container(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          eggPendingDiscovery: true,
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(shouldShowEggDiscoveryProvider), isTrue);
    });
  });

  group('hasMascotProvider', () {
    test('false when mascot list is empty', () async {
      final c = _container(mascots: const []);
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(hasMascotProvider), isFalse);
    });

    test('true when list has mascots', () async {
      final c = _container(
        mascots: const [
          MascotModel(id: 'm1', speciesId: 'seed'),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

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
      final c = _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 12),
        species: species,
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(activeMascotStageProvider), 2);
    });

    test('activeMascotAssetPath returns the current stage asset', () async {
      final c = _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 30),
        species: species,
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(activeMascotAssetPathProvider), 'a/3.png');
    });

    test('activeNextStageData returns the upcoming stage or null', () async {
      final midway = _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 8),
        species: species,
      );
      addTearDown(midway.dispose);
      await _pump(midway);
      expect(midway.read(activeNextStageDataProvider)!.level, 10);

      final atMax = _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed', mascotLevel: 50),
        species: species,
      );
      addTearDown(atMax.dispose);
      await _pump(atMax);
      expect(atMax.read(activeNextStageDataProvider), isNull);
    });

    test('hasNewEvolution compares lastSeenStage to current stage', () async {
      final stale = _container(
        active: const MascotModel(
          id: 'm1',
          speciesId: 'seed',
          mascotLevel: 12,
        ),
        species: species,
      );
      addTearDown(stale.dispose);
      await _pump(stale);
      expect(stale.read(hasNewEvolutionProvider), isTrue);

      final current = _container(
        active: const MascotModel(
          id: 'm1',
          speciesId: 'seed',
          mascotLevel: 12,
          lastSeenStage: 2,
        ),
        species: species,
      );
      addTearDown(current.dispose);
      await _pump(current);
      expect(current.read(hasNewEvolutionProvider), isFalse);
    });

    test('stageLocalizedName falls back to English for unknown locale',
        () async {
      final c = _container(
        active: const MascotModel(id: 'm1', speciesId: 'seed'),
        species: species,
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(stageLocalizedNameProvider('fr')), 'Seed');
      expect(c.read(stageLocalizedNameProvider('ja')), 'シード');
      expect(c.read(stageLocalizedNameProvider('es')), 'Semilla');
    });
  });
}
