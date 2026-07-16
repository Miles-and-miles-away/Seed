import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/profile/presentation/providers/profile_providers.dart';

const _stages = [
  EvolutionStageModel(
    level: 1,
    assetPath: 'a/1.png',
    nameEn: 'Seed',
    nameJa: 'Shiido',
  ),
  EvolutionStageModel(
    level: 10,
    assetPath: 'a/2.png',
    nameEn: 'Sprout',
    nameJa: 'Me',
  ),
  EvolutionStageModel(
    level: 25,
    assetPath: 'a/3.png',
    nameEn: 'Tree',
    nameJa: 'Ki',
  ),
];

const _species = [
  MascotSpeciesModel(
    id: 'seed',
    nameEn: 'Seed',
    nameJa: 'Shiido',
    descriptionEn: '',
    descriptionJa: '',
    evolutionStages: _stages,
  ),
];

/// Helper to create a container with a user override and wait for the stream.
///
/// Mascot providers are always overridden (null active mascot by default)
/// so evolutionStageProvider never touches Firestore in tests.
Future<ProviderContainer> createContainerWithUser(
  AppUserModel? user, {
  MascotModel? activeMascot,
}) async {
  final container = ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith((ref) => Stream.value(user)),
      activeMascotProvider.overrideWith((ref) => Stream.value(activeMascot)),
      mascotSpeciesDataProvider.overrideWith((ref) async => _species),
    ],
  );

  // Subscribe and wait for the streams to emit
  final subscriptions = [
    container.listen(currentUserProvider, (_, _) {}),
    container.listen(activeMascotProvider, (_, _) {}),
    container.listen(mascotSpeciesDataProvider, (_, _) {}),
  ];

  // Give time for the streams to emit
  await Future<void>.delayed(Duration.zero);

  // Clean up subscriptions but keep container
  for (final subscription in subscriptions) {
    subscription.close();
  }

  return container;
}

void main() {
  group('levelProgressProvider', () {
    test('returns 0 when user is null', () async {
      final container = await createContainerWithUser(null);
      addTearDown(container.dispose);

      final progress = container.read(levelProgressProvider);
      expect(progress, 0);
    });

    test('returns correct progress when user has points', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        points: 152, // Mid-way through level 2 (100-205 at scale 1.05)
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final progress = container.read(levelProgressProvider);
      expect(progress, closeTo(0.5, 0.1));
    });
  });

  group('pointsToNextLevelProvider', () {
    test('returns 0 when user is null', () async {
      final container = await createContainerWithUser(null);
      addTearDown(container.dispose);

      final points = container.read(pointsToNextLevelProvider);
      expect(points, 0);
    });

    test('returns correct points when user exists', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        points: 50, // Level 1, needs 50 more to reach level 2
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final points = container.read(pointsToNextLevelProvider);
      expect(points, 50);
    });
  });

  group('evolutionStageProvider', () {
    test('returns 1 when user is null', () async {
      final container = await createContainerWithUser(null);
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 1);
    });

    test('falls back to stage 1 when the user has no mascot yet', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        level: 30,
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 1);
    });

    test('derives the stage from the active mascot level', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        level: 5,
      );

      final container = await createContainerWithUser(
        user,
        activeMascot: const MascotModel(
          id: 'm1',
          speciesId: 'seed',
          mascotLevel: 12,
        ),
      );
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 2);
    });

    test('ignores the global account level when it diverges', () async {
      // A second mascot starts back at level 1 while the account level
      // keeps growing; the badge must follow the active mascot.
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        level: 60,
      );

      final container = await createContainerWithUser(
        user,
        activeMascot: const MascotModel(id: 'm2', speciesId: 'seed'),
      );
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 1);
    });

    test('returns the top stage at high mascot levels', () async {
      final user = AppUserModel(uid: 'test-uid', email: 'test@example.com');

      final container = await createContainerWithUser(
        user,
        activeMascot: const MascotModel(
          id: 'm1',
          speciesId: 'seed',
          mascotLevel: 30,
        ),
      );
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 3);
    });
  });

  group('daysSinceJoinedProvider', () {
    test('returns 0 when user is null', () async {
      final container = await createContainerWithUser(null);
      addTearDown(container.dispose);

      final days = container.read(daysSinceJoinedProvider);
      expect(days, 0);
    });

    test('returns 0 when createdAt is null', () async {
      final user = AppUserModel(uid: 'test-uid', email: 'test@example.com');

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final days = container.read(daysSinceJoinedProvider);
      expect(days, 0);
    });

    test('returns correct days since joined', () async {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: thirtyDaysAgo,
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final days = container.read(daysSinceJoinedProvider);
      expect(days, 30);
    });
  });
}
