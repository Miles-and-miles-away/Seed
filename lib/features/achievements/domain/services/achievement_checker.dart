import 'package:flutter/foundation.dart';

import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';

/// Snapshot of the user-state subset that achievement criteria
/// evaluate against. Always represents the **post-update** state
/// (e.g. after `logAction` has folded the new action into the
/// running totals) so the checker can be a pure function.
@immutable
class AchievementUserState {
  AchievementUserState({
    required this.totalActionsCount,
    required this.totalCo2Grams,
    required this.currentStreak,
    required this.level,
    required Map<String, int> categoryActionCounts,
    required Set<String> supportedSdgIds,
  })  : categoryActionCounts = Map.unmodifiable(categoryActionCounts),
        supportedSdgIds = Set.unmodifiable(supportedSdgIds);

  final int totalActionsCount;
  final int totalCo2Grams;
  final int currentStreak;
  final int level;

  /// Per-category counts, e.g. `{ 'recycling': 12, 'food': 5 }`.
  /// Wrapped at construction so the checker cannot be perturbed by a
  /// caller mutating the source map after the snapshot was taken.
  final Map<String, int> categoryActionCounts;

  /// SDG ids the user has logged at least one action for. Stored as
  /// a set so `sdgCount` is O(1) on size.
  final Set<String> supportedSdgIds;
}

/// Pure synchronous evaluator: returns the definitions whose criteria
/// are satisfied by `state` and that are not in `alreadyUnlockedIds`.
/// Caller is responsible for actually writing the unlock records and
/// awarding bonus points (atomically with the state-change txn).
class AchievementChecker {
  const AchievementChecker();

  List<AchievementDefinition> findNewlyUnlocked({
    required List<AchievementDefinition> definitions,
    required Set<String> alreadyUnlockedIds,
    required AchievementUserState state,
  }) {
    final newly = <AchievementDefinition>[];
    for (final def in definitions) {
      if (alreadyUnlockedIds.contains(def.id)) continue;
      if (_isMet(def.criteria, state)) {
        newly.add(def);
      }
    }
    return newly;
  }

  bool _isMet(AchievementCriteria criteria, AchievementUserState s) {
    return switch (criteria) {
      ActionCountCriteria(:final count, :final category) => category == null
          ? s.totalActionsCount >= count
          : (s.categoryActionCounts[category] ?? 0) >= count,
      StreakDaysCriteria(:final days) => s.currentStreak >= days,
      LevelReachedCriteria(:final level) => s.level >= level,
      SdgCountCriteria(:final count) => s.supportedSdgIds.length >= count,
      Co2SavedCriteria(:final grams) => s.totalCo2Grams >= grams,
      CategoriesCoveredCriteria(:final count) =>
        s.categoryActionCounts.values.where((v) => v > 0).length >= count,
      // `totalActionsCount == 1` is the post-update snapshot of the
      // user's very first logged action; it also evaluates to `false`
      // on screen-time snapshots where the count has moved past 1.
      SpecialCriteria(:final specialType) => switch (specialType) {
          'first_action' => s.totalActionsCount == 1,
          _ => false,
        },
    };
  }
}
