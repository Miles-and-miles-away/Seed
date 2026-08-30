// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'energy_behavior_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnergyBehavior {

 String get id;/// The set this behavior may be compared within. Doubles as the
/// display grouping in the picker, because the comparability
/// groups are also the sensible headings (hot water, dishes,
/// laundry).
///
/// Allowlist semantics: a new behavior compares with nothing until
/// someone deliberately groups it. A blocklist would rot the first
/// time an entry was added.
 String get comparableGroup; EnergyCarrier get carrier; EnergyUnit get unit; double get kwhPerUnit; String get nameEn; String get nameJa; String get nameEs; List<UsagePreset> get presets; String get defaultPresetId; String get calculationNotes; List<EmissionSource> get sources;/// How well-sourced the factor is: `high`, `medium_high`, `medium`
/// or `low`, mirroring RESEARCH_ENERGY.md section 4.
///
/// Only `standby` is `low`, and it is the only entry that gets a
/// sublabel. An earlier draft of PDR rule 21 also demanded one on
/// the oven, on the premise that it had no tier-1 primary; the
/// research rates it `medium` on a tier-1 EU regulation, so the
/// rule was corrected rather than the data (owner call
/// 2026-08-29).
 String get confidence;
/// Create a copy of EnergyBehavior
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnergyBehaviorCopyWith<EnergyBehavior> get copyWith => _$EnergyBehaviorCopyWithImpl<EnergyBehavior>(this as EnergyBehavior, _$identity);

  /// Serializes this EnergyBehavior to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnergyBehavior&&(identical(other.id, id) || other.id == id)&&(identical(other.comparableGroup, comparableGroup) || other.comparableGroup == comparableGroup)&&(identical(other.carrier, carrier) || other.carrier == carrier)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.kwhPerUnit, kwhPerUnit) || other.kwhPerUnit == kwhPerUnit)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&const DeepCollectionEquality().equals(other.presets, presets)&&(identical(other.defaultPresetId, defaultPresetId) || other.defaultPresetId == defaultPresetId)&&(identical(other.calculationNotes, calculationNotes) || other.calculationNotes == calculationNotes)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,comparableGroup,carrier,unit,kwhPerUnit,nameEn,nameJa,nameEs,const DeepCollectionEquality().hash(presets),defaultPresetId,calculationNotes,const DeepCollectionEquality().hash(sources),confidence);

@override
String toString() {
  return 'EnergyBehavior(id: $id, comparableGroup: $comparableGroup, carrier: $carrier, unit: $unit, kwhPerUnit: $kwhPerUnit, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, presets: $presets, defaultPresetId: $defaultPresetId, calculationNotes: $calculationNotes, sources: $sources, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $EnergyBehaviorCopyWith<$Res>  {
  factory $EnergyBehaviorCopyWith(EnergyBehavior value, $Res Function(EnergyBehavior) _then) = _$EnergyBehaviorCopyWithImpl;
@useResult
$Res call({
 String id, String comparableGroup, EnergyCarrier carrier, EnergyUnit unit, double kwhPerUnit, String nameEn, String nameJa, String nameEs, List<UsagePreset> presets, String defaultPresetId, String calculationNotes, List<EmissionSource> sources, String confidence
});




}
/// @nodoc
class _$EnergyBehaviorCopyWithImpl<$Res>
    implements $EnergyBehaviorCopyWith<$Res> {
  _$EnergyBehaviorCopyWithImpl(this._self, this._then);

  final EnergyBehavior _self;
  final $Res Function(EnergyBehavior) _then;

/// Create a copy of EnergyBehavior
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? comparableGroup = null,Object? carrier = null,Object? unit = null,Object? kwhPerUnit = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? presets = null,Object? defaultPresetId = null,Object? calculationNotes = null,Object? sources = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,comparableGroup: null == comparableGroup ? _self.comparableGroup : comparableGroup // ignore: cast_nullable_to_non_nullable
as String,carrier: null == carrier ? _self.carrier : carrier // ignore: cast_nullable_to_non_nullable
as EnergyCarrier,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as EnergyUnit,kwhPerUnit: null == kwhPerUnit ? _self.kwhPerUnit : kwhPerUnit // ignore: cast_nullable_to_non_nullable
as double,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,presets: null == presets ? _self.presets : presets // ignore: cast_nullable_to_non_nullable
as List<UsagePreset>,defaultPresetId: null == defaultPresetId ? _self.defaultPresetId : defaultPresetId // ignore: cast_nullable_to_non_nullable
as String,calculationNotes: null == calculationNotes ? _self.calculationNotes : calculationNotes // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<EmissionSource>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EnergyBehavior].
extension EnergyBehaviorPatterns on EnergyBehavior {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnergyBehavior value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnergyBehavior() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnergyBehavior value)  $default,){
final _that = this;
switch (_that) {
case _EnergyBehavior():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnergyBehavior value)?  $default,){
final _that = this;
switch (_that) {
case _EnergyBehavior() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String comparableGroup,  EnergyCarrier carrier,  EnergyUnit unit,  double kwhPerUnit,  String nameEn,  String nameJa,  String nameEs,  List<UsagePreset> presets,  String defaultPresetId,  String calculationNotes,  List<EmissionSource> sources,  String confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnergyBehavior() when $default != null:
return $default(_that.id,_that.comparableGroup,_that.carrier,_that.unit,_that.kwhPerUnit,_that.nameEn,_that.nameJa,_that.nameEs,_that.presets,_that.defaultPresetId,_that.calculationNotes,_that.sources,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String comparableGroup,  EnergyCarrier carrier,  EnergyUnit unit,  double kwhPerUnit,  String nameEn,  String nameJa,  String nameEs,  List<UsagePreset> presets,  String defaultPresetId,  String calculationNotes,  List<EmissionSource> sources,  String confidence)  $default,) {final _that = this;
switch (_that) {
case _EnergyBehavior():
return $default(_that.id,_that.comparableGroup,_that.carrier,_that.unit,_that.kwhPerUnit,_that.nameEn,_that.nameJa,_that.nameEs,_that.presets,_that.defaultPresetId,_that.calculationNotes,_that.sources,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String comparableGroup,  EnergyCarrier carrier,  EnergyUnit unit,  double kwhPerUnit,  String nameEn,  String nameJa,  String nameEs,  List<UsagePreset> presets,  String defaultPresetId,  String calculationNotes,  List<EmissionSource> sources,  String confidence)?  $default,) {final _that = this;
switch (_that) {
case _EnergyBehavior() when $default != null:
return $default(_that.id,_that.comparableGroup,_that.carrier,_that.unit,_that.kwhPerUnit,_that.nameEn,_that.nameJa,_that.nameEs,_that.presets,_that.defaultPresetId,_that.calculationNotes,_that.sources,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _EnergyBehavior extends EnergyBehavior {
  const _EnergyBehavior({required this.id, required this.comparableGroup, required this.carrier, required this.unit, required this.kwhPerUnit, required this.nameEn, required this.nameJa, required this.nameEs, final  List<UsagePreset> presets = const [], this.defaultPresetId = '', this.calculationNotes = '', final  List<EmissionSource> sources = const [], this.confidence = 'medium'}): _presets = presets,_sources = sources,super._();
  factory _EnergyBehavior.fromJson(Map<String, dynamic> json) => _$EnergyBehaviorFromJson(json);

@override final  String id;
/// The set this behavior may be compared within. Doubles as the
/// display grouping in the picker, because the comparability
/// groups are also the sensible headings (hot water, dishes,
/// laundry).
///
/// Allowlist semantics: a new behavior compares with nothing until
/// someone deliberately groups it. A blocklist would rot the first
/// time an entry was added.
@override final  String comparableGroup;
@override final  EnergyCarrier carrier;
@override final  EnergyUnit unit;
@override final  double kwhPerUnit;
@override final  String nameEn;
@override final  String nameJa;
@override final  String nameEs;
 final  List<UsagePreset> _presets;
@override@JsonKey() List<UsagePreset> get presets {
  if (_presets is EqualUnmodifiableListView) return _presets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_presets);
}

@override@JsonKey() final  String defaultPresetId;
@override@JsonKey() final  String calculationNotes;
 final  List<EmissionSource> _sources;
@override@JsonKey() List<EmissionSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

/// How well-sourced the factor is: `high`, `medium_high`, `medium`
/// or `low`, mirroring RESEARCH_ENERGY.md section 4.
///
/// Only `standby` is `low`, and it is the only entry that gets a
/// sublabel. An earlier draft of PDR rule 21 also demanded one on
/// the oven, on the premise that it had no tier-1 primary; the
/// research rates it `medium` on a tier-1 EU regulation, so the
/// rule was corrected rather than the data (owner call
/// 2026-08-29).
@override@JsonKey() final  String confidence;

/// Create a copy of EnergyBehavior
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnergyBehaviorCopyWith<_EnergyBehavior> get copyWith => __$EnergyBehaviorCopyWithImpl<_EnergyBehavior>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnergyBehaviorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnergyBehavior&&(identical(other.id, id) || other.id == id)&&(identical(other.comparableGroup, comparableGroup) || other.comparableGroup == comparableGroup)&&(identical(other.carrier, carrier) || other.carrier == carrier)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.kwhPerUnit, kwhPerUnit) || other.kwhPerUnit == kwhPerUnit)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&const DeepCollectionEquality().equals(other._presets, _presets)&&(identical(other.defaultPresetId, defaultPresetId) || other.defaultPresetId == defaultPresetId)&&(identical(other.calculationNotes, calculationNotes) || other.calculationNotes == calculationNotes)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,comparableGroup,carrier,unit,kwhPerUnit,nameEn,nameJa,nameEs,const DeepCollectionEquality().hash(_presets),defaultPresetId,calculationNotes,const DeepCollectionEquality().hash(_sources),confidence);

@override
String toString() {
  return 'EnergyBehavior(id: $id, comparableGroup: $comparableGroup, carrier: $carrier, unit: $unit, kwhPerUnit: $kwhPerUnit, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, presets: $presets, defaultPresetId: $defaultPresetId, calculationNotes: $calculationNotes, sources: $sources, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$EnergyBehaviorCopyWith<$Res> implements $EnergyBehaviorCopyWith<$Res> {
  factory _$EnergyBehaviorCopyWith(_EnergyBehavior value, $Res Function(_EnergyBehavior) _then) = __$EnergyBehaviorCopyWithImpl;
@override @useResult
$Res call({
 String id, String comparableGroup, EnergyCarrier carrier, EnergyUnit unit, double kwhPerUnit, String nameEn, String nameJa, String nameEs, List<UsagePreset> presets, String defaultPresetId, String calculationNotes, List<EmissionSource> sources, String confidence
});




}
/// @nodoc
class __$EnergyBehaviorCopyWithImpl<$Res>
    implements _$EnergyBehaviorCopyWith<$Res> {
  __$EnergyBehaviorCopyWithImpl(this._self, this._then);

  final _EnergyBehavior _self;
  final $Res Function(_EnergyBehavior) _then;

/// Create a copy of EnergyBehavior
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? comparableGroup = null,Object? carrier = null,Object? unit = null,Object? kwhPerUnit = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? presets = null,Object? defaultPresetId = null,Object? calculationNotes = null,Object? sources = null,Object? confidence = null,}) {
  return _then(_EnergyBehavior(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,comparableGroup: null == comparableGroup ? _self.comparableGroup : comparableGroup // ignore: cast_nullable_to_non_nullable
as String,carrier: null == carrier ? _self.carrier : carrier // ignore: cast_nullable_to_non_nullable
as EnergyCarrier,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as EnergyUnit,kwhPerUnit: null == kwhPerUnit ? _self.kwhPerUnit : kwhPerUnit // ignore: cast_nullable_to_non_nullable
as double,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,presets: null == presets ? _self._presets : presets // ignore: cast_nullable_to_non_nullable
as List<UsagePreset>,defaultPresetId: null == defaultPresetId ? _self.defaultPresetId : defaultPresetId // ignore: cast_nullable_to_non_nullable
as String,calculationNotes: null == calculationNotes ? _self.calculationNotes : calculationNotes // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<EmissionSource>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
