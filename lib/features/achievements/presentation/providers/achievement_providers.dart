import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/achievements/data/datasources/achievements_remote_datasource.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/data/models/user_achievement_model.dart';
import 'package:seed_app/features/achievements/data/repositories/achievements_repository.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';

part 'achievement_providers.g.dart';

@riverpod
AchievementsRemoteDataSource achievementsRemoteDataSource(Ref ref) {
  return AchievementsRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
AchievementsRepository achievementsRepository(Ref ref) {
  return AchievementsRepository(
    remoteDataSource: ref.watch(achievementsRemoteDataSourceProvider),
  );
}

/// Bundled JSON catalog. `keepAlive` because the asset is static and
/// reading it on every screen mount wastes a frame.
@Riverpod(keepAlive: true)
Future<List<AchievementDefinition>> achievementDefinitions(Ref ref) {
  return ref.watch(achievementsRepositoryProvider).getDefinitions();
}

/// Streams the raw unlock records for a user (includes unlockedAt
/// timestamps). Use this when the UI needs the unlock date; otherwise
/// prefer [userUnlockedAchievementIds] for cheaper membership checks.
@riverpod
Stream<List<UserAchievementModel>> userAchievements(Ref ref, String userId) {
  return ref
      .watch(achievementsRepositoryProvider)
      .watchUserAchievements(userId);
}

/// Streams just the set of unlocked achievement ids -- the minimal
/// surface most badge/list UI needs.
@riverpod
Stream<Set<String>> userUnlockedAchievementIds(Ref ref, String userId) {
  return ref.watch(achievementsRepositoryProvider).watchUnlockedIds(userId);
}
