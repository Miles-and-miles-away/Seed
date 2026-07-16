// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evolution_stage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EvolutionStageModel {

/// The level threshold required to reach this stage.
 int get level;/// The local asset path to the mascot image for this stage.
 String get assetPath;/// The English name of this evolution stage.
 String get nameEn;/// The Japanese name of this evolution stage.
 String get nameJa;/// The Rive artboard to render for this stage, for `.riv` assets
/// containing multiple stage artboards (e.g. coral_mascot.riv).
/// Null falls back to the file's default artboard. Must match the
/// editor artboard name exactly (case-sensitive).
 String? get artboardName;/// The Spanish name of this evolution stage.
 String get nameEs;
/// Create a copy of EvolutionStageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvolutionStageModelCopyWith<EvolutionStageModel> get copyWith => _$EvolutionStageModelCopyWithImpl<EvolutionStageModel>(this as EvolutionStageModel, _$identity);

  /// Serializes this EvolutionStageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvolutionStageModel&&(identical(other.level, level) || other.level == level)&&(identical(other.assetPath, assetPath) || other.assetPath == assetPath)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.artboardName, artboardName) || other.artboardName == artboardName)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,assetPath,nameEn,nameJa,artboardName,nameEs);

@override
String toString() {
  return 'EvolutionStageModel(level: $level, assetPath: $assetPath, nameEn: $nameEn, nameJa: $nameJa, artboardName: $artboardName, nameEs: $nameEs)';
}


}

/// @nodoc
abstract mixin class $EvolutionStageModelCopyWith<$Res>  {
  factory $EvolutionStageModelCopyWith(EvolutionStageModel value, $Res Function(EvolutionStageModel) _then) = _$EvolutionStageModelCopyWithImpl;
@useResult
$Res call({
 int level, String assetPath, String nameEn, String nameJa, String? artboardName, String nameEs
});




}
/// @nodoc
class _$EvolutionStageModelCopyWithImpl<$Res>
    implements $EvolutionStageModelCopyWith<$Res> {
  _$EvolutionStageModelCopyWithImpl(this._self, this._then);

  final EvolutionStageModel _self;
  final $Res Function(EvolutionStageModel) _then;

/// Create a copy of EvolutionStageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? assetPath = null,Object? nameEn = null,Object? nameJa = null,Object? artboardName = freezed,Object? nameEs = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,assetPath: null == assetPath ? _self.assetPath : assetPath // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,artboardName: freezed == artboardName ? _self.artboardName : artboardName // ignore: cast_nullable_to_non_nullable
as String?,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EvolutionStageModel].
extension EvolutionStageModelPatterns on EvolutionStageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvolutionStageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvolutionStageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvolutionStageModel value)  $default,){
final _that = this;
switch (_that) {
case _EvolutionStageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvolutionStageModel value)?  $default,){
final _that = this;
switch (_that) {
case _EvolutionStageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  String assetPath,  String nameEn,  String nameJa,  String? artboardName,  String nameEs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvolutionStageModel() when $default != null:
return $default(_that.level,_that.assetPath,_that.nameEn,_that.nameJa,_that.artboardName,_that.nameEs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  String assetPath,  String nameEn,  String nameJa,  String? artboardName,  String nameEs)  $default,) {final _that = this;
switch (_that) {
case _EvolutionStageModel():
return $default(_that.level,_that.assetPath,_that.nameEn,_that.nameJa,_that.artboardName,_that.nameEs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  String assetPath,  String nameEn,  String nameJa,  String? artboardName,  String nameEs)?  $default,) {final _that = this;
switch (_that) {
case _EvolutionStageModel() when $default != null:
return $default(_that.level,_that.assetPath,_that.nameEn,_that.nameJa,_that.artboardName,_that.nameEs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EvolutionStageModel implements EvolutionStageModel {
  const _EvolutionStageModel({required this.level, required this.assetPath, required this.nameEn, required this.nameJa, this.artboardName, this.nameEs = ''});
  factory _EvolutionStageModel.fromJson(Map<String, dynamic> json) => _$EvolutionStageModelFromJson(json);

/// The level threshold required to reach this stage.
@override final  int level;
/// The local asset path to the mascot image for this stage.
@override final  String assetPath;
/// The English name of this evolution stage.
@override final  String nameEn;
/// The Japanese name of this evolution stage.
@override final  String nameJa;
/// The Rive artboard to render for this stage, for `.riv` assets
/// containing multiple stage artboards (e.g. coral_mascot.riv).
/// Null falls back to the file's default artboard. Must match the
/// editor artboard name exactly (case-sensitive).
@override final  String? artboardName;
/// The Spanish name of this evolution stage.
@override@JsonKey() final  String nameEs;

/// Create a copy of EvolutionStageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvolutionStageModelCopyWith<_EvolutionStageModel> get copyWith => __$EvolutionStageModelCopyWithImpl<_EvolutionStageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EvolutionStageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvolutionStageModel&&(identical(other.level, level) || other.level == level)&&(identical(other.assetPath, assetPath) || other.assetPath == assetPath)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.artboardName, artboardName) || other.artboardName == artboardName)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,assetPath,nameEn,nameJa,artboardName,nameEs);

@override
String toString() {
  return 'EvolutionStageModel(level: $level, assetPath: $assetPath, nameEn: $nameEn, nameJa: $nameJa, artboardName: $artboardName, nameEs: $nameEs)';
}


}

/// @nodoc
abstract mixin class _$EvolutionStageModelCopyWith<$Res> implements $EvolutionStageModelCopyWith<$Res> {
  factory _$EvolutionStageModelCopyWith(_EvolutionStageModel value, $Res Function(_EvolutionStageModel) _then) = __$EvolutionStageModelCopyWithImpl;
@override @useResult
$Res call({
 int level, String assetPath, String nameEn, String nameJa, String? artboardName, String nameEs
});




}
/// @nodoc
class __$EvolutionStageModelCopyWithImpl<$Res>
    implements _$EvolutionStageModelCopyWith<$Res> {
  __$EvolutionStageModelCopyWithImpl(this._self, this._then);

  final _EvolutionStageModel _self;
  final $Res Function(_EvolutionStageModel) _then;

/// Create a copy of EvolutionStageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? assetPath = null,Object? nameEn = null,Object? nameJa = null,Object? artboardName = freezed,Object? nameEs = null,}) {
  return _then(_EvolutionStageModel(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,assetPath: null == assetPath ? _self.assetPath : assetPath // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,artboardName: freezed == artboardName ? _self.artboardName : artboardName // ignore: cast_nullable_to_non_nullable
as String?,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
