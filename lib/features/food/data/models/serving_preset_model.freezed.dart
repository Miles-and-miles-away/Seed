// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'serving_preset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServingPreset {

 String get id; String get nameEn; String get nameJa; String get nameEs; double get grams;
/// Create a copy of ServingPreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServingPresetCopyWith<ServingPreset> get copyWith => _$ServingPresetCopyWithImpl<ServingPreset>(this as ServingPreset, _$identity);

  /// Serializes this ServingPreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServingPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.grams, grams) || other.grams == grams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameJa,nameEs,grams);

@override
String toString() {
  return 'ServingPreset(id: $id, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, grams: $grams)';
}


}

/// @nodoc
abstract mixin class $ServingPresetCopyWith<$Res>  {
  factory $ServingPresetCopyWith(ServingPreset value, $Res Function(ServingPreset) _then) = _$ServingPresetCopyWithImpl;
@useResult
$Res call({
 String id, String nameEn, String nameJa, String nameEs, double grams
});




}
/// @nodoc
class _$ServingPresetCopyWithImpl<$Res>
    implements $ServingPresetCopyWith<$Res> {
  _$ServingPresetCopyWithImpl(this._self, this._then);

  final ServingPreset _self;
  final $Res Function(ServingPreset) _then;

/// Create a copy of ServingPreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? grams = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ServingPreset].
extension ServingPresetPatterns on ServingPreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServingPreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServingPreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServingPreset value)  $default,){
final _that = this;
switch (_that) {
case _ServingPreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServingPreset value)?  $default,){
final _that = this;
switch (_that) {
case _ServingPreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nameEn,  String nameJa,  String nameEs,  double grams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServingPreset() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameJa,_that.nameEs,_that.grams);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nameEn,  String nameJa,  String nameEs,  double grams)  $default,) {final _that = this;
switch (_that) {
case _ServingPreset():
return $default(_that.id,_that.nameEn,_that.nameJa,_that.nameEs,_that.grams);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nameEn,  String nameJa,  String nameEs,  double grams)?  $default,) {final _that = this;
switch (_that) {
case _ServingPreset() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameJa,_that.nameEs,_that.grams);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ServingPreset extends ServingPreset {
  const _ServingPreset({required this.id, required this.nameEn, required this.nameJa, required this.nameEs, required this.grams}): super._();
  factory _ServingPreset.fromJson(Map<String, dynamic> json) => _$ServingPresetFromJson(json);

@override final  String id;
@override final  String nameEn;
@override final  String nameJa;
@override final  String nameEs;
@override final  double grams;

/// Create a copy of ServingPreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServingPresetCopyWith<_ServingPreset> get copyWith => __$ServingPresetCopyWithImpl<_ServingPreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServingPresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServingPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.grams, grams) || other.grams == grams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameJa,nameEs,grams);

@override
String toString() {
  return 'ServingPreset(id: $id, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, grams: $grams)';
}


}

/// @nodoc
abstract mixin class _$ServingPresetCopyWith<$Res> implements $ServingPresetCopyWith<$Res> {
  factory _$ServingPresetCopyWith(_ServingPreset value, $Res Function(_ServingPreset) _then) = __$ServingPresetCopyWithImpl;
@override @useResult
$Res call({
 String id, String nameEn, String nameJa, String nameEs, double grams
});




}
/// @nodoc
class __$ServingPresetCopyWithImpl<$Res>
    implements _$ServingPresetCopyWith<$Res> {
  __$ServingPresetCopyWithImpl(this._self, this._then);

  final _ServingPreset _self;
  final $Res Function(_ServingPreset) _then;

/// Create a copy of ServingPreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? grams = null,}) {
  return _then(_ServingPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
