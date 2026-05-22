import 'package:flutter/foundation.dart';

import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_checker.dart';

/// Numeric progress toward an achievement: where the user currently
/// stands and what they need to reach. `special` criteria have no
/// numeric scale (they are binary), so `hasProgress` is false and
/// the UI should hide the progress bar.
@immutable
class AchievementProgress {
  const AchievementProgress({
    required this.current,
    required this.target,
    required this.hasProgress,
  });

  /// Always reports zero progress on a binary criterion -- used for
  /// `special` types where the badge is either locked or unlocked.
  const AchievementProgress.binary()
      : current = 0,
        target = 0,
        hasProgress = false;

  /// Latest measured stat value (clamped to `[0, target]` so the bar
  /// can render `current/target` directly without overshooting).
  final int current;

  /// The threshold the criterion requires.
  final int target;

  /// True for any numeric criterion. False for `special` -- callers
  /// should not render a progress bar in that case.
  final bool hasProgress;

  /// Fraction in `[0, 1]`. Zero for binary criteria, allowing the
  /// caller to pass it straight to `LinearProgressIndicator` without
  /// special-casing locked badges.
  double get fraction {
    if (!hasProgress || target <= 0) return 0;
    return current / target;
  }

  /// True once the user has met or exceeded the threshold. For
  /// binary criteria this is always false (use the unlocked-id set
  /// to decide whether to show the unlocked state instead).
  bool get isComplete => hasProgress && current >= target;
}

/// Computes how close the user is to satisfying `criteria` given
/// their post-update state snapshot. Pure: used both by the
/// AchievementsScreen progress bars and by the "next up" picker that
/// sorts unlocked-but-incomplete achievements by `fraction`.
AchievementProgress achievementProgressOf(
  AchievementCriteria criteria,
  AchievementUserState state,
) {
  return switch (criteria) {
    ActionCountCriteria(:final count, :final category) => _numeric(
        current: category == null
            ? state.totalActionsCount
            : (state.categoryActionCounts[category] ?? 0),
        target: count,
      ),
    StreakDaysCriteria(:final days) =>
      _numeric(current: state.currentStreak, target: days),
    LevelReachedCriteria(:final level) =>
      _numeric(current: state.level, target: level),
    SdgCountCriteria(:final count) =>
      _numeric(current: state.supportedSdgIds.length, target: count),
    Co2SavedCriteria(:final grams) =>
      _numeric(current: state.totalCo2Grams, target: grams),
    CategoriesCoveredCriteria(:final count) => _numeric(
        current: state.categoryActionCounts.values.where((v) => v > 0).length,
        target: count,
      ),
    SpecialCriteria() => const AchievementProgress.binary(),
  };
}

AchievementProgress _numeric({required int current, required int target}) {
  final clamped = current < 0 ? 0 : (current > target ? target : current);
  return AchievementProgress(
    current: clamped,
    target: target,
    hasProgress: true,
  );
}
