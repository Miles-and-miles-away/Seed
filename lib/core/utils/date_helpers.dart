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

import 'package:intl/intl.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// The calendar date of [date] projected into UTC.
DateTime dateOnlyUtc(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day);

/// Whole calendar days from [from] to [to].
///
/// Negative when [to] is on an earlier calendar day, which happens
/// legitimately after travelling west across timezones.
int calendarDaysBetween(DateTime from, DateTime to) =>
    dateOnlyUtc(to).difference(dateOnlyUtc(from)).inDays;

/// Whether [a] and [b] fall on the same local calendar day.
bool isSameCalendarDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// The calendar day before [date].
DateTime previousCalendarDay(DateTime date) =>
    DateTime(date.year, date.month, date.day - 1);

/// Formats a date as yyyy-MM-dd for storage.
String formatDateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Human label for a calendar day: "Today", "Yesterday", or a
/// locale-aware weekday + date (year included when not the current
/// year). Shared by the history list and the day-detail sheet so the
/// same day is always labelled identically.
String formatDateLabel(
  DateTime date,
  AppLocalizations l10n,
  String locale, {
  DateTime? now,
}) {
  now ??= DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(date.year, date.month, date.day);
  if (d == today) return l10n.today;
  if (d == previousCalendarDay(today)) return l10n.yesterday;
  return date.year == today.year
      ? DateFormat.MMMMEEEEd(locale).format(date)
      : DateFormat.yMMMMEEEEd(locale).format(date);
}
