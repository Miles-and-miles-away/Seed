import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/core/utils/date_helpers.dart';

part 'action_reminder_model.freezed.dart';
part 'action_reminder_model.g.dart';

/// A user-scheduled reminder for one library action.
@freezed
abstract class ActionReminder with _$ActionReminder {
  const factory ActionReminder({
    required int hour,
    required int minute,

    /// [DateTime.weekday] values the reminder fires on.
    required List<int> weekdays,

    /// Date key of the last reminder day; null repeats forever.
    String? lastDay,
  }) = _ActionReminder;

  const ActionReminder._();

  factory ActionReminder.fromJson(Map<String, dynamic> json) =>
      _$ActionReminderFromJson(json);

  /// Whether [day] is on or before [lastDay].
  bool coversDay(DateTime day) =>
      lastDay == null || formatDateKey(day).compareTo(lastDay!) <= 0;
}
