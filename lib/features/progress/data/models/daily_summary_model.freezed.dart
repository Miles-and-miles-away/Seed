// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailySummaryModel {
  /// Date string in YYYY-MM-DD format (document ID)
  String get date;

  /// Number of goals completed today
  int get goalCount;

  /// List of completed SDG numbers (1-17, deduplicated)
  List<int> get completedSdgs;

  /// Total points earned today
  int get totalPoints;

  /// Total CO2 saved in grams today
  int get totalCo2Grams;

  /// CO2 saved in grams today, broken down by action category.
  /// Stored as a flat dotted-path field map in Firestore so partial
  /// updates work via FieldValue.increment on a specific key
  /// (e.g., `categoryCo2Grams.transport`).
  Map<String, int> get categoryCo2Grams;

  /// When this summary was created
  @TimestampConverter()
  DateTime? get createdAt;

  /// When this summary was last updated
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of DailySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailySummaryModelCopyWith<DailySummaryModel> get copyWith =>
      _$DailySummaryModelCopyWithImpl<DailySummaryModel>(
          this as DailySummaryModel, _$identity);

  /// Serializes this DailySummaryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailySummaryModel &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.goalCount, goalCount) ||
                other.goalCount == goalCount) &&
            const DeepCollectionEquality()
                .equals(other.completedSdgs, completedSdgs) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.totalCo2Grams, totalCo2Grams) ||
                other.totalCo2Grams == totalCo2Grams) &&
            const DeepCollectionEquality()
                .equals(other.categoryCo2Grams, categoryCo2Grams) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      goalCount,
      const DeepCollectionEquality().hash(completedSdgs),
      totalPoints,
      totalCo2Grams,
      const DeepCollectionEquality().hash(categoryCo2Grams),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'DailySummaryModel(date: $date, goalCount: $goalCount, completedSdgs: $completedSdgs, totalPoints: $totalPoints, totalCo2Grams: $totalCo2Grams, categoryCo2Grams: $categoryCo2Grams, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $DailySummaryModelCopyWith<$Res> {
  factory $DailySummaryModelCopyWith(
          DailySummaryModel value, $Res Function(DailySummaryModel) _then) =
      _$DailySummaryModelCopyWithImpl;
  @useResult
  $Res call(
      {String date,
      int goalCount,
      List<int> completedSdgs,
      int totalPoints,
      int totalCo2Grams,
      Map<String, int> categoryCo2Grams,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$DailySummaryModelCopyWithImpl<$Res>
    implements $DailySummaryModelCopyWith<$Res> {
  _$DailySummaryModelCopyWithImpl(this._self, this._then);

  final DailySummaryModel _self;
  final $Res Function(DailySummaryModel) _then;

  /// Create a copy of DailySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? goalCount = null,
    Object? completedSdgs = null,
    Object? totalPoints = null,
    Object? totalCo2Grams = null,
    Object? categoryCo2Grams = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      goalCount: null == goalCount
          ? _self.goalCount
          : goalCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedSdgs: null == completedSdgs
          ? _self.completedSdgs
          : completedSdgs // ignore: cast_nullable_to_non_nullable
              as List<int>,
      totalPoints: null == totalPoints
          ? _self.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      totalCo2Grams: null == totalCo2Grams
          ? _self.totalCo2Grams
          : totalCo2Grams // ignore: cast_nullable_to_non_nullable
              as int,
      categoryCo2Grams: null == categoryCo2Grams
          ? _self.categoryCo2Grams
          : categoryCo2Grams // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DailySummaryModel].
extension DailySummaryModelPatterns on DailySummaryModel {
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
    TResult Function(_DailySummaryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailySummaryModel() when $default != null:
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
    TResult Function(_DailySummaryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySummaryModel():
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
    TResult? Function(_DailySummaryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySummaryModel() when $default != null:
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
    TResult Function(
            String date,
            int goalCount,
            List<int> completedSdgs,
            int totalPoints,
            int totalCo2Grams,
            Map<String, int> categoryCo2Grams,
            @TimestampConverter() DateTime? createdAt,
            @TimestampConverter() DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailySummaryModel() when $default != null:
        return $default(
            _that.date,
            _that.goalCount,
            _that.completedSdgs,
            _that.totalPoints,
            _that.totalCo2Grams,
            _that.categoryCo2Grams,
            _that.createdAt,
            _that.updatedAt);
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
    TResult Function(
            String date,
            int goalCount,
            List<int> completedSdgs,
            int totalPoints,
            int totalCo2Grams,
            Map<String, int> categoryCo2Grams,
            @TimestampConverter() DateTime? createdAt,
            @TimestampConverter() DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySummaryModel():
        return $default(
            _that.date,
            _that.goalCount,
            _that.completedSdgs,
            _that.totalPoints,
            _that.totalCo2Grams,
            _that.categoryCo2Grams,
            _that.createdAt,
            _that.updatedAt);
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
    TResult? Function(
            String date,
            int goalCount,
            List<int> completedSdgs,
            int totalPoints,
            int totalCo2Grams,
            Map<String, int> categoryCo2Grams,
            @TimestampConverter() DateTime? createdAt,
            @TimestampConverter() DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySummaryModel() when $default != null:
        return $default(
            _that.date,
            _that.goalCount,
            _that.completedSdgs,
            _that.totalPoints,
            _that.totalCo2Grams,
            _that.categoryCo2Grams,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DailySummaryModel implements DailySummaryModel {
  const _DailySummaryModel(
      {required this.date,
      this.goalCount = 0,
      final List<int> completedSdgs = const [],
      this.totalPoints = 0,
      this.totalCo2Grams = 0,
      final Map<String, int> categoryCo2Grams = const <String, int>{},
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt})
      : _completedSdgs = completedSdgs,
        _categoryCo2Grams = categoryCo2Grams;
  factory _DailySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryModelFromJson(json);

  /// Date string in YYYY-MM-DD format (document ID)
  @override
  final String date;

  /// Number of goals completed today
  @override
  @JsonKey()
  final int goalCount;

  /// List of completed SDG numbers (1-17, deduplicated)
  final List<int> _completedSdgs;

  /// List of completed SDG numbers (1-17, deduplicated)
  @override
  @JsonKey()
  List<int> get completedSdgs {
    if (_completedSdgs is EqualUnmodifiableListView) return _completedSdgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedSdgs);
  }

  /// Total points earned today
  @override
  @JsonKey()
  final int totalPoints;

  /// Total CO2 saved in grams today
  @override
  @JsonKey()
  final int totalCo2Grams;

  /// CO2 saved in grams today, broken down by action category.
  /// Stored as a flat dotted-path field map in Firestore so partial
  /// updates work via FieldValue.increment on a specific key
  /// (e.g., `categoryCo2Grams.transport`).
  final Map<String, int> _categoryCo2Grams;

  /// CO2 saved in grams today, broken down by action category.
  /// Stored as a flat dotted-path field map in Firestore so partial
  /// updates work via FieldValue.increment on a specific key
  /// (e.g., `categoryCo2Grams.transport`).
  @override
  @JsonKey()
  Map<String, int> get categoryCo2Grams {
    if (_categoryCo2Grams is EqualUnmodifiableMapView) return _categoryCo2Grams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryCo2Grams);
  }

  /// When this summary was created
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  /// When this summary was last updated
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  /// Create a copy of DailySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DailySummaryModelCopyWith<_DailySummaryModel> get copyWith =>
      __$DailySummaryModelCopyWithImpl<_DailySummaryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DailySummaryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DailySummaryModel &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.goalCount, goalCount) ||
                other.goalCount == goalCount) &&
            const DeepCollectionEquality()
                .equals(other._completedSdgs, _completedSdgs) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.totalCo2Grams, totalCo2Grams) ||
                other.totalCo2Grams == totalCo2Grams) &&
            const DeepCollectionEquality()
                .equals(other._categoryCo2Grams, _categoryCo2Grams) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      goalCount,
      const DeepCollectionEquality().hash(_completedSdgs),
      totalPoints,
      totalCo2Grams,
      const DeepCollectionEquality().hash(_categoryCo2Grams),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'DailySummaryModel(date: $date, goalCount: $goalCount, completedSdgs: $completedSdgs, totalPoints: $totalPoints, totalCo2Grams: $totalCo2Grams, categoryCo2Grams: $categoryCo2Grams, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$DailySummaryModelCopyWith<$Res>
    implements $DailySummaryModelCopyWith<$Res> {
  factory _$DailySummaryModelCopyWith(
          _DailySummaryModel value, $Res Function(_DailySummaryModel) _then) =
      __$DailySummaryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String date,
      int goalCount,
      List<int> completedSdgs,
      int totalPoints,
      int totalCo2Grams,
      Map<String, int> categoryCo2Grams,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$DailySummaryModelCopyWithImpl<$Res>
    implements _$DailySummaryModelCopyWith<$Res> {
  __$DailySummaryModelCopyWithImpl(this._self, this._then);

  final _DailySummaryModel _self;
  final $Res Function(_DailySummaryModel) _then;

  /// Create a copy of DailySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? goalCount = null,
    Object? completedSdgs = null,
    Object? totalPoints = null,
    Object? totalCo2Grams = null,
    Object? categoryCo2Grams = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_DailySummaryModel(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      goalCount: null == goalCount
          ? _self.goalCount
          : goalCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedSdgs: null == completedSdgs
          ? _self._completedSdgs
          : completedSdgs // ignore: cast_nullable_to_non_nullable
              as List<int>,
      totalPoints: null == totalPoints
          ? _self.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      totalCo2Grams: null == totalCo2Grams
          ? _self.totalCo2Grams
          : totalCo2Grams // ignore: cast_nullable_to_non_nullable
              as int,
      categoryCo2Grams: null == categoryCo2Grams
          ? _self._categoryCo2Grams
          : categoryCo2Grams // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
