import 'package:seed_app/features/progress/domain/entities/time_period.dart';

/// A half-open date range `[start, end)` at day granularity, in the
/// device's local timezone.
class DateRange {
  const DateRange(this.start, this.end);

  /// Inclusive start of the range, normalized to local midnight.
  final DateTime start;

  /// Exclusive end of the range, normalized to local midnight.
  final DateTime end;
}

/// Pure helpers for translating a [TimePeriod] into the date range it
/// covers and the equivalent previous-period range used for comparison.
///
/// Week is Monday-Sunday. All ranges are computed in the device's local
/// timezone using [DateTime.now] (or the injected [now] for tests).
class TimePeriodRange {
  const TimePeriodRange._();

  /// Range covering the current period.
  static DateRange current(TimePeriod period, {DateTime? now}) {
    final today = _midnight(now ?? DateTime.now());
    switch (period) {
      case TimePeriod.today:
        return DateRange(today, _addDays(today, 1));
      case TimePeriod.thisWeek:
        final weekStart = _startOfWeek(today);
        return DateRange(weekStart, _addDays(weekStart, 7));
      case TimePeriod.thisMonth:
        final monthStart = DateTime(today.year, today.month);
        return DateRange(monthStart, _addMonths(monthStart, 1));
      case TimePeriod.allTime:
        return DateRange(DateTime.fromMillisecondsSinceEpoch(0), today);
    }
  }

  /// Range covering the period immediately before [period], used to
  /// compute period-over-period comparisons. Same duration semantics as
  /// the current period (yesterday / last week / last month).
  ///
  /// For [TimePeriod.allTime] there is no meaningful previous period;
  /// callers should hide comparison UI in that case. We still return a
  /// zero-width range (`start == end`) so totals computed against it
  /// are 0.
  static DateRange previous(TimePeriod period, {DateTime? now}) {
    final today = _midnight(now ?? DateTime.now());
    switch (period) {
      case TimePeriod.today:
        final yesterday = _addDays(today, -1);
        return DateRange(yesterday, today);
      case TimePeriod.thisWeek:
        final weekStart = _startOfWeek(today);
        final lastWeekStart = _addDays(weekStart, -7);
        return DateRange(lastWeekStart, weekStart);
      case TimePeriod.thisMonth:
        final monthStart = DateTime(today.year, today.month);
        final lastMonthStart = _addMonths(monthStart, -1);
        return DateRange(lastMonthStart, monthStart);
      case TimePeriod.allTime:
        return DateRange(today, today);
    }
  }

  /// Number of days the trend chart should plot for [period]. The
  /// chart is a rolling window ending today (inclusive), not a
  /// calendar period -- when the user is partway through "This Week"
  /// we still want a meaningful 7-bar/dot history, not just Mon-Tue.
  static int trendWindowDays(TimePeriod period) => switch (period) {
        TimePeriod.today => 7,
        TimePeriod.thisWeek => 7,
        TimePeriod.thisMonth => 30,
        TimePeriod.allTime => 90,
      };

  /// Half-open rolling-window range for the trend chart: the last
  /// `trendWindowDays(period)` days ending at tomorrow's midnight
  /// (so today is included).
  static DateRange trendWindow(TimePeriod period, {DateTime? now}) {
    final today = _midnight(now ?? DateTime.now());
    final days = trendWindowDays(period);
    return DateRange(_addDays(today, -(days - 1)), _addDays(today, 1));
  }

  /// Local-midnight version of [d] (drops time-of-day).
  static DateTime _midnight(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Start of the ISO week containing [d] (Monday at local midnight).
  /// Dart's `DateTime.weekday` returns 1=Monday..7=Sunday, so we
  /// subtract `weekday - 1` days.
  static DateTime _startOfWeek(DateTime d) {
    final midnight = _midnight(d);
    return _addDays(midnight, -(midnight.weekday - 1));
  }

  /// Adds [days] to [d] using calendar arithmetic so DST transitions
  /// don't shift the result by an hour.
  static DateTime _addDays(DateTime d, int days) =>
      DateTime(d.year, d.month, d.day + days);

  /// Adds [months] to [d] using calendar arithmetic. Day-of-month is
  /// preserved as much as possible; constructor handles overflow
  /// (e.g., Jan 31 + 1 month -> Mar 3, which is fine because we only
  /// pass first-of-month dates).
  static DateTime _addMonths(DateTime d, int months) =>
      DateTime(d.year, d.month + months, d.day);
}
