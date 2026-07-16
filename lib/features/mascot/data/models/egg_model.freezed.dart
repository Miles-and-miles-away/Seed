// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'egg_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EggModel {

/// When the egg was received.
@RequiredTimestampConverter() DateTime get receivedAt;/// Consecutive days of activity since egg receipt.
 int get hatchingStreakDays;/// Date of last activity that counted toward hatching.
@TimestampConverter() DateTime? get lastHatchingActivityDate;
/// Create a copy of EggModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EggModelCopyWith<EggModel> get copyWith => _$EggModelCopyWithImpl<EggModel>(this as EggModel, _$identity);

  /// Serializes this EggModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EggModel&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.hatchingStreakDays, hatchingStreakDays) || other.hatchingStreakDays == hatchingStreakDays)&&(identical(other.lastHatchingActivityDate, lastHatchingActivityDate) || other.lastHatchingActivityDate == lastHatchingActivityDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,receivedAt,hatchingStreakDays,lastHatchingActivityDate);

@override
String toString() {
  return 'EggModel(receivedAt: $receivedAt, hatchingStreakDays: $hatchingStreakDays, lastHatchingActivityDate: $lastHatchingActivityDate)';
}


}

/// @nodoc
abstract mixin class $EggModelCopyWith<$Res>  {
  factory $EggModelCopyWith(EggModel value, $Res Function(EggModel) _then) = _$EggModelCopyWithImpl;
@useResult
$Res call({
@RequiredTimestampConverter() DateTime receivedAt, int hatchingStreakDays,@TimestampConverter() DateTime? lastHatchingActivityDate
});




}
/// @nodoc
class _$EggModelCopyWithImpl<$Res>
    implements $EggModelCopyWith<$Res> {
  _$EggModelCopyWithImpl(this._self, this._then);

  final EggModel _self;
  final $Res Function(EggModel) _then;

/// Create a copy of EggModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? receivedAt = null,Object? hatchingStreakDays = null,Object? lastHatchingActivityDate = freezed,}) {
  return _then(_self.copyWith(
receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,hatchingStreakDays: null == hatchingStreakDays ? _self.hatchingStreakDays : hatchingStreakDays // ignore: cast_nullable_to_non_nullable
as int,lastHatchingActivityDate: freezed == lastHatchingActivityDate ? _self.lastHatchingActivityDate : lastHatchingActivityDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EggModel].
extension EggModelPatterns on EggModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EggModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EggModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EggModel value)  $default,){
final _that = this;
switch (_that) {
case _EggModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EggModel value)?  $default,){
final _that = this;
switch (_that) {
case _EggModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@RequiredTimestampConverter()  DateTime receivedAt,  int hatchingStreakDays, @TimestampConverter()  DateTime? lastHatchingActivityDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EggModel() when $default != null:
return $default(_that.receivedAt,_that.hatchingStreakDays,_that.lastHatchingActivityDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@RequiredTimestampConverter()  DateTime receivedAt,  int hatchingStreakDays, @TimestampConverter()  DateTime? lastHatchingActivityDate)  $default,) {final _that = this;
switch (_that) {
case _EggModel():
return $default(_that.receivedAt,_that.hatchingStreakDays,_that.lastHatchingActivityDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@RequiredTimestampConverter()  DateTime receivedAt,  int hatchingStreakDays, @TimestampConverter()  DateTime? lastHatchingActivityDate)?  $default,) {final _that = this;
switch (_that) {
case _EggModel() when $default != null:
return $default(_that.receivedAt,_that.hatchingStreakDays,_that.lastHatchingActivityDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EggModel implements EggModel {
  const _EggModel({@RequiredTimestampConverter() required this.receivedAt, this.hatchingStreakDays = 0, @TimestampConverter() this.lastHatchingActivityDate});
  factory _EggModel.fromJson(Map<String, dynamic> json) => _$EggModelFromJson(json);

/// When the egg was received.
@override@RequiredTimestampConverter() final  DateTime receivedAt;
/// Consecutive days of activity since egg receipt.
@override@JsonKey() final  int hatchingStreakDays;
/// Date of last activity that counted toward hatching.
@override@TimestampConverter() final  DateTime? lastHatchingActivityDate;

/// Create a copy of EggModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EggModelCopyWith<_EggModel> get copyWith => __$EggModelCopyWithImpl<_EggModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EggModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EggModel&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.hatchingStreakDays, hatchingStreakDays) || other.hatchingStreakDays == hatchingStreakDays)&&(identical(other.lastHatchingActivityDate, lastHatchingActivityDate) || other.lastHatchingActivityDate == lastHatchingActivityDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,receivedAt,hatchingStreakDays,lastHatchingActivityDate);

@override
String toString() {
  return 'EggModel(receivedAt: $receivedAt, hatchingStreakDays: $hatchingStreakDays, lastHatchingActivityDate: $lastHatchingActivityDate)';
}


}

/// @nodoc
abstract mixin class _$EggModelCopyWith<$Res> implements $EggModelCopyWith<$Res> {
  factory _$EggModelCopyWith(_EggModel value, $Res Function(_EggModel) _then) = __$EggModelCopyWithImpl;
@override @useResult
$Res call({
@RequiredTimestampConverter() DateTime receivedAt, int hatchingStreakDays,@TimestampConverter() DateTime? lastHatchingActivityDate
});




}
/// @nodoc
class __$EggModelCopyWithImpl<$Res>
    implements _$EggModelCopyWith<$Res> {
  __$EggModelCopyWithImpl(this._self, this._then);

  final _EggModel _self;
  final $Res Function(_EggModel) _then;

/// Create a copy of EggModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receivedAt = null,Object? hatchingStreakDays = null,Object? lastHatchingActivityDate = freezed,}) {
  return _then(_EggModel(
receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,hatchingStreakDays: null == hatchingStreakDays ? _self.hatchingStreakDays : hatchingStreakDays // ignore: cast_nullable_to_non_nullable
as int,lastHatchingActivityDate: freezed == lastHatchingActivityDate ? _self.lastHatchingActivityDate : lastHatchingActivityDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
