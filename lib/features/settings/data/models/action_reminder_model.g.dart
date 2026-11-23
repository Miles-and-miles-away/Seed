// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionReminder _$ActionReminderFromJson(Map<String, dynamic> json) =>
    _ActionReminder(
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
      weekdays: (json['weekdays'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      lastDay: json['lastDay'] as String?,
    );

Map<String, dynamic> _$ActionReminderToJson(_ActionReminder instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
      'weekdays': instance.weekdays,
      'lastDay': instance.lastDay,
    };
