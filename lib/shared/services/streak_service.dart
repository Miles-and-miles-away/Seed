import 'dart:math' as math;

/// Service for streak-related calculations and milestone tracking.
///
/// Provides utility methods for:
/// - Converting streak days to weeks
/// - Detecting weekly milestone crossings
/// - Determining which milestones should trigger celebrations
class StreakService {
  StreakService._();

  static final StreakService instance = StreakService._();

  /// Weekly milestone thresholds (in weeks).
  /// Celebrations are triggered when streak crosses these thresholds.
  static const List<int> weekMilestones = [
    1, // 1 week (7 days)
    2, // 2 weeks (14 days)
    3, // 3 weeks (21 days)
    4, // 4 weeks (28 days)
    8, // 2 months
    12, // 3 months
    26, // 6 months
    52, // 1 year
  ];

  /// Calculates streak data when a user logs an action.
  ///
  /// Returns a [StreakUpdateResult] containing:
  /// - The new current streak
  /// - The new longest streak
  /// - Whether a weekly milestone was crossed
  StreakUpdateResult calculateStreakUpdate({
    required DateTime? lastActionDate,
    required int currentStreak,
    required int longestStreak,
    required DateTime now,
  }) {
    final today = DateTime(now.year, now.month, now.day);

    if (lastActionDate == null) {
      // First action ever - start streak at 1
      return StreakUpdateResult(
        currentStreak: 1,
        longestStreak: math.max(1, longestStreak),
        previousStreak: 0,
      );
    }

    final lastDate = DateTime(
      lastActionDate.year,
      lastActionDate.month,
      lastActionDate.day,
    );
    final difference = today.difference(lastDate).inDays;

    if (difference == 0) {
      // Same day - streak continues but doesn't increment
      return StreakUpdateResult(
        currentStreak: math.max(1, currentStreak),
        longestStreak: longestStreak,
        previousStreak: currentStreak,
      );
    } else if (difference == 1) {
      // Consecutive day - increment streak
      final previousStreak = currentStreak;
      final newStreak = currentStreak + 1;
      final newLongest = math.max(newStreak, longestStreak);

      // Check for milestone crossing
      final milestoneWeek = _checkMilestoneCrossing(previousStreak, newStreak);

      return StreakUpdateResult(
        currentStreak: newStreak,
        longestStreak: newLongest,
        previousStreak: previousStreak,
        crossedMilestoneWeek: milestoneWeek,
      );
    } else {
      // Gap in days - reset streak
      return StreakUpdateResult(
        currentStreak: 1,
        longestStreak: longestStreak,
        previousStreak: currentStreak,
        streakWasBroken: currentStreak > 1,
      );
    }
  }

  /// Converts streak days to complete weeks.
  int getStreakWeeks(int streakDays) {
    return streakDays ~/ 7;
  }

  /// Checks if the user crossed a weekly milestone.
  ///
  /// Returns the milestone week number if a milestone was crossed,
  /// or null if no milestone was crossed.
  int? _checkMilestoneCrossing(int oldStreak, int newStreak) {
    final oldWeeks = getStreakWeeks(oldStreak);
    final newWeeks = getStreakWeeks(newStreak);

    if (newWeeks > oldWeeks && newWeeks > 0) {
      // Check if this week count is a milestone
      if (weekMilestones.contains(newWeeks)) {
        return newWeeks;
      }
    }
    return null;
  }

  /// Gets the next milestone week from the current streak.
  ///
  /// Returns null if the user has passed all defined milestones.
  int? getNextMilestoneWeek(int currentStreak) {
    final currentWeeks = getStreakWeeks(currentStreak);

    for (final milestone in weekMilestones) {
      if (milestone > currentWeeks) {
        return milestone;
      }
    }
    return null;
  }

  /// Gets days until the next milestone.
  ///
  /// Returns null if the user has passed all defined milestones.
  int? getDaysUntilNextMilestone(int currentStreak) {
    final nextWeek = getNextMilestoneWeek(currentStreak);
    if (nextWeek == null) return null;

    return (nextWeek * 7) - currentStreak;
  }

  /// Returns a human-readable milestone description.
  String getMilestoneDescription(int weeks) {
    return switch (weeks) {
      1 => '1 week',
      2 => '2 weeks',
      3 => '3 weeks',
      4 => '1 month',
      8 => '2 months',
      12 => '3 months',
      26 => '6 months',
      52 => '1 year',
      _ => '$weeks weeks',
    };
  }
}

/// Result of a streak calculation update.
class StreakUpdateResult {
  const StreakUpdateResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.previousStreak,
    this.crossedMilestoneWeek,
    this.streakWasBroken = false,
  });

  /// The new current streak value.
  final int currentStreak;

  /// The new longest streak value.
  final int longestStreak;

  /// The streak value before this update.
  final int previousStreak;

  /// The milestone week that was crossed (if any).
  /// Only set when the streak crosses a weekly milestone threshold.
  final int? crossedMilestoneWeek;

  /// Whether the streak was broken (reset from > 1 to 1).
  final bool streakWasBroken;

  /// Whether a milestone celebration should be shown.
  bool get shouldShowMilestone => crossedMilestoneWeek != null;
}
