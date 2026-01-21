/// UI model for calendar day cells.
/// Not persisted - computed from DailySummaryModel.
class CalendarDayData {
  const CalendarDayData({
    required this.date,
    required this.goalCount,
    required this.goalTarget,
    required this.completedSdgs,
    required this.isToday,
    required this.isFuture,
  });

  /// The date this cell represents.
  final DateTime date;

  /// Number of goals completed this day.
  final int goalCount;

  /// User's daily goal target.
  final int goalTarget;

  /// List of SDG numbers completed (1-17).
  final List<int> completedSdgs;

  /// Whether this is today's date.
  final bool isToday;

  /// Whether this date is in the future.
  final bool isFuture;

  /// Completion ratio (0.0 to 1.0).
  double get completionRatio {
    if (goalTarget <= 0) return 0.0;
    return (goalCount / goalTarget).clamp(0.0, 1.0);
  }

  /// Whether the daily goal was fully achieved.
  bool get isGoalMet => goalCount >= goalTarget;

  /// Whether there's any activity for this day.
  bool get hasActivity => goalCount > 0;
}
