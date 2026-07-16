// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'co2_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Co2Stats {

 int get totalGrams; int get previousTotalGrams; double get percentChange; TimePeriod get period;
/// Create a copy of Co2Stats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Co2StatsCopyWith<Co2Stats> get copyWith => _$Co2StatsCopyWithImpl<Co2Stats>(this as Co2Stats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Co2Stats&&(identical(other.totalGrams, totalGrams) || other.totalGrams == totalGrams)&&(identical(other.previousTotalGrams, previousTotalGrams) || other.previousTotalGrams == previousTotalGrams)&&(identical(other.percentChange, percentChange) || other.percentChange == percentChange)&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,totalGrams,previousTotalGrams,percentChange,period);

@override
String toString() {
  return 'Co2Stats(totalGrams: $totalGrams, previousTotalGrams: $previousTotalGrams, percentChange: $percentChange, period: $period)';
}


}

/// @nodoc
abstract mixin class $Co2StatsCopyWith<$Res>  {
  factory $Co2StatsCopyWith(Co2Stats value, $Res Function(Co2Stats) _then) = _$Co2StatsCopyWithImpl;
@useResult
$Res call({
 int totalGrams, int previousTotalGrams, double percentChange, TimePeriod period
});




}
/// @nodoc
class _$Co2StatsCopyWithImpl<$Res>
    implements $Co2StatsCopyWith<$Res> {
  _$Co2StatsCopyWithImpl(this._self, this._then);

  final Co2Stats _self;
  final $Res Function(Co2Stats) _then;

/// Create a copy of Co2Stats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalGrams = null,Object? previousTotalGrams = null,Object? percentChange = null,Object? period = null,}) {
  return _then(_self.copyWith(
totalGrams: null == totalGrams ? _self.totalGrams : totalGrams // ignore: cast_nullable_to_non_nullable
as int,previousTotalGrams: null == previousTotalGrams ? _self.previousTotalGrams : previousTotalGrams // ignore: cast_nullable_to_non_nullable
as int,percentChange: null == percentChange ? _self.percentChange : percentChange // ignore: cast_nullable_to_non_nullable
as double,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as TimePeriod,
  ));
}

}


/// Adds pattern-matching-related methods to [Co2Stats].
extension Co2StatsPatterns on Co2Stats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Co2Stats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Co2Stats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Co2Stats value)  $default,){
final _that = this;
switch (_that) {
case _Co2Stats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Co2Stats value)?  $default,){
final _that = this;
switch (_that) {
case _Co2Stats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalGrams,  int previousTotalGrams,  double percentChange,  TimePeriod period)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Co2Stats() when $default != null:
return $default(_that.totalGrams,_that.previousTotalGrams,_that.percentChange,_that.period);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalGrams,  int previousTotalGrams,  double percentChange,  TimePeriod period)  $default,) {final _that = this;
switch (_that) {
case _Co2Stats():
return $default(_that.totalGrams,_that.previousTotalGrams,_that.percentChange,_that.period);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalGrams,  int previousTotalGrams,  double percentChange,  TimePeriod period)?  $default,) {final _that = this;
switch (_that) {
case _Co2Stats() when $default != null:
return $default(_that.totalGrams,_that.previousTotalGrams,_that.percentChange,_that.period);case _:
  return null;

}
}

}

/// @nodoc


class _Co2Stats extends Co2Stats {
  const _Co2Stats({required this.totalGrams, required this.previousTotalGrams, required this.percentChange, required this.period}): super._();
  

@override final  int totalGrams;
@override final  int previousTotalGrams;
@override final  double percentChange;
@override final  TimePeriod period;

/// Create a copy of Co2Stats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Co2StatsCopyWith<_Co2Stats> get copyWith => __$Co2StatsCopyWithImpl<_Co2Stats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Co2Stats&&(identical(other.totalGrams, totalGrams) || other.totalGrams == totalGrams)&&(identical(other.previousTotalGrams, previousTotalGrams) || other.previousTotalGrams == previousTotalGrams)&&(identical(other.percentChange, percentChange) || other.percentChange == percentChange)&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,totalGrams,previousTotalGrams,percentChange,period);

@override
String toString() {
  return 'Co2Stats(totalGrams: $totalGrams, previousTotalGrams: $previousTotalGrams, percentChange: $percentChange, period: $period)';
}


}

/// @nodoc
abstract mixin class _$Co2StatsCopyWith<$Res> implements $Co2StatsCopyWith<$Res> {
  factory _$Co2StatsCopyWith(_Co2Stats value, $Res Function(_Co2Stats) _then) = __$Co2StatsCopyWithImpl;
@override @useResult
$Res call({
 int totalGrams, int previousTotalGrams, double percentChange, TimePeriod period
});




}
/// @nodoc
class __$Co2StatsCopyWithImpl<$Res>
    implements _$Co2StatsCopyWith<$Res> {
  __$Co2StatsCopyWithImpl(this._self, this._then);

  final _Co2Stats _self;
  final $Res Function(_Co2Stats) _then;

/// Create a copy of Co2Stats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalGrams = null,Object? previousTotalGrams = null,Object? percentChange = null,Object? period = null,}) {
  return _then(_Co2Stats(
totalGrams: null == totalGrams ? _self.totalGrams : totalGrams // ignore: cast_nullable_to_non_nullable
as int,previousTotalGrams: null == previousTotalGrams ? _self.previousTotalGrams : previousTotalGrams // ignore: cast_nullable_to_non_nullable
as int,percentChange: null == percentChange ? _self.percentChange : percentChange // ignore: cast_nullable_to_non_nullable
as double,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as TimePeriod,
  ));
}


}

// dart format on
