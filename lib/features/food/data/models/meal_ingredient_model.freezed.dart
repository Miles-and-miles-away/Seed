// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_ingredient_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MealIngredient {

 String get itemId; double get grams;
/// Create a copy of MealIngredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealIngredientCopyWith<MealIngredient> get copyWith => _$MealIngredientCopyWithImpl<MealIngredient>(this as MealIngredient, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealIngredient&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.grams, grams) || other.grams == grams));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,grams);

@override
String toString() {
  return 'MealIngredient(itemId: $itemId, grams: $grams)';
}


}

/// @nodoc
abstract mixin class $MealIngredientCopyWith<$Res>  {
  factory $MealIngredientCopyWith(MealIngredient value, $Res Function(MealIngredient) _then) = _$MealIngredientCopyWithImpl;
@useResult
$Res call({
 String itemId, double grams
});




}
/// @nodoc
class _$MealIngredientCopyWithImpl<$Res>
    implements $MealIngredientCopyWith<$Res> {
  _$MealIngredientCopyWithImpl(this._self, this._then);

  final MealIngredient _self;
  final $Res Function(MealIngredient) _then;

/// Create a copy of MealIngredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? grams = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MealIngredient].
extension MealIngredientPatterns on MealIngredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealIngredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealIngredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealIngredient value)  $default,){
final _that = this;
switch (_that) {
case _MealIngredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealIngredient value)?  $default,){
final _that = this;
switch (_that) {
case _MealIngredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  double grams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealIngredient() when $default != null:
return $default(_that.itemId,_that.grams);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  double grams)  $default,) {final _that = this;
switch (_that) {
case _MealIngredient():
return $default(_that.itemId,_that.grams);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  double grams)?  $default,) {final _that = this;
switch (_that) {
case _MealIngredient() when $default != null:
return $default(_that.itemId,_that.grams);case _:
  return null;

}
}

}

/// @nodoc


class _MealIngredient implements MealIngredient {
  const _MealIngredient({required this.itemId, required this.grams});
  

@override final  String itemId;
@override final  double grams;

/// Create a copy of MealIngredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealIngredientCopyWith<_MealIngredient> get copyWith => __$MealIngredientCopyWithImpl<_MealIngredient>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealIngredient&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.grams, grams) || other.grams == grams));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,grams);

@override
String toString() {
  return 'MealIngredient(itemId: $itemId, grams: $grams)';
}


}

/// @nodoc
abstract mixin class _$MealIngredientCopyWith<$Res> implements $MealIngredientCopyWith<$Res> {
  factory _$MealIngredientCopyWith(_MealIngredient value, $Res Function(_MealIngredient) _then) = __$MealIngredientCopyWithImpl;
@override @useResult
$Res call({
 String itemId, double grams
});




}
/// @nodoc
class __$MealIngredientCopyWithImpl<$Res>
    implements _$MealIngredientCopyWith<$Res> {
  __$MealIngredientCopyWithImpl(this._self, this._then);

  final _MealIngredient _self;
  final $Res Function(_MealIngredient) _then;

/// Create a copy of MealIngredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? grams = null,}) {
  return _then(_MealIngredient(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
