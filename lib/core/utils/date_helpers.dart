/// Calendar-day arithmetic that is safe across DST transitions.
///
/// Local wall-clock subtraction (`midnight.difference(midnight)`,
/// `subtract(Duration(days: 1))`) miscounts days around DST shifts
/// because local days are not always 24 hours: the day after
/// spring-forward computes as 0 days away, and subtracting 24h at
/// 00:30 lands two calendar days back. Projecting the calendar date
/// into UTC, where every day is exactly 24 hours, makes the
/// arithmetic exact.
library;

/// The calendar date of [date] projected into UTC.
DateTime dateOnlyUtc(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day);

/// Whole calendar days from [from] to [to].
///
/// Negative when [to] is on an earlier calendar day, which happens
/// legitimately after travelling west across timezones.
int calendarDaysBetween(DateTime from, DateTime to) =>
    dateOnlyUtc(to).difference(dateOnlyUtc(from)).inDays;

/// The calendar day before [date].
DateTime previousCalendarDay(DateTime date) =>
    DateTime(date.year, date.month, date.day - 1);
