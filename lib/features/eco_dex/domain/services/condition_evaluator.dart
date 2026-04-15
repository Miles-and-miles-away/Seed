import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/domain/constants/zero_co2_action_ids.dart';

/// Checks if a condition is met given the user's stats.
bool isConditionMet(
  EcoDexCondition condition,
  AppUserModel user,
) {
  return switch (condition) {
    TotalActionsCondition(:final count) => user.totalActionsCount >= count,
    CategoryActionsCondition(
      :final category,
      :final count,
    ) =>
      categoryActionCount(user, category) >= count,
    Co2SavedCondition(:final grams) => user.totalCo2Grams >= grams,
    StreakDaysCondition(:final days) => user.longestStreak >= days,
    LevelReachedCondition(:final level) => user.level >= level,
    SdgBreadthCondition(:final count) => sdgBreadthCount(user) >= count,
    ChallengeStreakCondition(:final days) => user.challengeStreak >= days,
    MultiDayChallengeCondition(:final templateId) =>
      user.completedMultiDayChallenges.contains(templateId),
    EcoFactsViewedCondition(:final count) =>
      user.viewedFactDates.length >= count,
    CategoriesCoveredCondition(:final count) =>
      categoriesCoveredCount(user) >= count,
    UniqueActionsLoggedCondition(:final count) =>
      user.uniqueActionIds.length >= count,
    ProfileCompleteCondition() =>
      user.displayName != null && user.photoUrl != null,
    EcodexCountCondition(:final count) => user.ecodexDiscovered.length >= count,
    ChallengesCompletedCondition(:final count) =>
      user.challengesCompleted >= count,
    UniqueZeroCo2ActionsCondition(:final count) =>
      uniqueZeroCo2ActionsCount(user) >= count,
  };
}

/// Counts distinct zero-CO2 ("selfless") actions the user has ever logged.
int uniqueZeroCo2ActionsCount(AppUserModel user) {
  return user.uniqueActionIds.where(zeroCo2ActionIds.contains).length;
}

/// Counts actions in a specific category.
int categoryActionCount(
  AppUserModel user,
  String category,
) {
  final counts = user.categoryActionCounts;
  return counts[category] ?? 0;
}

/// Counts distinct SDGs the user has logged actions for.
int sdgBreadthCount(AppUserModel user) {
  return user.sdgStats.keys.length;
}

/// Counts distinct action categories with at least one action.
int categoriesCoveredCount(AppUserModel user) {
  return user.categoryActionCounts.entries.where((e) => e.value > 0).length;
}
