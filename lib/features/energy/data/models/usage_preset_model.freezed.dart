// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usage_preset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsagePreset {

 String get id; String get nameEn; String get nameJa; String get nameEs; double get units;
/// Create a copy of UsagePreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsagePresetCopyWith<UsagePreset> get copyWith => _$UsagePresetCopyWithImpl<UsagePreset>(this as UsagePreset, _$identity);

  /// Serializes this UsagePreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsagePreset&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.units, units) || other.units == units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameJa,nameEs,units);

@override
String toString() {
  return 'UsagePreset(id: $id, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, units: $units)';
}


}

/// @nodoc
abstract mixin class $UsagePresetCopyWith<$Res>  {
  factory $UsagePresetCopyWith(UsagePreset value, $Res Function(UsagePreset) _then) = _$UsagePresetCopyWithImpl;
@useResult
$Res call({
 String id, String nameEn, String nameJa, String nameEs, double units
});




}
/// @nodoc
class _$UsagePresetCopyWithImpl<$Res>
    implements $UsagePresetCopyWith<$Res> {
  _$UsagePresetCopyWithImpl(this._self, this._then);

  final UsagePreset _self;
  final $Res Function(UsagePreset) _then;

/// Create a copy of UsagePreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? units = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [UsagePreset].
extension UsagePresetPatterns on UsagePreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsagePreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsagePreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsagePreset value)  $default,){
final _that = this;
switch (_that) {
case _UsagePreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsagePreset value)?  $default,){
final _that = this;
switch (_that) {
case _UsagePreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nameEn,  String nameJa,  String nameEs,  double units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsagePreset() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameJa,_that.nameEs,_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nameEn,  String nameJa,  String nameEs,  double units)  $default,) {final _that = this;
switch (_that) {
case _UsagePreset():
return $default(_that.id,_that.nameEn,_that.nameJa,_that.nameEs,_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nameEn,  String nameJa,  String nameEs,  double units)?  $default,) {final _that = this;
switch (_that) {
case _UsagePreset() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameJa,_that.nameEs,_that.units);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UsagePreset extends UsagePreset {
  const _UsagePreset({required this.id, required this.nameEn, required this.nameJa, required this.nameEs, required this.units}): super._();
  factory _UsagePreset.fromJson(Map<String, dynamic> json) => _$UsagePresetFromJson(json);

@override final  String id;
@override final  String nameEn;
@override final  String nameJa;
@override final  String nameEs;
@override final  double units;

/// Create a copy of UsagePreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsagePresetCopyWith<_UsagePreset> get copyWith => __$UsagePresetCopyWithImpl<_UsagePreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsagePresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsagePreset&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.units, units) || other.units == units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameJa,nameEs,units);

@override
String toString() {
  return 'UsagePreset(id: $id, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, units: $units)';
}


}

/// @nodoc
abstract mixin class _$UsagePresetCopyWith<$Res> implements $UsagePresetCopyWith<$Res> {
  factory _$UsagePresetCopyWith(_UsagePreset value, $Res Function(_UsagePreset) _then) = __$UsagePresetCopyWithImpl;
@override @useResult
$Res call({
 String id, String nameEn, String nameJa, String nameEs, double units
});




}
/// @nodoc
class __$UsagePresetCopyWithImpl<$Res>
    implements _$UsagePresetCopyWith<$Res> {
  __$UsagePresetCopyWithImpl(this._self, this._then);

  final _UsagePreset _self;
  final $Res Function(_UsagePreset) _then;

/// Create a copy of UsagePreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? units = null,}) {
  return _then(_UsagePreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
