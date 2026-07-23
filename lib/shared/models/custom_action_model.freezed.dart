// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_action_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomAction {

 String get id; String get name; int get co2Grams; int get points; String get category; List<String> get relatedSdgs;
/// Create a copy of CustomAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomActionCopyWith<CustomAction> get copyWith => _$CustomActionCopyWithImpl<CustomAction>(this as CustomAction, _$identity);

  /// Serializes this CustomAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomAction&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.co2Grams, co2Grams) || other.co2Grams == co2Grams)&&(identical(other.points, points) || other.points == points)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.relatedSdgs, relatedSdgs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,co2Grams,points,category,const DeepCollectionEquality().hash(relatedSdgs));

@override
String toString() {
  return 'CustomAction(id: $id, name: $name, co2Grams: $co2Grams, points: $points, category: $category, relatedSdgs: $relatedSdgs)';
}


}

/// @nodoc
abstract mixin class $CustomActionCopyWith<$Res>  {
  factory $CustomActionCopyWith(CustomAction value, $Res Function(CustomAction) _then) = _$CustomActionCopyWithImpl;
@useResult
$Res call({
 String id, String name, int co2Grams, int points, String category, List<String> relatedSdgs
});




}
/// @nodoc
class _$CustomActionCopyWithImpl<$Res>
    implements $CustomActionCopyWith<$Res> {
  _$CustomActionCopyWithImpl(this._self, this._then);

  final CustomAction _self;
  final $Res Function(CustomAction) _then;

/// Create a copy of CustomAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? co2Grams = null,Object? points = null,Object? category = null,Object? relatedSdgs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,co2Grams: null == co2Grams ? _self.co2Grams : co2Grams // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,relatedSdgs: null == relatedSdgs ? _self.relatedSdgs : relatedSdgs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomAction].
extension CustomActionPatterns on CustomAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomAction value)  $default,){
final _that = this;
switch (_that) {
case _CustomAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomAction value)?  $default,){
final _that = this;
switch (_that) {
case _CustomAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int co2Grams,  int points,  String category,  List<String> relatedSdgs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomAction() when $default != null:
return $default(_that.id,_that.name,_that.co2Grams,_that.points,_that.category,_that.relatedSdgs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int co2Grams,  int points,  String category,  List<String> relatedSdgs)  $default,) {final _that = this;
switch (_that) {
case _CustomAction():
return $default(_that.id,_that.name,_that.co2Grams,_that.points,_that.category,_that.relatedSdgs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int co2Grams,  int points,  String category,  List<String> relatedSdgs)?  $default,) {final _that = this;
switch (_that) {
case _CustomAction() when $default != null:
return $default(_that.id,_that.name,_that.co2Grams,_that.points,_that.category,_that.relatedSdgs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomAction extends CustomAction {
  const _CustomAction({required this.id, required this.name, required this.co2Grams, required this.points, required this.category, required final  List<String> relatedSdgs}): _relatedSdgs = relatedSdgs,super._();
  factory _CustomAction.fromJson(Map<String, dynamic> json) => _$CustomActionFromJson(json);

@override final  String id;
@override final  String name;
@override final  int co2Grams;
@override final  int points;
@override final  String category;
 final  List<String> _relatedSdgs;
@override List<String> get relatedSdgs {
  if (_relatedSdgs is EqualUnmodifiableListView) return _relatedSdgs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedSdgs);
}


/// Create a copy of CustomAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomActionCopyWith<_CustomAction> get copyWith => __$CustomActionCopyWithImpl<_CustomAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomAction&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.co2Grams, co2Grams) || other.co2Grams == co2Grams)&&(identical(other.points, points) || other.points == points)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._relatedSdgs, _relatedSdgs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,co2Grams,points,category,const DeepCollectionEquality().hash(_relatedSdgs));

@override
String toString() {
  return 'CustomAction(id: $id, name: $name, co2Grams: $co2Grams, points: $points, category: $category, relatedSdgs: $relatedSdgs)';
}


}

/// @nodoc
abstract mixin class _$CustomActionCopyWith<$Res> implements $CustomActionCopyWith<$Res> {
  factory _$CustomActionCopyWith(_CustomAction value, $Res Function(_CustomAction) _then) = __$CustomActionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int co2Grams, int points, String category, List<String> relatedSdgs
});




}
/// @nodoc
class __$CustomActionCopyWithImpl<$Res>
    implements _$CustomActionCopyWith<$Res> {
  __$CustomActionCopyWithImpl(this._self, this._then);

  final _CustomAction _self;
  final $Res Function(_CustomAction) _then;

/// Create a copy of CustomAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? co2Grams = null,Object? points = null,Object? category = null,Object? relatedSdgs = null,}) {
  return _then(_CustomAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,co2Grams: null == co2Grams ? _self.co2Grams : co2Grams // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,relatedSdgs: null == relatedSdgs ? _self._relatedSdgs : relatedSdgs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
