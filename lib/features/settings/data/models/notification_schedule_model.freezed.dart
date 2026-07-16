// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationScheduleModel {

/// Unique identifier for this reminder (UUID).
 String get id;/// Hour of day (0-23).
 int get hour;/// Minute of hour (0-59).
 int get minute;/// Whether this individual reminder is enabled.
 bool get isEnabled;/// Optional custom label (e.g., "Morning", "After work").
 String get label;
/// Create a copy of NotificationScheduleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationScheduleModelCopyWith<NotificationScheduleModel> get copyWith => _$NotificationScheduleModelCopyWithImpl<NotificationScheduleModel>(this as NotificationScheduleModel, _$identity);

  /// Serializes this NotificationScheduleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hour,minute,isEnabled,label);

@override
String toString() {
  return 'NotificationScheduleModel(id: $id, hour: $hour, minute: $minute, isEnabled: $isEnabled, label: $label)';
}


}

/// @nodoc
abstract mixin class $NotificationScheduleModelCopyWith<$Res>  {
  factory $NotificationScheduleModelCopyWith(NotificationScheduleModel value, $Res Function(NotificationScheduleModel) _then) = _$NotificationScheduleModelCopyWithImpl;
@useResult
$Res call({
 String id, int hour, int minute, bool isEnabled, String label
});




}
/// @nodoc
class _$NotificationScheduleModelCopyWithImpl<$Res>
    implements $NotificationScheduleModelCopyWith<$Res> {
  _$NotificationScheduleModelCopyWithImpl(this._self, this._then);

  final NotificationScheduleModel _self;
  final $Res Function(NotificationScheduleModel) _then;

/// Create a copy of NotificationScheduleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hour = null,Object? minute = null,Object? isEnabled = null,Object? label = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationScheduleModel].
extension NotificationScheduleModelPatterns on NotificationScheduleModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationScheduleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationScheduleModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationScheduleModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationScheduleModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationScheduleModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationScheduleModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int hour,  int minute,  bool isEnabled,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationScheduleModel() when $default != null:
return $default(_that.id,_that.hour,_that.minute,_that.isEnabled,_that.label);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int hour,  int minute,  bool isEnabled,  String label)  $default,) {final _that = this;
switch (_that) {
case _NotificationScheduleModel():
return $default(_that.id,_that.hour,_that.minute,_that.isEnabled,_that.label);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int hour,  int minute,  bool isEnabled,  String label)?  $default,) {final _that = this;
switch (_that) {
case _NotificationScheduleModel() when $default != null:
return $default(_that.id,_that.hour,_that.minute,_that.isEnabled,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationScheduleModel extends NotificationScheduleModel {
  const _NotificationScheduleModel({required this.id, required this.hour, required this.minute, this.isEnabled = true, this.label = ''}): super._();
  factory _NotificationScheduleModel.fromJson(Map<String, dynamic> json) => _$NotificationScheduleModelFromJson(json);

/// Unique identifier for this reminder (UUID).
@override final  String id;
/// Hour of day (0-23).
@override final  int hour;
/// Minute of hour (0-59).
@override final  int minute;
/// Whether this individual reminder is enabled.
@override@JsonKey() final  bool isEnabled;
/// Optional custom label (e.g., "Morning", "After work").
@override@JsonKey() final  String label;

/// Create a copy of NotificationScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationScheduleModelCopyWith<_NotificationScheduleModel> get copyWith => __$NotificationScheduleModelCopyWithImpl<_NotificationScheduleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationScheduleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hour,minute,isEnabled,label);

@override
String toString() {
  return 'NotificationScheduleModel(id: $id, hour: $hour, minute: $minute, isEnabled: $isEnabled, label: $label)';
}


}

/// @nodoc
abstract mixin class _$NotificationScheduleModelCopyWith<$Res> implements $NotificationScheduleModelCopyWith<$Res> {
  factory _$NotificationScheduleModelCopyWith(_NotificationScheduleModel value, $Res Function(_NotificationScheduleModel) _then) = __$NotificationScheduleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, int hour, int minute, bool isEnabled, String label
});




}
/// @nodoc
class __$NotificationScheduleModelCopyWithImpl<$Res>
    implements _$NotificationScheduleModelCopyWith<$Res> {
  __$NotificationScheduleModelCopyWithImpl(this._self, this._then);

  final _NotificationScheduleModel _self;
  final $Res Function(_NotificationScheduleModel) _then;

/// Create a copy of NotificationScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hour = null,Object? minute = null,Object? isEnabled = null,Object? label = null,}) {
  return _then(_NotificationScheduleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
