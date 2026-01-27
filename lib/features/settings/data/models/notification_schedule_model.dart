import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_schedule_model.freezed.dart';
part 'notification_schedule_model.g.dart';

/// Model representing a single scheduled notification reminder.
///
/// Users can have multiple reminders throughout the day (up to 5).
/// Each reminder can be individually enabled/disabled.
@freezed
abstract class NotificationScheduleModel with _$NotificationScheduleModel {
  const factory NotificationScheduleModel({
    /// Unique identifier for this reminder (UUID).
    required String id,

    /// Hour of day (0-23).
    required int hour,

    /// Minute of hour (0-59).
    required int minute,

    /// Whether this individual reminder is enabled.
    @Default(true) bool isEnabled,

    /// Optional custom label (e.g., "Morning", "After work").
    @Default('') String label,
  }) = _NotificationScheduleModel;

  const NotificationScheduleModel._();

  factory NotificationScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleModelFromJson(json);

  /// Returns the time as a formatted string (e.g., "09:00").
  String get timeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Returns the time formatted for display (e.g., "9:00 AM").
  String get displayTime {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  /// Returns a unique notification ID based on the schedule ID.
  /// Used for scheduling/cancelling local notifications.
  int get notificationId => id.hashCode.abs() % 2147483647;
}
