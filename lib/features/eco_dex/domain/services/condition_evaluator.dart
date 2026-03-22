import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';

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
  };
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
