// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    _UserSettingsModel(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      reminderHour:
          (json['reminderHour'] as num?)?.toInt() ??
          AppConstants.defaultReminderHour,
      reminderMinute:
          (json['reminderMinute'] as num?)?.toInt() ??
          AppConstants.defaultReminderMinute,
      actionRemindersEnabled: json['actionRemindersEnabled'] as bool? ?? false,
      actionReminders:
          (json['actionReminders'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, ActionReminder.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      language: json['language'] as String?,
      hasSeenOnboarding: json['hasSeenOnboarding'] as bool? ?? false,
      seenStreakMilestones:
          (json['seenStreakMilestones'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      streakGracePeriodUsed: json['streakGracePeriodUsed'] as bool? ?? false,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
      themeMode: json['themeMode'] as String? ?? 'system',
      walkthroughFound:
          (json['walkthroughFound'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserSettingsModelToJson(_UserSettingsModel instance) =>
    <String, dynamic>{
      'notificationsEnabled': instance.notificationsEnabled,
      'reminderHour': instance.reminderHour,
      'reminderMinute': instance.reminderMinute,
      'actionRemindersEnabled': instance.actionRemindersEnabled,
      'actionReminders': instance.actionReminders,
      'language': instance.language,
      'hasSeenOnboarding': instance.hasSeenOnboarding,
      'seenStreakMilestones': instance.seenStreakMilestones,
      'streakGracePeriodUsed': instance.streakGracePeriodUsed,
      'analyticsEnabled': instance.analyticsEnabled,
      'themeMode': instance.themeMode,
      'walkthroughFound': instance.walkthroughFound,
    };
