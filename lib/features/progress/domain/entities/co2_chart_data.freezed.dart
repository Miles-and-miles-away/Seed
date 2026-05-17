// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'co2_chart_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Co2TrendPoint {
  DateTime get date;
  int get grams;

  /// Create a copy of Co2TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Co2TrendPointCopyWith<Co2TrendPoint> get copyWith =>
      _$Co2TrendPointCopyWithImpl<Co2TrendPoint>(
          this as Co2TrendPoint, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Co2TrendPoint &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.grams, grams) || other.grams == grams));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, grams);

  @override
  String toString() {
    return 'Co2TrendPoint(date: $date, grams: $grams)';
  }
}

/// @nodoc
abstract mixin class $Co2TrendPointCopyWith<$Res> {
  factory $Co2TrendPointCopyWith(
          Co2TrendPoint value, $Res Function(Co2TrendPoint) _then) =
      _$Co2TrendPointCopyWithImpl;
  @useResult
  $Res call({DateTime date, int grams});
}

/// @nodoc
class _$Co2TrendPointCopyWithImpl<$Res>
    implements $Co2TrendPointCopyWith<$Res> {
  _$Co2TrendPointCopyWithImpl(this._self, this._then);

  final Co2TrendPoint _self;
  final $Res Function(Co2TrendPoint) _then;

  /// Create a copy of Co2TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? grams = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      grams: null == grams
          ? _self.grams
          : grams // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [Co2TrendPoint].
extension Co2TrendPointPatterns on Co2TrendPoint {
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
    TResult Function(_Co2TrendPoint value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Co2TrendPoint() when $default != null:
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
    TResult Function(_Co2TrendPoint value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2TrendPoint():
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
    TResult? Function(_Co2TrendPoint value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2TrendPoint() when $default != null:
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
    TResult Function(DateTime date, int grams)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Co2TrendPoint() when $default != null:
        return $default(_that.date, _that.grams);
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
    TResult Function(DateTime date, int grams) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2TrendPoint():
        return $default(_that.date, _that.grams);
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
    TResult? Function(DateTime date, int grams)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2TrendPoint() when $default != null:
        return $default(_that.date, _that.grams);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Co2TrendPoint implements Co2TrendPoint {
  const _Co2TrendPoint({required this.date, required this.grams});

  @override
  final DateTime date;
  @override
  final int grams;

  /// Create a copy of Co2TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Co2TrendPointCopyWith<_Co2TrendPoint> get copyWith =>
      __$Co2TrendPointCopyWithImpl<_Co2TrendPoint>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Co2TrendPoint &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.grams, grams) || other.grams == grams));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, grams);

  @override
  String toString() {
    return 'Co2TrendPoint(date: $date, grams: $grams)';
  }
}

/// @nodoc
abstract mixin class _$Co2TrendPointCopyWith<$Res>
    implements $Co2TrendPointCopyWith<$Res> {
  factory _$Co2TrendPointCopyWith(
          _Co2TrendPoint value, $Res Function(_Co2TrendPoint) _then) =
      __$Co2TrendPointCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime date, int grams});
}

/// @nodoc
class __$Co2TrendPointCopyWithImpl<$Res>
    implements _$Co2TrendPointCopyWith<$Res> {
  __$Co2TrendPointCopyWithImpl(this._self, this._then);

  final _Co2TrendPoint _self;
  final $Res Function(_Co2TrendPoint) _then;

  /// Create a copy of Co2TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? grams = null,
  }) {
    return _then(_Co2TrendPoint(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      grams: null == grams
          ? _self.grams
          : grams // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$Co2TrendData {
  List<Co2TrendPoint> get points;
  double get averageGrams;
  DateTime get windowStart;
  DateTime get windowEnd;

  /// Create a copy of Co2TrendData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Co2TrendDataCopyWith<Co2TrendData> get copyWith =>
      _$Co2TrendDataCopyWithImpl<Co2TrendData>(
          this as Co2TrendData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Co2TrendData &&
            const DeepCollectionEquality().equals(other.points, points) &&
            (identical(other.averageGrams, averageGrams) ||
                other.averageGrams == averageGrams) &&
            (identical(other.windowStart, windowStart) ||
                other.windowStart == windowStart) &&
            (identical(other.windowEnd, windowEnd) ||
                other.windowEnd == windowEnd));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(points),
      averageGrams,
      windowStart,
      windowEnd);

  @override
  String toString() {
    return 'Co2TrendData(points: $points, averageGrams: $averageGrams, windowStart: $windowStart, windowEnd: $windowEnd)';
  }
}

/// @nodoc
abstract mixin class $Co2TrendDataCopyWith<$Res> {
  factory $Co2TrendDataCopyWith(
          Co2TrendData value, $Res Function(Co2TrendData) _then) =
      _$Co2TrendDataCopyWithImpl;
  @useResult
  $Res call(
      {List<Co2TrendPoint> points,
      double averageGrams,
      DateTime windowStart,
      DateTime windowEnd});
}

/// @nodoc
class _$Co2TrendDataCopyWithImpl<$Res> implements $Co2TrendDataCopyWith<$Res> {
  _$Co2TrendDataCopyWithImpl(this._self, this._then);

  final Co2TrendData _self;
  final $Res Function(Co2TrendData) _then;

  /// Create a copy of Co2TrendData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? averageGrams = null,
    Object? windowStart = null,
    Object? windowEnd = null,
  }) {
    return _then(_self.copyWith(
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Co2TrendPoint>,
      averageGrams: null == averageGrams
          ? _self.averageGrams
          : averageGrams // ignore: cast_nullable_to_non_nullable
              as double,
      windowStart: null == windowStart
          ? _self.windowStart
          : windowStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      windowEnd: null == windowEnd
          ? _self.windowEnd
          : windowEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Co2TrendData].
extension Co2TrendDataPatterns on Co2TrendData {
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
    TResult Function(_Co2TrendData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Co2TrendData() when $default != null:
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
    TResult Function(_Co2TrendData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2TrendData():
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
    TResult? Function(_Co2TrendData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2TrendData() when $default != null:
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
    TResult Function(List<Co2TrendPoint> points, double averageGrams,
            DateTime windowStart, DateTime windowEnd)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Co2TrendData() when $default != null:
        return $default(_that.points, _that.averageGrams, _that.windowStart,
            _that.windowEnd);
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
    TResult Function(List<Co2TrendPoint> points, double averageGrams,
            DateTime windowStart, DateTime windowEnd)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2TrendData():
        return $default(_that.points, _that.averageGrams, _that.windowStart,
            _that.windowEnd);
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
    TResult? Function(List<Co2TrendPoint> points, double averageGrams,
            DateTime windowStart, DateTime windowEnd)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2TrendData() when $default != null:
        return $default(_that.points, _that.averageGrams, _that.windowStart,
            _that.windowEnd);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Co2TrendData extends Co2TrendData {
  const _Co2TrendData(
      {required final List<Co2TrendPoint> points,
      required this.averageGrams,
      required this.windowStart,
      required this.windowEnd})
      : _points = points,
        super._();

  final List<Co2TrendPoint> _points;
  @override
  List<Co2TrendPoint> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  final double averageGrams;
  @override
  final DateTime windowStart;
  @override
  final DateTime windowEnd;

  /// Create a copy of Co2TrendData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Co2TrendDataCopyWith<_Co2TrendData> get copyWith =>
      __$Co2TrendDataCopyWithImpl<_Co2TrendData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Co2TrendData &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            (identical(other.averageGrams, averageGrams) ||
                other.averageGrams == averageGrams) &&
            (identical(other.windowStart, windowStart) ||
                other.windowStart == windowStart) &&
            (identical(other.windowEnd, windowEnd) ||
                other.windowEnd == windowEnd));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_points),
      averageGrams,
      windowStart,
      windowEnd);

  @override
  String toString() {
    return 'Co2TrendData(points: $points, averageGrams: $averageGrams, windowStart: $windowStart, windowEnd: $windowEnd)';
  }
}

/// @nodoc
abstract mixin class _$Co2TrendDataCopyWith<$Res>
    implements $Co2TrendDataCopyWith<$Res> {
  factory _$Co2TrendDataCopyWith(
          _Co2TrendData value, $Res Function(_Co2TrendData) _then) =
      __$Co2TrendDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Co2TrendPoint> points,
      double averageGrams,
      DateTime windowStart,
      DateTime windowEnd});
}

/// @nodoc
class __$Co2TrendDataCopyWithImpl<$Res>
    implements _$Co2TrendDataCopyWith<$Res> {
  __$Co2TrendDataCopyWithImpl(this._self, this._then);

  final _Co2TrendData _self;
  final $Res Function(_Co2TrendData) _then;

  /// Create a copy of Co2TrendData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? points = null,
    Object? averageGrams = null,
    Object? windowStart = null,
    Object? windowEnd = null,
  }) {
    return _then(_Co2TrendData(
      points: null == points
          ? _self._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Co2TrendPoint>,
      averageGrams: null == averageGrams
          ? _self.averageGrams
          : averageGrams // ignore: cast_nullable_to_non_nullable
              as double,
      windowStart: null == windowStart
          ? _self.windowStart
          : windowStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      windowEnd: null == windowEnd
          ? _self.windowEnd
          : windowEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$Co2CategorySlice {
  ActionCategory? get category;
  int get grams;
  double get percentage;

  /// Create a copy of Co2CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Co2CategorySliceCopyWith<Co2CategorySlice> get copyWith =>
      _$Co2CategorySliceCopyWithImpl<Co2CategorySlice>(
          this as Co2CategorySlice, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Co2CategorySlice &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.grams, grams) || other.grams == grams) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category, grams, percentage);

  @override
  String toString() {
    return 'Co2CategorySlice(category: $category, grams: $grams, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class $Co2CategorySliceCopyWith<$Res> {
  factory $Co2CategorySliceCopyWith(
          Co2CategorySlice value, $Res Function(Co2CategorySlice) _then) =
      _$Co2CategorySliceCopyWithImpl;
  @useResult
  $Res call({ActionCategory? category, int grams, double percentage});
}

/// @nodoc
class _$Co2CategorySliceCopyWithImpl<$Res>
    implements $Co2CategorySliceCopyWith<$Res> {
  _$Co2CategorySliceCopyWithImpl(this._self, this._then);

  final Co2CategorySlice _self;
  final $Res Function(Co2CategorySlice) _then;

  /// Create a copy of Co2CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? grams = null,
    Object? percentage = null,
  }) {
    return _then(_self.copyWith(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as ActionCategory?,
      grams: null == grams
          ? _self.grams
          : grams // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [Co2CategorySlice].
extension Co2CategorySlicePatterns on Co2CategorySlice {
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
    TResult Function(_Co2CategorySlice value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Co2CategorySlice() when $default != null:
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
    TResult Function(_Co2CategorySlice value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2CategorySlice():
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
    TResult? Function(_Co2CategorySlice value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2CategorySlice() when $default != null:
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
    TResult Function(ActionCategory? category, int grams, double percentage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Co2CategorySlice() when $default != null:
        return $default(_that.category, _that.grams, _that.percentage);
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
    TResult Function(ActionCategory? category, int grams, double percentage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2CategorySlice():
        return $default(_that.category, _that.grams, _that.percentage);
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
    TResult? Function(ActionCategory? category, int grams, double percentage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2CategorySlice() when $default != null:
        return $default(_that.category, _that.grams, _that.percentage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Co2CategorySlice extends Co2CategorySlice {
  const _Co2CategorySlice(
      {required this.category, required this.grams, required this.percentage})
      : super._();

  @override
  final ActionCategory? category;
  @override
  final int grams;
  @override
  final double percentage;

  /// Create a copy of Co2CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Co2CategorySliceCopyWith<_Co2CategorySlice> get copyWith =>
      __$Co2CategorySliceCopyWithImpl<_Co2CategorySlice>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Co2CategorySlice &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.grams, grams) || other.grams == grams) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category, grams, percentage);

  @override
  String toString() {
    return 'Co2CategorySlice(category: $category, grams: $grams, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class _$Co2CategorySliceCopyWith<$Res>
    implements $Co2CategorySliceCopyWith<$Res> {
  factory _$Co2CategorySliceCopyWith(
          _Co2CategorySlice value, $Res Function(_Co2CategorySlice) _then) =
      __$Co2CategorySliceCopyWithImpl;
  @override
  @useResult
  $Res call({ActionCategory? category, int grams, double percentage});
}

/// @nodoc
class __$Co2CategorySliceCopyWithImpl<$Res>
    implements _$Co2CategorySliceCopyWith<$Res> {
  __$Co2CategorySliceCopyWithImpl(this._self, this._then);

  final _Co2CategorySlice _self;
  final $Res Function(_Co2CategorySlice) _then;

  /// Create a copy of Co2CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = freezed,
    Object? grams = null,
    Object? percentage = null,
  }) {
    return _then(_Co2CategorySlice(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as ActionCategory?,
      grams: null == grams
          ? _self.grams
          : grams // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$Co2CategoryData {
  List<Co2CategorySlice> get slices;
  int get totalGrams;

  /// Create a copy of Co2CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Co2CategoryDataCopyWith<Co2CategoryData> get copyWith =>
      _$Co2CategoryDataCopyWithImpl<Co2CategoryData>(
          this as Co2CategoryData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Co2CategoryData &&
            const DeepCollectionEquality().equals(other.slices, slices) &&
            (identical(other.totalGrams, totalGrams) ||
                other.totalGrams == totalGrams));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(slices), totalGrams);

  @override
  String toString() {
    return 'Co2CategoryData(slices: $slices, totalGrams: $totalGrams)';
  }
}

/// @nodoc
abstract mixin class $Co2CategoryDataCopyWith<$Res> {
  factory $Co2CategoryDataCopyWith(
          Co2CategoryData value, $Res Function(Co2CategoryData) _then) =
      _$Co2CategoryDataCopyWithImpl;
  @useResult
  $Res call({List<Co2CategorySlice> slices, int totalGrams});
}

/// @nodoc
class _$Co2CategoryDataCopyWithImpl<$Res>
    implements $Co2CategoryDataCopyWith<$Res> {
  _$Co2CategoryDataCopyWithImpl(this._self, this._then);

  final Co2CategoryData _self;
  final $Res Function(Co2CategoryData) _then;

  /// Create a copy of Co2CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slices = null,
    Object? totalGrams = null,
  }) {
    return _then(_self.copyWith(
      slices: null == slices
          ? _self.slices
          : slices // ignore: cast_nullable_to_non_nullable
              as List<Co2CategorySlice>,
      totalGrams: null == totalGrams
          ? _self.totalGrams
          : totalGrams // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [Co2CategoryData].
extension Co2CategoryDataPatterns on Co2CategoryData {
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
    TResult Function(_Co2CategoryData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Co2CategoryData() when $default != null:
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
    TResult Function(_Co2CategoryData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2CategoryData():
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
    TResult? Function(_Co2CategoryData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2CategoryData() when $default != null:
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
    TResult Function(List<Co2CategorySlice> slices, int totalGrams)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Co2CategoryData() when $default != null:
        return $default(_that.slices, _that.totalGrams);
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
    TResult Function(List<Co2CategorySlice> slices, int totalGrams) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2CategoryData():
        return $default(_that.slices, _that.totalGrams);
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
    TResult? Function(List<Co2CategorySlice> slices, int totalGrams)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Co2CategoryData() when $default != null:
        return $default(_that.slices, _that.totalGrams);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Co2CategoryData extends Co2CategoryData {
  const _Co2CategoryData(
      {required final List<Co2CategorySlice> slices, required this.totalGrams})
      : _slices = slices,
        super._();

  final List<Co2CategorySlice> _slices;
  @override
  List<Co2CategorySlice> get slices {
    if (_slices is EqualUnmodifiableListView) return _slices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_slices);
  }

  @override
  final int totalGrams;

  /// Create a copy of Co2CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Co2CategoryDataCopyWith<_Co2CategoryData> get copyWith =>
      __$Co2CategoryDataCopyWithImpl<_Co2CategoryData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Co2CategoryData &&
            const DeepCollectionEquality().equals(other._slices, _slices) &&
            (identical(other.totalGrams, totalGrams) ||
                other.totalGrams == totalGrams));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_slices), totalGrams);

  @override
  String toString() {
    return 'Co2CategoryData(slices: $slices, totalGrams: $totalGrams)';
  }
}

/// @nodoc
abstract mixin class _$Co2CategoryDataCopyWith<$Res>
    implements $Co2CategoryDataCopyWith<$Res> {
  factory _$Co2CategoryDataCopyWith(
          _Co2CategoryData value, $Res Function(_Co2CategoryData) _then) =
      __$Co2CategoryDataCopyWithImpl;
  @override
  @useResult
  $Res call({List<Co2CategorySlice> slices, int totalGrams});
}

/// @nodoc
class __$Co2CategoryDataCopyWithImpl<$Res>
    implements _$Co2CategoryDataCopyWith<$Res> {
  __$Co2CategoryDataCopyWithImpl(this._self, this._then);

  final _Co2CategoryData _self;
  final $Res Function(_Co2CategoryData) _then;

  /// Create a copy of Co2CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? slices = null,
    Object? totalGrams = null,
  }) {
    return _then(_Co2CategoryData(
      slices: null == slices
          ? _self._slices
          : slices // ignore: cast_nullable_to_non_nullable
              as List<Co2CategorySlice>,
      totalGrams: null == totalGrams
          ? _self.totalGrams
          : totalGrams // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
