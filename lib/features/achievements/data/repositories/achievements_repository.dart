import 'package:seed_app/features/achievements/data/achievement_definitions_data.dart';
import 'package:seed_app/features/achievements/data/datasources/achievements_remote_datasource.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/data/models/user_achievement_model.dart';

/// Coordinates the bundled achievement catalog with the user's
/// Firestore unlock state. Read-only operations expose definitions
/// and unlocked-id sets; the unlock write is delegated to the
/// remote datasource and remains a no-op when the achievement is
/// already unlocked.
class AchievementsRepository {
  AchievementsRepository({
    required this.remoteDataSource,
    Future<List<AchievementDefinition>> Function()? definitionsLoader,
  }) : _definitionsLoader = definitionsLoader ?? loadAchievementDefinitions;

  final AchievementsRemoteDataSource remoteDataSource;
  final Future<List<AchievementDefinition>> Function() _definitionsLoader;

  List<AchievementDefinition>? _cachedDefinitions;

  /// Loads the full catalog. Cached for the lifetime of the
  /// repository instance because definitions are static and read
  /// from a bundled asset.
  Future<List<AchievementDefinition>> getDefinitions() async {
    return _cachedDefinitions ??= await _definitionsLoader();
  }

  /// Watches the user's unlocked achievement records.
  Stream<List<UserAchievementModel>> watchUserAchievements(String userId) =>
      remoteDataSource.watchUserAchievements(userId);

  /// Watches the set of unlocked achievement ids. Convenience stream
  /// for UI that just needs to know "is this badge unlocked yet?".
  Stream<Set<String>> watchUnlockedIds(String userId) => remoteDataSource
      .watchUserAchievements(userId)
      .map((records) => records.map((r) => r.id).toSet());

  /// One-shot read of the unlocked-id set, used by the §6.7 checker
  /// before evaluating criteria.
  Future<Set<String>> getUnlockedIds(String userId) async {
    final records = await remoteDataSource.getUserAchievements(userId);
    return records.map((r) => r.id).toSet();
  }

  /// Writes an unlock record. No-op if the achievement is already
  /// unlocked. Point awarding is performed separately by the §6.7
  /// checker in the same user-doc transaction.
  Future<void> unlockAchievement(String userId, String achievementId) =>
      remoteDataSource.unlockAchievement(userId, achievementId);

  /// Marks the achievement's bonus points as claimed (called after
  /// the celebration screen finishes).
  Future<void> markPointsClaimed(String userId, String achievementId) =>
      remoteDataSource.markPointsClaimed(userId, achievementId);
}
