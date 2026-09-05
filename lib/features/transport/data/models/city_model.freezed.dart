// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'city_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$City {

 String get name; String get cc; double get lat; double get lon; String get mass; int get pop; String? get nameJa; String? get nameEs;
/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityCopyWith<City> get copyWith => _$CityCopyWithImpl<City>(this as City, _$identity);

  /// Serializes this City to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is City&&(identical(other.name, name) || other.name == name)&&(identical(other.cc, cc) || other.cc == cc)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.mass, mass) || other.mass == mass)&&(identical(other.pop, pop) || other.pop == pop)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,cc,lat,lon,mass,pop,nameJa,nameEs);

@override
String toString() {
  return 'City(name: $name, cc: $cc, lat: $lat, lon: $lon, mass: $mass, pop: $pop, nameJa: $nameJa, nameEs: $nameEs)';
}


}

/// @nodoc
abstract mixin class $CityCopyWith<$Res>  {
  factory $CityCopyWith(City value, $Res Function(City) _then) = _$CityCopyWithImpl;
@useResult
$Res call({
 String name, String cc, double lat, double lon, String mass, int pop, String? nameJa, String? nameEs
});




}
/// @nodoc
class _$CityCopyWithImpl<$Res>
    implements $CityCopyWith<$Res> {
  _$CityCopyWithImpl(this._self, this._then);

  final City _self;
  final $Res Function(City) _then;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? cc = null,Object? lat = null,Object? lon = null,Object? mass = null,Object? pop = null,Object? nameJa = freezed,Object? nameEs = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cc: null == cc ? _self.cc : cc // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,mass: null == mass ? _self.mass : mass // ignore: cast_nullable_to_non_nullable
as String,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as int,nameJa: freezed == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String?,nameEs: freezed == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [City].
extension CityPatterns on City {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _City value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _City() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _City value)  $default,){
final _that = this;
switch (_that) {
case _City():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _City value)?  $default,){
final _that = this;
switch (_that) {
case _City() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String cc,  double lat,  double lon,  String mass,  int pop,  String? nameJa,  String? nameEs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _City() when $default != null:
return $default(_that.name,_that.cc,_that.lat,_that.lon,_that.mass,_that.pop,_that.nameJa,_that.nameEs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String cc,  double lat,  double lon,  String mass,  int pop,  String? nameJa,  String? nameEs)  $default,) {final _that = this;
switch (_that) {
case _City():
return $default(_that.name,_that.cc,_that.lat,_that.lon,_that.mass,_that.pop,_that.nameJa,_that.nameEs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String cc,  double lat,  double lon,  String mass,  int pop,  String? nameJa,  String? nameEs)?  $default,) {final _that = this;
switch (_that) {
case _City() when $default != null:
return $default(_that.name,_that.cc,_that.lat,_that.lon,_that.mass,_that.pop,_that.nameJa,_that.nameEs);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _City extends City {
  const _City({required this.name, required this.cc, required this.lat, required this.lon, required this.mass, this.pop = 0, this.nameJa, this.nameEs}): super._();
  factory _City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

@override final  String name;
@override final  String cc;
@override final  double lat;
@override final  double lon;
@override final  String mass;
@override@JsonKey() final  int pop;
@override final  String? nameJa;
@override final  String? nameEs;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityCopyWith<_City> get copyWith => __$CityCopyWithImpl<_City>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _City&&(identical(other.name, name) || other.name == name)&&(identical(other.cc, cc) || other.cc == cc)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.mass, mass) || other.mass == mass)&&(identical(other.pop, pop) || other.pop == pop)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,cc,lat,lon,mass,pop,nameJa,nameEs);

@override
String toString() {
  return 'City(name: $name, cc: $cc, lat: $lat, lon: $lon, mass: $mass, pop: $pop, nameJa: $nameJa, nameEs: $nameEs)';
}


}

/// @nodoc
abstract mixin class _$CityCopyWith<$Res> implements $CityCopyWith<$Res> {
  factory _$CityCopyWith(_City value, $Res Function(_City) _then) = __$CityCopyWithImpl;
@override @useResult
$Res call({
 String name, String cc, double lat, double lon, String mass, int pop, String? nameJa, String? nameEs
});




}
/// @nodoc
class __$CityCopyWithImpl<$Res>
    implements _$CityCopyWith<$Res> {
  __$CityCopyWithImpl(this._self, this._then);

  final _City _self;
  final $Res Function(_City) _then;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? cc = null,Object? lat = null,Object? lon = null,Object? mass = null,Object? pop = null,Object? nameJa = freezed,Object? nameEs = freezed,}) {
  return _then(_City(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cc: null == cc ? _self.cc : cc // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,mass: null == mass ? _self.mass : mass // ignore: cast_nullable_to_non_nullable
as String,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as int,nameJa: freezed == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String?,nameEs: freezed == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CityLink {

 String get a; String get b; String get kind; String get label; double? get maxKm; double? get portALat; double? get portALon; double? get radiusAKm; double? get portBLat; double? get portBLon; double? get radiusBKm;
/// Create a copy of CityLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityLinkCopyWith<CityLink> get copyWith => _$CityLinkCopyWithImpl<CityLink>(this as CityLink, _$identity);

  /// Serializes this CityLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CityLink&&(identical(other.a, a) || other.a == a)&&(identical(other.b, b) || other.b == b)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.label, label) || other.label == label)&&(identical(other.maxKm, maxKm) || other.maxKm == maxKm)&&(identical(other.portALat, portALat) || other.portALat == portALat)&&(identical(other.portALon, portALon) || other.portALon == portALon)&&(identical(other.radiusAKm, radiusAKm) || other.radiusAKm == radiusAKm)&&(identical(other.portBLat, portBLat) || other.portBLat == portBLat)&&(identical(other.portBLon, portBLon) || other.portBLon == portBLon)&&(identical(other.radiusBKm, radiusBKm) || other.radiusBKm == radiusBKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,a,b,kind,label,maxKm,portALat,portALon,radiusAKm,portBLat,portBLon,radiusBKm);

@override
String toString() {
  return 'CityLink(a: $a, b: $b, kind: $kind, label: $label, maxKm: $maxKm, portALat: $portALat, portALon: $portALon, radiusAKm: $radiusAKm, portBLat: $portBLat, portBLon: $portBLon, radiusBKm: $radiusBKm)';
}


}

/// @nodoc
abstract mixin class $CityLinkCopyWith<$Res>  {
  factory $CityLinkCopyWith(CityLink value, $Res Function(CityLink) _then) = _$CityLinkCopyWithImpl;
@useResult
$Res call({
 String a, String b, String kind, String label, double? maxKm, double? portALat, double? portALon, double? radiusAKm, double? portBLat, double? portBLon, double? radiusBKm
});




}
/// @nodoc
class _$CityLinkCopyWithImpl<$Res>
    implements $CityLinkCopyWith<$Res> {
  _$CityLinkCopyWithImpl(this._self, this._then);

  final CityLink _self;
  final $Res Function(CityLink) _then;

/// Create a copy of CityLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? a = null,Object? b = null,Object? kind = null,Object? label = null,Object? maxKm = freezed,Object? portALat = freezed,Object? portALon = freezed,Object? radiusAKm = freezed,Object? portBLat = freezed,Object? portBLon = freezed,Object? radiusBKm = freezed,}) {
  return _then(_self.copyWith(
a: null == a ? _self.a : a // ignore: cast_nullable_to_non_nullable
as String,b: null == b ? _self.b : b // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,maxKm: freezed == maxKm ? _self.maxKm : maxKm // ignore: cast_nullable_to_non_nullable
as double?,portALat: freezed == portALat ? _self.portALat : portALat // ignore: cast_nullable_to_non_nullable
as double?,portALon: freezed == portALon ? _self.portALon : portALon // ignore: cast_nullable_to_non_nullable
as double?,radiusAKm: freezed == radiusAKm ? _self.radiusAKm : radiusAKm // ignore: cast_nullable_to_non_nullable
as double?,portBLat: freezed == portBLat ? _self.portBLat : portBLat // ignore: cast_nullable_to_non_nullable
as double?,portBLon: freezed == portBLon ? _self.portBLon : portBLon // ignore: cast_nullable_to_non_nullable
as double?,radiusBKm: freezed == radiusBKm ? _self.radiusBKm : radiusBKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CityLink].
extension CityLinkPatterns on CityLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CityLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CityLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CityLink value)  $default,){
final _that = this;
switch (_that) {
case _CityLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CityLink value)?  $default,){
final _that = this;
switch (_that) {
case _CityLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String a,  String b,  String kind,  String label,  double? maxKm,  double? portALat,  double? portALon,  double? radiusAKm,  double? portBLat,  double? portBLon,  double? radiusBKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CityLink() when $default != null:
return $default(_that.a,_that.b,_that.kind,_that.label,_that.maxKm,_that.portALat,_that.portALon,_that.radiusAKm,_that.portBLat,_that.portBLon,_that.radiusBKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String a,  String b,  String kind,  String label,  double? maxKm,  double? portALat,  double? portALon,  double? radiusAKm,  double? portBLat,  double? portBLon,  double? radiusBKm)  $default,) {final _that = this;
switch (_that) {
case _CityLink():
return $default(_that.a,_that.b,_that.kind,_that.label,_that.maxKm,_that.portALat,_that.portALon,_that.radiusAKm,_that.portBLat,_that.portBLon,_that.radiusBKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String a,  String b,  String kind,  String label,  double? maxKm,  double? portALat,  double? portALon,  double? radiusAKm,  double? portBLat,  double? portBLon,  double? radiusBKm)?  $default,) {final _that = this;
switch (_that) {
case _CityLink() when $default != null:
return $default(_that.a,_that.b,_that.kind,_that.label,_that.maxKm,_that.portALat,_that.portALon,_that.radiusAKm,_that.portBLat,_that.portBLon,_that.radiusBKm);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CityLink implements CityLink {
  const _CityLink({required this.a, required this.b, required this.kind, this.label = '', this.maxKm, this.portALat, this.portALon, this.radiusAKm, this.portBLat, this.portBLon, this.radiusBKm});
  factory _CityLink.fromJson(Map<String, dynamic> json) => _$CityLinkFromJson(json);

@override final  String a;
@override final  String b;
@override final  String kind;
@override@JsonKey() final  String label;
@override final  double? maxKm;
@override final  double? portALat;
@override final  double? portALon;
@override final  double? radiusAKm;
@override final  double? portBLat;
@override final  double? portBLon;
@override final  double? radiusBKm;

/// Create a copy of CityLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityLinkCopyWith<_CityLink> get copyWith => __$CityLinkCopyWithImpl<_CityLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CityLink&&(identical(other.a, a) || other.a == a)&&(identical(other.b, b) || other.b == b)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.label, label) || other.label == label)&&(identical(other.maxKm, maxKm) || other.maxKm == maxKm)&&(identical(other.portALat, portALat) || other.portALat == portALat)&&(identical(other.portALon, portALon) || other.portALon == portALon)&&(identical(other.radiusAKm, radiusAKm) || other.radiusAKm == radiusAKm)&&(identical(other.portBLat, portBLat) || other.portBLat == portBLat)&&(identical(other.portBLon, portBLon) || other.portBLon == portBLon)&&(identical(other.radiusBKm, radiusBKm) || other.radiusBKm == radiusBKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,a,b,kind,label,maxKm,portALat,portALon,radiusAKm,portBLat,portBLon,radiusBKm);

@override
String toString() {
  return 'CityLink(a: $a, b: $b, kind: $kind, label: $label, maxKm: $maxKm, portALat: $portALat, portALon: $portALon, radiusAKm: $radiusAKm, portBLat: $portBLat, portBLon: $portBLon, radiusBKm: $radiusBKm)';
}


}

/// @nodoc
abstract mixin class _$CityLinkCopyWith<$Res> implements $CityLinkCopyWith<$Res> {
  factory _$CityLinkCopyWith(_CityLink value, $Res Function(_CityLink) _then) = __$CityLinkCopyWithImpl;
@override @useResult
$Res call({
 String a, String b, String kind, String label, double? maxKm, double? portALat, double? portALon, double? radiusAKm, double? portBLat, double? portBLon, double? radiusBKm
});




}
/// @nodoc
class __$CityLinkCopyWithImpl<$Res>
    implements _$CityLinkCopyWith<$Res> {
  __$CityLinkCopyWithImpl(this._self, this._then);

  final _CityLink _self;
  final $Res Function(_CityLink) _then;

/// Create a copy of CityLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? a = null,Object? b = null,Object? kind = null,Object? label = null,Object? maxKm = freezed,Object? portALat = freezed,Object? portALon = freezed,Object? radiusAKm = freezed,Object? portBLat = freezed,Object? portBLon = freezed,Object? radiusBKm = freezed,}) {
  return _then(_CityLink(
a: null == a ? _self.a : a // ignore: cast_nullable_to_non_nullable
as String,b: null == b ? _self.b : b // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,maxKm: freezed == maxKm ? _self.maxKm : maxKm // ignore: cast_nullable_to_non_nullable
as double?,portALat: freezed == portALat ? _self.portALat : portALat // ignore: cast_nullable_to_non_nullable
as double?,portALon: freezed == portALon ? _self.portALon : portALon // ignore: cast_nullable_to_non_nullable
as double?,radiusAKm: freezed == radiusAKm ? _self.radiusAKm : radiusAKm // ignore: cast_nullable_to_non_nullable
as double?,portBLat: freezed == portBLat ? _self.portBLat : portBLat // ignore: cast_nullable_to_non_nullable
as double?,portBLon: freezed == portBLon ? _self.portBLon : portBLon // ignore: cast_nullable_to_non_nullable
as double?,radiusBKm: freezed == radiusBKm ? _self.radiusBKm : radiusBKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
