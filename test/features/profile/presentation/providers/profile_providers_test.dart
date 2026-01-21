import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/profile/presentation/providers/profile_providers.dart';

/// Helper to create a container with a user override and wait for the stream.
Future<ProviderContainer> createContainerWithUser(AppUserModel? user) async {
  final container = ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith(
        (ref) => Stream.value(user),
      ),
    ],
  );

  // Subscribe and wait for the stream to emit
  final subscription = container.listen(currentUserProvider, (_, __) {});

  // Give time for the stream to emit
  await Future<void>.delayed(Duration.zero);

  // Clean up subscription but keep container
  subscription.close();

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
        points: 175, // Mid-way through level 2
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

    test('returns correct stage for level 1 user', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        level: 5,
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 1);
    });

    test('returns stage 2 for level 10+ user', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        level: 15,
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 2);
    });

    test('returns stage 3 for level 25+ user', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        level: 30,
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 3);
    });

    test('returns stage 4 for level 50+ user', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        level: 60,
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final stage = container.read(evolutionStageProvider);
      expect(stage, 4);
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
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
      );

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

  group('streakBonusProvider', () {
    test('returns 1 when user is null', () async {
      final container = await createContainerWithUser(null);
      addTearDown(container.dispose);

      final bonus = container.read(streakBonusProvider);
      expect(bonus, 1);
    });

    test('returns correct bonus for streak', () async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        currentStreak: 10,
      );

      final container = await createContainerWithUser(user);
      addTearDown(container.dispose);

      final bonus = container.read(streakBonusProvider);
      expect(bonus, calculateStreakBonus(10));
    });
  });
}
