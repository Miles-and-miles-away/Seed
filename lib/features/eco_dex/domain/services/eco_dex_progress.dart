import 'package:flutter/foundation.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/domain/services/condition_evaluator.dart';

/// Numeric progress toward discovering an Eco-Dex entry: where the
/// user currently stands and the threshold the condition requires.
/// Binary conditions (profile complete, specific multi-day challenge)
/// have no numeric scale, so `hasProgress` is false and the UI should
/// hide the progress bar.
@immutable
class EcoDexProgress {
  const EcoDexProgress({
    required this.current,
    required this.target,
    required this.hasProgress,
  });

  /// Always reports zero progress on a binary condition -- the entry
  /// is either locked or discovered with nothing in between.
  const EcoDexProgress.binary() : current = 0, target = 0, hasProgress = false;

  /// Latest measured stat value (clamped to `[0, target]` so the bar
  /// can render `current/target` directly without overshooting).
  final int current;

  /// The threshold the condition requires.
  final int target;

  /// True for any numeric condition. False for binary conditions --
  /// callers should not render a progress bar in that case.
  final bool hasProgress;

  /// Fraction in `[0, 1]`. Zero for binary conditions, allowing the
  /// caller to pass it straight to `LinearProgressIndicator` without
  /// special-casing locked entries.
  double get fraction {
    if (!hasProgress || target <= 0) return 0;
    return current / target;
  }
}

/// Computes how close the user is to satisfying `condition`. Pure:
/// used by the locked-entry sheet progress bar and by the "next up"
/// picker that sorts undiscovered entries by `fraction`.
EcoDexProgress ecoDexProgressOf(EcoDexCondition condition, AppUserModel user) {
  return switch (condition) {
    TotalActionsCondition(:final count) => _numeric(
      current: user.totalActionsCount,
      target: count,
    ),
    CategoryActionsCondition(:final category, :final count) => _numeric(
      current: categoryActionCount(user, category),
      target: count,
    ),
    Co2SavedCondition(:final grams) => _numeric(
      current: user.totalCo2Grams,
      target: grams,
    ),
    StreakDaysCondition(:final days) => _numeric(
      current: user.longestStreak,
      target: days,
    ),
    LevelReachedCondition(:final level) => _numeric(
      current: user.level,
      target: level,
    ),
    SdgBreadthCondition(:final count) => _numeric(
      current: sdgBreadthCount(user),
      target: count,
    ),
    ChallengeStreakCondition(:final days) => _numeric(
      current: user.challengeStreak,
      target: days,
    ),
    MultiDayChallengeCondition() => const EcoDexProgress.binary(),
    EcoFactsViewedCondition(:final count) => _numeric(
      current: user.viewedFactDates.length,
      target: count,
    ),
    CategoriesCoveredCondition(:final count) => _numeric(
      current: categoriesCoveredCount(user),
      target: count,
    ),
    UniqueActionsLoggedCondition(:final count) => _numeric(
      current: user.uniqueActionIds.length,
      target: count,
    ),
    ProfileCompleteCondition() => const EcoDexProgress.binary(),
    EcodexCountCondition(:final count) => _numeric(
      current: user.ecodexDiscovered.length,
      target: count,
    ),
    ChallengesCompletedCondition(:final count) => _numeric(
      current: user.challengesCompleted,
      target: count,
    ),
    UniqueZeroCo2ActionsCondition(:final count) => _numeric(
      current: uniqueZeroCo2ActionsCount(user),
      target: count,
    ),
  };
}

EcoDexProgress _numeric({required int current, required int target}) =>
    EcoDexProgress(
      current: target <= 0 ? 0 : current.clamp(0, target),
      target: target,
      hasProgress: true,
    );
