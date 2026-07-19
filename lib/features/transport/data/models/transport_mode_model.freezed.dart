// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport_mode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransportMode {

 String get id; String get group; String get nameEn; String get nameJa; String get nameEs; double get gCo2ePerKm; bool get perVehicle; int get maxOccupants; String get calculationNotes; List<EmissionSource> get sources;
/// Create a copy of TransportMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransportModeCopyWith<TransportMode> get copyWith => _$TransportModeCopyWithImpl<TransportMode>(this as TransportMode, _$identity);

  /// Serializes this TransportMode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransportMode&&(identical(other.id, id) || other.id == id)&&(identical(other.group, group) || other.group == group)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.gCo2ePerKm, gCo2ePerKm) || other.gCo2ePerKm == gCo2ePerKm)&&(identical(other.perVehicle, perVehicle) || other.perVehicle == perVehicle)&&(identical(other.maxOccupants, maxOccupants) || other.maxOccupants == maxOccupants)&&(identical(other.calculationNotes, calculationNotes) || other.calculationNotes == calculationNotes)&&const DeepCollectionEquality().equals(other.sources, sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,group,nameEn,nameJa,nameEs,gCo2ePerKm,perVehicle,maxOccupants,calculationNotes,const DeepCollectionEquality().hash(sources));

@override
String toString() {
  return 'TransportMode(id: $id, group: $group, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, gCo2ePerKm: $gCo2ePerKm, perVehicle: $perVehicle, maxOccupants: $maxOccupants, calculationNotes: $calculationNotes, sources: $sources)';
}


}

/// @nodoc
abstract mixin class $TransportModeCopyWith<$Res>  {
  factory $TransportModeCopyWith(TransportMode value, $Res Function(TransportMode) _then) = _$TransportModeCopyWithImpl;
@useResult
$Res call({
 String id, String group, String nameEn, String nameJa, String nameEs, double gCo2ePerKm, bool perVehicle, int maxOccupants, String calculationNotes, List<EmissionSource> sources
});




}
/// @nodoc
class _$TransportModeCopyWithImpl<$Res>
    implements $TransportModeCopyWith<$Res> {
  _$TransportModeCopyWithImpl(this._self, this._then);

  final TransportMode _self;
  final $Res Function(TransportMode) _then;

/// Create a copy of TransportMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? group = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? gCo2ePerKm = null,Object? perVehicle = null,Object? maxOccupants = null,Object? calculationNotes = null,Object? sources = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,gCo2ePerKm: null == gCo2ePerKm ? _self.gCo2ePerKm : gCo2ePerKm // ignore: cast_nullable_to_non_nullable
as double,perVehicle: null == perVehicle ? _self.perVehicle : perVehicle // ignore: cast_nullable_to_non_nullable
as bool,maxOccupants: null == maxOccupants ? _self.maxOccupants : maxOccupants // ignore: cast_nullable_to_non_nullable
as int,calculationNotes: null == calculationNotes ? _self.calculationNotes : calculationNotes // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<EmissionSource>,
  ));
}

}


/// Adds pattern-matching-related methods to [TransportMode].
extension TransportModePatterns on TransportMode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransportMode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransportMode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransportMode value)  $default,){
final _that = this;
switch (_that) {
case _TransportMode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransportMode value)?  $default,){
final _that = this;
switch (_that) {
case _TransportMode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String group,  String nameEn,  String nameJa,  String nameEs,  double gCo2ePerKm,  bool perVehicle,  int maxOccupants,  String calculationNotes,  List<EmissionSource> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransportMode() when $default != null:
return $default(_that.id,_that.group,_that.nameEn,_that.nameJa,_that.nameEs,_that.gCo2ePerKm,_that.perVehicle,_that.maxOccupants,_that.calculationNotes,_that.sources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String group,  String nameEn,  String nameJa,  String nameEs,  double gCo2ePerKm,  bool perVehicle,  int maxOccupants,  String calculationNotes,  List<EmissionSource> sources)  $default,) {final _that = this;
switch (_that) {
case _TransportMode():
return $default(_that.id,_that.group,_that.nameEn,_that.nameJa,_that.nameEs,_that.gCo2ePerKm,_that.perVehicle,_that.maxOccupants,_that.calculationNotes,_that.sources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String group,  String nameEn,  String nameJa,  String nameEs,  double gCo2ePerKm,  bool perVehicle,  int maxOccupants,  String calculationNotes,  List<EmissionSource> sources)?  $default,) {final _that = this;
switch (_that) {
case _TransportMode() when $default != null:
return $default(_that.id,_that.group,_that.nameEn,_that.nameJa,_that.nameEs,_that.gCo2ePerKm,_that.perVehicle,_that.maxOccupants,_that.calculationNotes,_that.sources);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TransportMode extends TransportMode {
  const _TransportMode({required this.id, required this.group, required this.nameEn, required this.nameJa, required this.nameEs, required this.gCo2ePerKm, this.perVehicle = false, this.maxOccupants = 1, this.calculationNotes = '', final  List<EmissionSource> sources = const []}): _sources = sources,super._();
  factory _TransportMode.fromJson(Map<String, dynamic> json) => _$TransportModeFromJson(json);

@override final  String id;
@override final  String group;
@override final  String nameEn;
@override final  String nameJa;
@override final  String nameEs;
@override final  double gCo2ePerKm;
@override@JsonKey() final  bool perVehicle;
@override@JsonKey() final  int maxOccupants;
@override@JsonKey() final  String calculationNotes;
 final  List<EmissionSource> _sources;
@override@JsonKey() List<EmissionSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


/// Create a copy of TransportMode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransportModeCopyWith<_TransportMode> get copyWith => __$TransportModeCopyWithImpl<_TransportMode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransportModeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransportMode&&(identical(other.id, id) || other.id == id)&&(identical(other.group, group) || other.group == group)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.gCo2ePerKm, gCo2ePerKm) || other.gCo2ePerKm == gCo2ePerKm)&&(identical(other.perVehicle, perVehicle) || other.perVehicle == perVehicle)&&(identical(other.maxOccupants, maxOccupants) || other.maxOccupants == maxOccupants)&&(identical(other.calculationNotes, calculationNotes) || other.calculationNotes == calculationNotes)&&const DeepCollectionEquality().equals(other._sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,group,nameEn,nameJa,nameEs,gCo2ePerKm,perVehicle,maxOccupants,calculationNotes,const DeepCollectionEquality().hash(_sources));

@override
String toString() {
  return 'TransportMode(id: $id, group: $group, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, gCo2ePerKm: $gCo2ePerKm, perVehicle: $perVehicle, maxOccupants: $maxOccupants, calculationNotes: $calculationNotes, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$TransportModeCopyWith<$Res> implements $TransportModeCopyWith<$Res> {
  factory _$TransportModeCopyWith(_TransportMode value, $Res Function(_TransportMode) _then) = __$TransportModeCopyWithImpl;
@override @useResult
$Res call({
 String id, String group, String nameEn, String nameJa, String nameEs, double gCo2ePerKm, bool perVehicle, int maxOccupants, String calculationNotes, List<EmissionSource> sources
});




}
/// @nodoc
class __$TransportModeCopyWithImpl<$Res>
    implements _$TransportModeCopyWith<$Res> {
  __$TransportModeCopyWithImpl(this._self, this._then);

  final _TransportMode _self;
  final $Res Function(_TransportMode) _then;

/// Create a copy of TransportMode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? group = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? gCo2ePerKm = null,Object? perVehicle = null,Object? maxOccupants = null,Object? calculationNotes = null,Object? sources = null,}) {
  return _then(_TransportMode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,gCo2ePerKm: null == gCo2ePerKm ? _self.gCo2ePerKm : gCo2ePerKm // ignore: cast_nullable_to_non_nullable
as double,perVehicle: null == perVehicle ? _self.perVehicle : perVehicle // ignore: cast_nullable_to_non_nullable
as bool,maxOccupants: null == maxOccupants ? _self.maxOccupants : maxOccupants // ignore: cast_nullable_to_non_nullable
as int,calculationNotes: null == calculationNotes ? _self.calculationNotes : calculationNotes // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<EmissionSource>,
  ));
}


}

// dart format on
