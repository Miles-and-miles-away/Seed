// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationScheduleModel _$NotificationScheduleModelFromJson(
  Map<String, dynamic> json,
) => _NotificationScheduleModel(
  id: json['id'] as String,
  hour: (json['hour'] as num).toInt(),
  minute: (json['minute'] as num).toInt(),
  isEnabled: json['isEnabled'] as bool? ?? true,
  label: json['label'] as String? ?? '',
);

Map<String, dynamic> _$NotificationScheduleModelToJson(
  _NotificationScheduleModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'hour': instance.hour,
  'minute': instance.minute,
  'isEnabled': instance.isEnabled,
  'label': instance.label,
};
