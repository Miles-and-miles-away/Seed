// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_reminder_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionReminder {

 int get hour; int get minute;/// [DateTime.weekday] values the reminder fires on.
 List<int> get weekdays;/// Date key of the last reminder day; null repeats forever.
 String? get lastDay;
/// Create a copy of ActionReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionReminderCopyWith<ActionReminder> get copyWith => _$ActionReminderCopyWithImpl<ActionReminder>(this as ActionReminder, _$identity);

  /// Serializes this ActionReminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ActionReminder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionReminder&&(identical(other.hour, _this.hour) || other.hour == _this.hour)&&(identical(other.minute, _this.minute) || other.minute == _this.minute)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays)&&(identical(other.lastDay, _this.lastDay) || other.lastDay == _this.lastDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ActionReminder;
  return Object.hash(runtimeType,_this.hour,_this.minute,const DeepCollectionEquality().hash(_this.weekdays),_this.lastDay);
}

@override
String toString() {
  final _this = this as ActionReminder;
  return 'ActionReminder(hour: ${_this.hour}, minute: ${_this.minute}, weekdays: ${_this.weekdays}, lastDay: ${_this.lastDay})';
}


}

/// @nodoc
abstract mixin class $ActionReminderCopyWith<$Res>  {
  factory $ActionReminderCopyWith(ActionReminder value, $Res Function(ActionReminder) _then) = _$ActionReminderCopyWithImpl;
@useResult
$Res call({
 int hour, int minute, List<int> weekdays, String? lastDay
});




}
/// @nodoc
class _$ActionReminderCopyWithImpl<$Res>
    implements $ActionReminderCopyWith<$Res> {
  _$ActionReminderCopyWithImpl(this._self, this._then);

  final ActionReminder _self;
  final $Res Function(ActionReminder) _then;

/// Create a copy of ActionReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? minute = null,Object? weekdays = null,Object? lastDay = freezed,}) {
  return _then(ActionReminder(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,lastDay: freezed == lastDay ? _self.lastDay : lastDay // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionReminder].
extension ActionReminderPatterns on ActionReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionReminder value)  $default,){
final _that = this;
switch (_that) {
case _ActionReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionReminder value)?  $default,){
final _that = this;
switch (_that) {
case _ActionReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int minute,  List<int> weekdays,  String? lastDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionReminder() when $default != null:
return $default(_that.hour,_that.minute,_that.weekdays,_that.lastDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int minute,  List<int> weekdays,  String? lastDay)  $default,) {final _that = this;
switch (_that) {
case _ActionReminder():
return $default(_that.hour,_that.minute,_that.weekdays,_that.lastDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int minute,  List<int> weekdays,  String? lastDay)?  $default,) {final _that = this;
switch (_that) {
case _ActionReminder() when $default != null:
return $default(_that.hour,_that.minute,_that.weekdays,_that.lastDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionReminder extends ActionReminder {
  const _ActionReminder({required this.hour, required this.minute, required  List<int> weekdays, this.lastDay}): _weekdays = weekdays,super._();
  factory _ActionReminder.fromJson(Map<String, dynamic> json) => _$ActionReminderFromJson(json);

@override final  int hour;
@override final  int minute;
/// [DateTime.weekday] values the reminder fires on.
 final  List<int> _weekdays;
/// [DateTime.weekday] values the reminder fires on.
@override List<int> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

/// Date key of the last reminder day; null repeats forever.
@override final  String? lastDay;

/// Create a copy of ActionReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionReminderCopyWith<_ActionReminder> get copyWith => __$ActionReminderCopyWithImpl<_ActionReminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionReminderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionReminder&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays)&&(identical(other.lastDay, lastDay) || other.lastDay == lastDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hour,minute,const DeepCollectionEquality().hash(_weekdays),lastDay);
}

@override
String toString() {
    return 'ActionReminder(hour: $hour, minute: $minute, weekdays: $weekdays, lastDay: $lastDay)';
}


}

/// @nodoc
abstract mixin class _$ActionReminderCopyWith<$Res> implements $ActionReminderCopyWith<$Res> {
  factory _$ActionReminderCopyWith(_ActionReminder value, $Res Function(_ActionReminder) _then) = __$ActionReminderCopyWithImpl;
@override @useResult
$Res call({
 int hour, int minute, List<int> weekdays, String? lastDay
});




}
/// @nodoc
class __$ActionReminderCopyWithImpl<$Res>
    implements _$ActionReminderCopyWith<$Res> {
  __$ActionReminderCopyWithImpl(this._self, this._then);

  final _ActionReminder _self;
  final $Res Function(_ActionReminder) _then;

/// Create a copy of ActionReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? minute = null,Object? weekdays = null,Object? lastDay = freezed,}) {
  return _then(_ActionReminder(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,lastDay: freezed == lastDay ? _self.lastDay : lastDay // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
