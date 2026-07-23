// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emission_source_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmissionSource {

 String get name; String get url; String get quote; String get accessed;
/// Create a copy of EmissionSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmissionSourceCopyWith<EmissionSource> get copyWith => _$EmissionSourceCopyWithImpl<EmissionSource>(this as EmissionSource, _$identity);

  /// Serializes this EmissionSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmissionSource&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.accessed, accessed) || other.accessed == accessed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,quote,accessed);

@override
String toString() {
  return 'EmissionSource(name: $name, url: $url, quote: $quote, accessed: $accessed)';
}


}

/// @nodoc
abstract mixin class $EmissionSourceCopyWith<$Res>  {
  factory $EmissionSourceCopyWith(EmissionSource value, $Res Function(EmissionSource) _then) = _$EmissionSourceCopyWithImpl;
@useResult
$Res call({
 String name, String url, String quote, String accessed
});




}
/// @nodoc
class _$EmissionSourceCopyWithImpl<$Res>
    implements $EmissionSourceCopyWith<$Res> {
  _$EmissionSourceCopyWithImpl(this._self, this._then);

  final EmissionSource _self;
  final $Res Function(EmissionSource) _then;

/// Create a copy of EmissionSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? url = null,Object? quote = null,Object? accessed = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as String,accessed: null == accessed ? _self.accessed : accessed // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EmissionSource].
extension EmissionSourcePatterns on EmissionSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmissionSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmissionSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmissionSource value)  $default,){
final _that = this;
switch (_that) {
case _EmissionSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmissionSource value)?  $default,){
final _that = this;
switch (_that) {
case _EmissionSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String url,  String quote,  String accessed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmissionSource() when $default != null:
return $default(_that.name,_that.url,_that.quote,_that.accessed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String url,  String quote,  String accessed)  $default,) {final _that = this;
switch (_that) {
case _EmissionSource():
return $default(_that.name,_that.url,_that.quote,_that.accessed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String url,  String quote,  String accessed)?  $default,) {final _that = this;
switch (_that) {
case _EmissionSource() when $default != null:
return $default(_that.name,_that.url,_that.quote,_that.accessed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmissionSource implements EmissionSource {
  const _EmissionSource({required this.name, required this.url, this.quote = '', this.accessed = ''});
  factory _EmissionSource.fromJson(Map<String, dynamic> json) => _$EmissionSourceFromJson(json);

@override final  String name;
@override final  String url;
@override@JsonKey() final  String quote;
@override@JsonKey() final  String accessed;

/// Create a copy of EmissionSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmissionSourceCopyWith<_EmissionSource> get copyWith => __$EmissionSourceCopyWithImpl<_EmissionSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmissionSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmissionSource&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.accessed, accessed) || other.accessed == accessed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,quote,accessed);

@override
String toString() {
  return 'EmissionSource(name: $name, url: $url, quote: $quote, accessed: $accessed)';
}


}

/// @nodoc
abstract mixin class _$EmissionSourceCopyWith<$Res> implements $EmissionSourceCopyWith<$Res> {
  factory _$EmissionSourceCopyWith(_EmissionSource value, $Res Function(_EmissionSource) _then) = __$EmissionSourceCopyWithImpl;
@override @useResult
$Res call({
 String name, String url, String quote, String accessed
});




}
/// @nodoc
class __$EmissionSourceCopyWithImpl<$Res>
    implements _$EmissionSourceCopyWith<$Res> {
  __$EmissionSourceCopyWithImpl(this._self, this._then);

  final _EmissionSource _self;
  final $Res Function(_EmissionSource) _then;

/// Create a copy of EmissionSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? url = null,Object? quote = null,Object? accessed = null,}) {
  return _then(_EmissionSource(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as String,accessed: null == accessed ? _self.accessed : accessed // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
