// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    _UserSettingsModel(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      reminderSchedules: (json['reminderSchedules'] as List<dynamic>?)
              ?.map((e) =>
                  NotificationScheduleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      smartRemindersEnabled: json['smartRemindersEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      hasSeenOnboarding: json['hasSeenOnboarding'] as bool? ?? false,
      seenStreakMilestones:
          (json['seenStreakMilestones'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as bool),
              ) ??
              const {},
      streakGracePeriodUsed: json['streakGracePeriodUsed'] as bool? ?? false,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$UserSettingsModelToJson(_UserSettingsModel instance) =>
    <String, dynamic>{
      'notificationsEnabled': instance.notificationsEnabled,
      'reminderSchedules': instance.reminderSchedules,
      'smartRemindersEnabled': instance.smartRemindersEnabled,
      'language': instance.language,
      'hasSeenOnboarding': instance.hasSeenOnboarding,
      'seenStreakMilestones': instance.seenStreakMilestones,
      'streakGracePeriodUsed': instance.streakGracePeriodUsed,
      'analyticsEnabled': instance.analyticsEnabled,
    };
