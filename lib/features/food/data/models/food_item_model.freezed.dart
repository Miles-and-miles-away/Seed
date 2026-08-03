// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodItem {

 String get id; String get group; String get nameEn; String get nameJa; String get nameEs; double get kgCo2ePerKg; List<ServingPreset> get servings; List<String> get searchTermsEn; List<String> get searchTermsJa; List<String> get searchTermsEs; String get calculationNotes; List<EmissionSource> get sources;
/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodItemCopyWith<FoodItem> get copyWith => _$FoodItemCopyWithImpl<FoodItem>(this as FoodItem, _$identity);

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.group, group) || other.group == group)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.kgCo2ePerKg, kgCo2ePerKg) || other.kgCo2ePerKg == kgCo2ePerKg)&&const DeepCollectionEquality().equals(other.servings, servings)&&const DeepCollectionEquality().equals(other.searchTermsEn, searchTermsEn)&&const DeepCollectionEquality().equals(other.searchTermsJa, searchTermsJa)&&const DeepCollectionEquality().equals(other.searchTermsEs, searchTermsEs)&&(identical(other.calculationNotes, calculationNotes) || other.calculationNotes == calculationNotes)&&const DeepCollectionEquality().equals(other.sources, sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,group,nameEn,nameJa,nameEs,kgCo2ePerKg,const DeepCollectionEquality().hash(servings),const DeepCollectionEquality().hash(searchTermsEn),const DeepCollectionEquality().hash(searchTermsJa),const DeepCollectionEquality().hash(searchTermsEs),calculationNotes,const DeepCollectionEquality().hash(sources));

@override
String toString() {
  return 'FoodItem(id: $id, group: $group, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, kgCo2ePerKg: $kgCo2ePerKg, servings: $servings, searchTermsEn: $searchTermsEn, searchTermsJa: $searchTermsJa, searchTermsEs: $searchTermsEs, calculationNotes: $calculationNotes, sources: $sources)';
}


}

/// @nodoc
abstract mixin class $FoodItemCopyWith<$Res>  {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) _then) = _$FoodItemCopyWithImpl;
@useResult
$Res call({
 String id, String group, String nameEn, String nameJa, String nameEs, double kgCo2ePerKg, List<ServingPreset> servings, List<String> searchTermsEn, List<String> searchTermsJa, List<String> searchTermsEs, String calculationNotes, List<EmissionSource> sources
});




}
/// @nodoc
class _$FoodItemCopyWithImpl<$Res>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._self, this._then);

  final FoodItem _self;
  final $Res Function(FoodItem) _then;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? group = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? kgCo2ePerKg = null,Object? servings = null,Object? searchTermsEn = null,Object? searchTermsJa = null,Object? searchTermsEs = null,Object? calculationNotes = null,Object? sources = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,kgCo2ePerKg: null == kgCo2ePerKg ? _self.kgCo2ePerKg : kgCo2ePerKg // ignore: cast_nullable_to_non_nullable
as double,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as List<ServingPreset>,searchTermsEn: null == searchTermsEn ? _self.searchTermsEn : searchTermsEn // ignore: cast_nullable_to_non_nullable
as List<String>,searchTermsJa: null == searchTermsJa ? _self.searchTermsJa : searchTermsJa // ignore: cast_nullable_to_non_nullable
as List<String>,searchTermsEs: null == searchTermsEs ? _self.searchTermsEs : searchTermsEs // ignore: cast_nullable_to_non_nullable
as List<String>,calculationNotes: null == calculationNotes ? _self.calculationNotes : calculationNotes // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<EmissionSource>,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodItem].
extension FoodItemPatterns on FoodItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodItem value)  $default,){
final _that = this;
switch (_that) {
case _FoodItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodItem value)?  $default,){
final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String group,  String nameEn,  String nameJa,  String nameEs,  double kgCo2ePerKg,  List<ServingPreset> servings,  List<String> searchTermsEn,  List<String> searchTermsJa,  List<String> searchTermsEs,  String calculationNotes,  List<EmissionSource> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.group,_that.nameEn,_that.nameJa,_that.nameEs,_that.kgCo2ePerKg,_that.servings,_that.searchTermsEn,_that.searchTermsJa,_that.searchTermsEs,_that.calculationNotes,_that.sources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String group,  String nameEn,  String nameJa,  String nameEs,  double kgCo2ePerKg,  List<ServingPreset> servings,  List<String> searchTermsEn,  List<String> searchTermsJa,  List<String> searchTermsEs,  String calculationNotes,  List<EmissionSource> sources)  $default,) {final _that = this;
switch (_that) {
case _FoodItem():
return $default(_that.id,_that.group,_that.nameEn,_that.nameJa,_that.nameEs,_that.kgCo2ePerKg,_that.servings,_that.searchTermsEn,_that.searchTermsJa,_that.searchTermsEs,_that.calculationNotes,_that.sources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String group,  String nameEn,  String nameJa,  String nameEs,  double kgCo2ePerKg,  List<ServingPreset> servings,  List<String> searchTermsEn,  List<String> searchTermsJa,  List<String> searchTermsEs,  String calculationNotes,  List<EmissionSource> sources)?  $default,) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.group,_that.nameEn,_that.nameJa,_that.nameEs,_that.kgCo2ePerKg,_that.servings,_that.searchTermsEn,_that.searchTermsJa,_that.searchTermsEs,_that.calculationNotes,_that.sources);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _FoodItem extends FoodItem {
  const _FoodItem({required this.id, required this.group, required this.nameEn, required this.nameJa, required this.nameEs, required this.kgCo2ePerKg, final  List<ServingPreset> servings = const [], final  List<String> searchTermsEn = const [], final  List<String> searchTermsJa = const [], final  List<String> searchTermsEs = const [], this.calculationNotes = '', final  List<EmissionSource> sources = const []}): _servings = servings,_searchTermsEn = searchTermsEn,_searchTermsJa = searchTermsJa,_searchTermsEs = searchTermsEs,_sources = sources,super._();
  factory _FoodItem.fromJson(Map<String, dynamic> json) => _$FoodItemFromJson(json);

@override final  String id;
@override final  String group;
@override final  String nameEn;
@override final  String nameJa;
@override final  String nameEs;
@override final  double kgCo2ePerKg;
 final  List<ServingPreset> _servings;
@override@JsonKey() List<ServingPreset> get servings {
  if (_servings is EqualUnmodifiableListView) return _servings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servings);
}

 final  List<String> _searchTermsEn;
@override@JsonKey() List<String> get searchTermsEn {
  if (_searchTermsEn is EqualUnmodifiableListView) return _searchTermsEn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTermsEn);
}

 final  List<String> _searchTermsJa;
@override@JsonKey() List<String> get searchTermsJa {
  if (_searchTermsJa is EqualUnmodifiableListView) return _searchTermsJa;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTermsJa);
}

 final  List<String> _searchTermsEs;
@override@JsonKey() List<String> get searchTermsEs {
  if (_searchTermsEs is EqualUnmodifiableListView) return _searchTermsEs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTermsEs);
}

@override@JsonKey() final  String calculationNotes;
 final  List<EmissionSource> _sources;
@override@JsonKey() List<EmissionSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodItemCopyWith<_FoodItem> get copyWith => __$FoodItemCopyWithImpl<_FoodItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.group, group) || other.group == group)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameJa, nameJa) || other.nameJa == nameJa)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.kgCo2ePerKg, kgCo2ePerKg) || other.kgCo2ePerKg == kgCo2ePerKg)&&const DeepCollectionEquality().equals(other._servings, _servings)&&const DeepCollectionEquality().equals(other._searchTermsEn, _searchTermsEn)&&const DeepCollectionEquality().equals(other._searchTermsJa, _searchTermsJa)&&const DeepCollectionEquality().equals(other._searchTermsEs, _searchTermsEs)&&(identical(other.calculationNotes, calculationNotes) || other.calculationNotes == calculationNotes)&&const DeepCollectionEquality().equals(other._sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,group,nameEn,nameJa,nameEs,kgCo2ePerKg,const DeepCollectionEquality().hash(_servings),const DeepCollectionEquality().hash(_searchTermsEn),const DeepCollectionEquality().hash(_searchTermsJa),const DeepCollectionEquality().hash(_searchTermsEs),calculationNotes,const DeepCollectionEquality().hash(_sources));

@override
String toString() {
  return 'FoodItem(id: $id, group: $group, nameEn: $nameEn, nameJa: $nameJa, nameEs: $nameEs, kgCo2ePerKg: $kgCo2ePerKg, servings: $servings, searchTermsEn: $searchTermsEn, searchTermsJa: $searchTermsJa, searchTermsEs: $searchTermsEs, calculationNotes: $calculationNotes, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$FoodItemCopyWith<$Res> implements $FoodItemCopyWith<$Res> {
  factory _$FoodItemCopyWith(_FoodItem value, $Res Function(_FoodItem) _then) = __$FoodItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String group, String nameEn, String nameJa, String nameEs, double kgCo2ePerKg, List<ServingPreset> servings, List<String> searchTermsEn, List<String> searchTermsJa, List<String> searchTermsEs, String calculationNotes, List<EmissionSource> sources
});




}
/// @nodoc
class __$FoodItemCopyWithImpl<$Res>
    implements _$FoodItemCopyWith<$Res> {
  __$FoodItemCopyWithImpl(this._self, this._then);

  final _FoodItem _self;
  final $Res Function(_FoodItem) _then;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? group = null,Object? nameEn = null,Object? nameJa = null,Object? nameEs = null,Object? kgCo2ePerKg = null,Object? servings = null,Object? searchTermsEn = null,Object? searchTermsJa = null,Object? searchTermsEs = null,Object? calculationNotes = null,Object? sources = null,}) {
  return _then(_FoodItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameJa: null == nameJa ? _self.nameJa : nameJa // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,kgCo2ePerKg: null == kgCo2ePerKg ? _self.kgCo2ePerKg : kgCo2ePerKg // ignore: cast_nullable_to_non_nullable
as double,servings: null == servings ? _self._servings : servings // ignore: cast_nullable_to_non_nullable
as List<ServingPreset>,searchTermsEn: null == searchTermsEn ? _self._searchTermsEn : searchTermsEn // ignore: cast_nullable_to_non_nullable
as List<String>,searchTermsJa: null == searchTermsJa ? _self._searchTermsJa : searchTermsJa // ignore: cast_nullable_to_non_nullable
as List<String>,searchTermsEs: null == searchTermsEs ? _self._searchTermsEs : searchTermsEs // ignore: cast_nullable_to_non_nullable
as List<String>,calculationNotes: null == calculationNotes ? _self.calculationNotes : calculationNotes // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<EmissionSource>,
  ));
}


}

// dart format on
