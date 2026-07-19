// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_leg_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JourneyLeg {

 String get modeId; double get distanceKm; int get occupants;
/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyLegCopyWith<JourneyLeg> get copyWith => _$JourneyLegCopyWithImpl<JourneyLeg>(this as JourneyLeg, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyLeg&&(identical(other.modeId, modeId) || other.modeId == modeId)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.occupants, occupants) || other.occupants == occupants));
}


@override
int get hashCode => Object.hash(runtimeType,modeId,distanceKm,occupants);

@override
String toString() {
  return 'JourneyLeg(modeId: $modeId, distanceKm: $distanceKm, occupants: $occupants)';
}


}

/// @nodoc
abstract mixin class $JourneyLegCopyWith<$Res>  {
  factory $JourneyLegCopyWith(JourneyLeg value, $Res Function(JourneyLeg) _then) = _$JourneyLegCopyWithImpl;
@useResult
$Res call({
 String modeId, double distanceKm, int occupants
});




}
/// @nodoc
class _$JourneyLegCopyWithImpl<$Res>
    implements $JourneyLegCopyWith<$Res> {
  _$JourneyLegCopyWithImpl(this._self, this._then);

  final JourneyLeg _self;
  final $Res Function(JourneyLeg) _then;

/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modeId = null,Object? distanceKm = null,Object? occupants = null,}) {
  return _then(_self.copyWith(
modeId: null == modeId ? _self.modeId : modeId // ignore: cast_nullable_to_non_nullable
as String,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,occupants: null == occupants ? _self.occupants : occupants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JourneyLeg].
extension JourneyLegPatterns on JourneyLeg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyLeg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyLeg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyLeg value)  $default,){
final _that = this;
switch (_that) {
case _JourneyLeg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyLeg value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyLeg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String modeId,  double distanceKm,  int occupants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyLeg() when $default != null:
return $default(_that.modeId,_that.distanceKm,_that.occupants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String modeId,  double distanceKm,  int occupants)  $default,) {final _that = this;
switch (_that) {
case _JourneyLeg():
return $default(_that.modeId,_that.distanceKm,_that.occupants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String modeId,  double distanceKm,  int occupants)?  $default,) {final _that = this;
switch (_that) {
case _JourneyLeg() when $default != null:
return $default(_that.modeId,_that.distanceKm,_that.occupants);case _:
  return null;

}
}

}

/// @nodoc


class _JourneyLeg implements JourneyLeg {
  const _JourneyLeg({required this.modeId, required this.distanceKm, this.occupants = 1});
  

@override final  String modeId;
@override final  double distanceKm;
@override@JsonKey() final  int occupants;

/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyLegCopyWith<_JourneyLeg> get copyWith => __$JourneyLegCopyWithImpl<_JourneyLeg>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyLeg&&(identical(other.modeId, modeId) || other.modeId == modeId)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.occupants, occupants) || other.occupants == occupants));
}


@override
int get hashCode => Object.hash(runtimeType,modeId,distanceKm,occupants);

@override
String toString() {
  return 'JourneyLeg(modeId: $modeId, distanceKm: $distanceKm, occupants: $occupants)';
}


}

/// @nodoc
abstract mixin class _$JourneyLegCopyWith<$Res> implements $JourneyLegCopyWith<$Res> {
  factory _$JourneyLegCopyWith(_JourneyLeg value, $Res Function(_JourneyLeg) _then) = __$JourneyLegCopyWithImpl;
@override @useResult
$Res call({
 String modeId, double distanceKm, int occupants
});




}
/// @nodoc
class __$JourneyLegCopyWithImpl<$Res>
    implements _$JourneyLegCopyWith<$Res> {
  __$JourneyLegCopyWithImpl(this._self, this._then);

  final _JourneyLeg _self;
  final $Res Function(_JourneyLeg) _then;

/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modeId = null,Object? distanceKm = null,Object? occupants = null,}) {
  return _then(_JourneyLeg(
modeId: null == modeId ? _self.modeId : modeId // ignore: cast_nullable_to_non_nullable
as String,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,occupants: null == occupants ? _self.occupants : occupants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
