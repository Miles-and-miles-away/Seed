// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_usage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoutineUsage {

 String get behaviorId; double get units;
/// Create a copy of RoutineUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineUsageCopyWith<RoutineUsage> get copyWith => _$RoutineUsageCopyWithImpl<RoutineUsage>(this as RoutineUsage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineUsage&&(identical(other.behaviorId, behaviorId) || other.behaviorId == behaviorId)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode => Object.hash(runtimeType,behaviorId,units);

@override
String toString() {
  return 'RoutineUsage(behaviorId: $behaviorId, units: $units)';
}


}

/// @nodoc
abstract mixin class $RoutineUsageCopyWith<$Res>  {
  factory $RoutineUsageCopyWith(RoutineUsage value, $Res Function(RoutineUsage) _then) = _$RoutineUsageCopyWithImpl;
@useResult
$Res call({
 String behaviorId, double units
});




}
/// @nodoc
class _$RoutineUsageCopyWithImpl<$Res>
    implements $RoutineUsageCopyWith<$Res> {
  _$RoutineUsageCopyWithImpl(this._self, this._then);

  final RoutineUsage _self;
  final $Res Function(RoutineUsage) _then;

/// Create a copy of RoutineUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? behaviorId = null,Object? units = null,}) {
  return _then(_self.copyWith(
behaviorId: null == behaviorId ? _self.behaviorId : behaviorId // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutineUsage].
extension RoutineUsagePatterns on RoutineUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineUsage value)  $default,){
final _that = this;
switch (_that) {
case _RoutineUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineUsage value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String behaviorId,  double units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineUsage() when $default != null:
return $default(_that.behaviorId,_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String behaviorId,  double units)  $default,) {final _that = this;
switch (_that) {
case _RoutineUsage():
return $default(_that.behaviorId,_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String behaviorId,  double units)?  $default,) {final _that = this;
switch (_that) {
case _RoutineUsage() when $default != null:
return $default(_that.behaviorId,_that.units);case _:
  return null;

}
}

}

/// @nodoc


class _RoutineUsage implements RoutineUsage {
  const _RoutineUsage({required this.behaviorId, required this.units});
  

@override final  String behaviorId;
@override final  double units;

/// Create a copy of RoutineUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineUsageCopyWith<_RoutineUsage> get copyWith => __$RoutineUsageCopyWithImpl<_RoutineUsage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineUsage&&(identical(other.behaviorId, behaviorId) || other.behaviorId == behaviorId)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode => Object.hash(runtimeType,behaviorId,units);

@override
String toString() {
  return 'RoutineUsage(behaviorId: $behaviorId, units: $units)';
}


}

/// @nodoc
abstract mixin class _$RoutineUsageCopyWith<$Res> implements $RoutineUsageCopyWith<$Res> {
  factory _$RoutineUsageCopyWith(_RoutineUsage value, $Res Function(_RoutineUsage) _then) = __$RoutineUsageCopyWithImpl;
@override @useResult
$Res call({
 String behaviorId, double units
});




}
/// @nodoc
class __$RoutineUsageCopyWithImpl<$Res>
    implements _$RoutineUsageCopyWith<$Res> {
  __$RoutineUsageCopyWithImpl(this._self, this._then);

  final _RoutineUsage _self;
  final $Res Function(_RoutineUsage) _then;

/// Create a copy of RoutineUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? behaviorId = null,Object? units = null,}) {
  return _then(_RoutineUsage(
behaviorId: null == behaviorId ? _self.behaviorId : behaviorId // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
