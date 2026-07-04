import 'dart:math' as math;

import 'package:seed_app/core/utils/date_helpers.dart';

/// Streak calculations and milestone tracking.

/// Weekly milestone thresholds (in weeks).
/// Celebrations are triggered when streak crosses these thresholds.
const List<int> weekMilestones = [
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
  if (lastActionDate == null) {
    // First action ever - start streak at 1
    return StreakUpdateResult(
      currentStreak: 1,
      longestStreak: math.max(1, longestStreak),
      previousStreak: 0,
    );
  }

  final difference = calendarDaysBetween(lastActionDate, now);

  if (difference <= 0) {
    // Same day - streak continues but doesn't increment. Negative
    // differences happen after travelling west across timezones;
    // treating them as a gap would unfairly reset the streak.
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

/// The streak value the UI should display.
///
/// The stored streak is only corrected by the next log, so after a
/// missed day it still holds the old value; a gap of more than one
/// calendar day means the streak is already broken. A null
/// [lastActionDate] with a positive stored streak is a pending
/// serverTimestamp (latency-compensated local write) and is treated
/// as live to avoid a flicker to zero right after logging.
int displayedStreak({
  required int storedStreak,
  required DateTime? lastActionDate,
  required DateTime now,
}) {
  if (lastActionDate == null) return storedStreak;
  if (calendarDaysBetween(lastActionDate, now) > 1) return 0;
  return storedStreak;
}

/// Checks if the user crossed a weekly milestone.
///
/// Returns the milestone week number if a milestone was crossed,
/// or null if no milestone was crossed.
int? _checkMilestoneCrossing(int oldStreak, int newStreak) {
  final oldWeeks = oldStreak ~/ 7;
  final newWeeks = newStreak ~/ 7;

  if (newWeeks > oldWeeks && newWeeks > 0) {
    // Check if this week count is a milestone
    if (weekMilestones.contains(newWeeks)) {
      return newWeeks;
    }
  }
  return null;
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
