// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdg_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SdgStats {
  int get sdgNumber;
  int get actionsLogged;
  int get co2SavedGrams;

  /// Create a copy of SdgStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SdgStatsCopyWith<SdgStats> get copyWith =>
      _$SdgStatsCopyWithImpl<SdgStats>(this as SdgStats, _$identity);

  /// Serializes this SdgStats to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SdgStats &&
            (identical(other.sdgNumber, sdgNumber) ||
                other.sdgNumber == sdgNumber) &&
            (identical(other.actionsLogged, actionsLogged) ||
                other.actionsLogged == actionsLogged) &&
            (identical(other.co2SavedGrams, co2SavedGrams) ||
                other.co2SavedGrams == co2SavedGrams));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sdgNumber, actionsLogged, co2SavedGrams);

  @override
  String toString() {
    return 'SdgStats(sdgNumber: $sdgNumber, actionsLogged: $actionsLogged, co2SavedGrams: $co2SavedGrams)';
  }
}

/// @nodoc
abstract mixin class $SdgStatsCopyWith<$Res> {
  factory $SdgStatsCopyWith(SdgStats value, $Res Function(SdgStats) _then) =
      _$SdgStatsCopyWithImpl;
  @useResult
  $Res call({int sdgNumber, int actionsLogged, int co2SavedGrams});
}

/// @nodoc
class _$SdgStatsCopyWithImpl<$Res> implements $SdgStatsCopyWith<$Res> {
  _$SdgStatsCopyWithImpl(this._self, this._then);

  final SdgStats _self;
  final $Res Function(SdgStats) _then;

  /// Create a copy of SdgStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sdgNumber = null,
    Object? actionsLogged = null,
    Object? co2SavedGrams = null,
  }) {
    return _then(_self.copyWith(
      sdgNumber: null == sdgNumber
          ? _self.sdgNumber
          : sdgNumber // ignore: cast_nullable_to_non_nullable
              as int,
      actionsLogged: null == actionsLogged
          ? _self.actionsLogged
          : actionsLogged // ignore: cast_nullable_to_non_nullable
              as int,
      co2SavedGrams: null == co2SavedGrams
          ? _self.co2SavedGrams
          : co2SavedGrams // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [SdgStats].
extension SdgStatsPatterns on SdgStats {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SdgStats value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SdgStats() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SdgStats value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SdgStats():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SdgStats value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SdgStats() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int sdgNumber, int actionsLogged, int co2SavedGrams)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SdgStats() when $default != null:
        return $default(
            _that.sdgNumber, _that.actionsLogged, _that.co2SavedGrams);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int sdgNumber, int actionsLogged, int co2SavedGrams)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SdgStats():
        return $default(
            _that.sdgNumber, _that.actionsLogged, _that.co2SavedGrams);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int sdgNumber, int actionsLogged, int co2SavedGrams)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SdgStats() when $default != null:
        return $default(
            _that.sdgNumber, _that.actionsLogged, _that.co2SavedGrams);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SdgStats implements SdgStats {
  const _SdgStats(
      {required this.sdgNumber,
      this.actionsLogged = 0,
      this.co2SavedGrams = 0});
  factory _SdgStats.fromJson(Map<String, dynamic> json) =>
      _$SdgStatsFromJson(json);

  @override
  final int sdgNumber;
  @override
  @JsonKey()
  final int actionsLogged;
  @override
  @JsonKey()
  final int co2SavedGrams;

  /// Create a copy of SdgStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SdgStatsCopyWith<_SdgStats> get copyWith =>
      __$SdgStatsCopyWithImpl<_SdgStats>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SdgStatsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SdgStats &&
            (identical(other.sdgNumber, sdgNumber) ||
                other.sdgNumber == sdgNumber) &&
            (identical(other.actionsLogged, actionsLogged) ||
                other.actionsLogged == actionsLogged) &&
            (identical(other.co2SavedGrams, co2SavedGrams) ||
                other.co2SavedGrams == co2SavedGrams));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sdgNumber, actionsLogged, co2SavedGrams);

  @override
  String toString() {
    return 'SdgStats(sdgNumber: $sdgNumber, actionsLogged: $actionsLogged, co2SavedGrams: $co2SavedGrams)';
  }
}

/// @nodoc
abstract mixin class _$SdgStatsCopyWith<$Res>
    implements $SdgStatsCopyWith<$Res> {
  factory _$SdgStatsCopyWith(_SdgStats value, $Res Function(_SdgStats) _then) =
      __$SdgStatsCopyWithImpl;
  @override
  @useResult
  $Res call({int sdgNumber, int actionsLogged, int co2SavedGrams});
}

/// @nodoc
class __$SdgStatsCopyWithImpl<$Res> implements _$SdgStatsCopyWith<$Res> {
  __$SdgStatsCopyWithImpl(this._self, this._then);

  final _SdgStats _self;
  final $Res Function(_SdgStats) _then;

  /// Create a copy of SdgStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sdgNumber = null,
    Object? actionsLogged = null,
    Object? co2SavedGrams = null,
  }) {
    return _then(_SdgStats(
      sdgNumber: null == sdgNumber
          ? _self.sdgNumber
          : sdgNumber // ignore: cast_nullable_to_non_nullable
              as int,
      actionsLogged: null == actionsLogged
          ? _self.actionsLogged
          : actionsLogged // ignore: cast_nullable_to_non_nullable
              as int,
      co2SavedGrams: null == co2SavedGrams
          ? _self.co2SavedGrams
          : co2SavedGrams // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
