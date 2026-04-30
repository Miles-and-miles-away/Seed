// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mascot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MascotModel {
  /// Unique mascot instance ID.
  String get id;

  /// The species ID of the mascot (e.g., "seed").
  String get speciesId;

  /// The user-given name for the mascot.
  String get name;

  /// Points earned by this mascot for its evolution.
  int get mascotPoints;

  /// Level computed from mascotPoints.
  int get mascotLevel;

  /// Whether this mascot has reached max evolution (level >= 50).
  bool get isFullyEvolved;

  /// List of equipped cosmetic item IDs.
  List<String> get equippedItems;

  /// When this mascot was created.
  @TimestampConverter()
  DateTime? get createdAt;

  /// The last seen evolution stage (to detect new evolutions).
  int get lastSeenStage;

  /// Create a copy of MascotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MascotModelCopyWith<MascotModel> get copyWith =>
      _$MascotModelCopyWithImpl<MascotModel>(this as MascotModel, _$identity);

  /// Serializes this MascotModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MascotModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.speciesId, speciesId) ||
                other.speciesId == speciesId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mascotPoints, mascotPoints) ||
                other.mascotPoints == mascotPoints) &&
            (identical(other.mascotLevel, mascotLevel) ||
                other.mascotLevel == mascotLevel) &&
            (identical(other.isFullyEvolved, isFullyEvolved) ||
                other.isFullyEvolved == isFullyEvolved) &&
            const DeepCollectionEquality()
                .equals(other.equippedItems, equippedItems) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSeenStage, lastSeenStage) ||
                other.lastSeenStage == lastSeenStage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      speciesId,
      name,
      mascotPoints,
      mascotLevel,
      isFullyEvolved,
      const DeepCollectionEquality().hash(equippedItems),
      createdAt,
      lastSeenStage);

  @override
  String toString() {
    return 'MascotModel(id: $id, speciesId: $speciesId, name: $name, mascotPoints: $mascotPoints, mascotLevel: $mascotLevel, isFullyEvolved: $isFullyEvolved, equippedItems: $equippedItems, createdAt: $createdAt, lastSeenStage: $lastSeenStage)';
  }
}

/// @nodoc
abstract mixin class $MascotModelCopyWith<$Res> {
  factory $MascotModelCopyWith(
          MascotModel value, $Res Function(MascotModel) _then) =
      _$MascotModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String speciesId,
      String name,
      int mascotPoints,
      int mascotLevel,
      bool isFullyEvolved,
      List<String> equippedItems,
      @TimestampConverter() DateTime? createdAt,
      int lastSeenStage});
}

/// @nodoc
class _$MascotModelCopyWithImpl<$Res> implements $MascotModelCopyWith<$Res> {
  _$MascotModelCopyWithImpl(this._self, this._then);

  final MascotModel _self;
  final $Res Function(MascotModel) _then;

  /// Create a copy of MascotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? speciesId = null,
    Object? name = null,
    Object? mascotPoints = null,
    Object? mascotLevel = null,
    Object? isFullyEvolved = null,
    Object? equippedItems = null,
    Object? createdAt = freezed,
    Object? lastSeenStage = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      speciesId: null == speciesId
          ? _self.speciesId
          : speciesId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mascotPoints: null == mascotPoints
          ? _self.mascotPoints
          : mascotPoints // ignore: cast_nullable_to_non_nullable
              as int,
      mascotLevel: null == mascotLevel
          ? _self.mascotLevel
          : mascotLevel // ignore: cast_nullable_to_non_nullable
              as int,
      isFullyEvolved: null == isFullyEvolved
          ? _self.isFullyEvolved
          : isFullyEvolved // ignore: cast_nullable_to_non_nullable
              as bool,
      equippedItems: null == equippedItems
          ? _self.equippedItems
          : equippedItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSeenStage: null == lastSeenStage
          ? _self.lastSeenStage
          : lastSeenStage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MascotModel].
extension MascotModelPatterns on MascotModel {
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
    TResult Function(_MascotModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MascotModel() when $default != null:
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
    TResult Function(_MascotModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MascotModel():
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
    TResult? Function(_MascotModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MascotModel() when $default != null:
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
            String id,
            String speciesId,
            String name,
            int mascotPoints,
            int mascotLevel,
            bool isFullyEvolved,
            List<String> equippedItems,
            @TimestampConverter() DateTime? createdAt,
            int lastSeenStage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MascotModel() when $default != null:
        return $default(
            _that.id,
            _that.speciesId,
            _that.name,
            _that.mascotPoints,
            _that.mascotLevel,
            _that.isFullyEvolved,
            _that.equippedItems,
            _that.createdAt,
            _that.lastSeenStage);
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
            String id,
            String speciesId,
            String name,
            int mascotPoints,
            int mascotLevel,
            bool isFullyEvolved,
            List<String> equippedItems,
            @TimestampConverter() DateTime? createdAt,
            int lastSeenStage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MascotModel():
        return $default(
            _that.id,
            _that.speciesId,
            _that.name,
            _that.mascotPoints,
            _that.mascotLevel,
            _that.isFullyEvolved,
            _that.equippedItems,
            _that.createdAt,
            _that.lastSeenStage);
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
            String id,
            String speciesId,
            String name,
            int mascotPoints,
            int mascotLevel,
            bool isFullyEvolved,
            List<String> equippedItems,
            @TimestampConverter() DateTime? createdAt,
            int lastSeenStage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MascotModel() when $default != null:
        return $default(
            _that.id,
            _that.speciesId,
            _that.name,
            _that.mascotPoints,
            _that.mascotLevel,
            _that.isFullyEvolved,
            _that.equippedItems,
            _that.createdAt,
            _that.lastSeenStage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MascotModel implements MascotModel {
  const _MascotModel(
      {required this.id,
      required this.speciesId,
      this.name = '',
      this.mascotPoints = 0,
      this.mascotLevel = 1,
      this.isFullyEvolved = false,
      final List<String> equippedItems = const [],
      @TimestampConverter() this.createdAt,
      this.lastSeenStage = 1})
      : _equippedItems = equippedItems;
  factory _MascotModel.fromJson(Map<String, dynamic> json) =>
      _$MascotModelFromJson(json);

  /// Unique mascot instance ID.
  @override
  final String id;

  /// The species ID of the mascot (e.g., "seed").
  @override
  final String speciesId;

  /// The user-given name for the mascot.
  @override
  @JsonKey()
  final String name;

  /// Points earned by this mascot for its evolution.
  @override
  @JsonKey()
  final int mascotPoints;

  /// Level computed from mascotPoints.
  @override
  @JsonKey()
  final int mascotLevel;

  /// Whether this mascot has reached max evolution (level >= 50).
  @override
  @JsonKey()
  final bool isFullyEvolved;

  /// List of equipped cosmetic item IDs.
  final List<String> _equippedItems;

  /// List of equipped cosmetic item IDs.
  @override
  @JsonKey()
  List<String> get equippedItems {
    if (_equippedItems is EqualUnmodifiableListView) return _equippedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equippedItems);
  }

  /// When this mascot was created.
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  /// The last seen evolution stage (to detect new evolutions).
  @override
  @JsonKey()
  final int lastSeenStage;

  /// Create a copy of MascotModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MascotModelCopyWith<_MascotModel> get copyWith =>
      __$MascotModelCopyWithImpl<_MascotModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MascotModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MascotModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.speciesId, speciesId) ||
                other.speciesId == speciesId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mascotPoints, mascotPoints) ||
                other.mascotPoints == mascotPoints) &&
            (identical(other.mascotLevel, mascotLevel) ||
                other.mascotLevel == mascotLevel) &&
            (identical(other.isFullyEvolved, isFullyEvolved) ||
                other.isFullyEvolved == isFullyEvolved) &&
            const DeepCollectionEquality()
                .equals(other._equippedItems, _equippedItems) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSeenStage, lastSeenStage) ||
                other.lastSeenStage == lastSeenStage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      speciesId,
      name,
      mascotPoints,
      mascotLevel,
      isFullyEvolved,
      const DeepCollectionEquality().hash(_equippedItems),
      createdAt,
      lastSeenStage);

  @override
  String toString() {
    return 'MascotModel(id: $id, speciesId: $speciesId, name: $name, mascotPoints: $mascotPoints, mascotLevel: $mascotLevel, isFullyEvolved: $isFullyEvolved, equippedItems: $equippedItems, createdAt: $createdAt, lastSeenStage: $lastSeenStage)';
  }
}

/// @nodoc
abstract mixin class _$MascotModelCopyWith<$Res>
    implements $MascotModelCopyWith<$Res> {
  factory _$MascotModelCopyWith(
          _MascotModel value, $Res Function(_MascotModel) _then) =
      __$MascotModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String speciesId,
      String name,
      int mascotPoints,
      int mascotLevel,
      bool isFullyEvolved,
      List<String> equippedItems,
      @TimestampConverter() DateTime? createdAt,
      int lastSeenStage});
}

/// @nodoc
class __$MascotModelCopyWithImpl<$Res> implements _$MascotModelCopyWith<$Res> {
  __$MascotModelCopyWithImpl(this._self, this._then);

  final _MascotModel _self;
  final $Res Function(_MascotModel) _then;

  /// Create a copy of MascotModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? speciesId = null,
    Object? name = null,
    Object? mascotPoints = null,
    Object? mascotLevel = null,
    Object? isFullyEvolved = null,
    Object? equippedItems = null,
    Object? createdAt = freezed,
    Object? lastSeenStage = null,
  }) {
    return _then(_MascotModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      speciesId: null == speciesId
          ? _self.speciesId
          : speciesId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mascotPoints: null == mascotPoints
          ? _self.mascotPoints
          : mascotPoints // ignore: cast_nullable_to_non_nullable
              as int,
      mascotLevel: null == mascotLevel
          ? _self.mascotLevel
          : mascotLevel // ignore: cast_nullable_to_non_nullable
              as int,
      isFullyEvolved: null == isFullyEvolved
          ? _self.isFullyEvolved
          : isFullyEvolved // ignore: cast_nullable_to_non_nullable
              as bool,
      equippedItems: null == equippedItems
          ? _self._equippedItems
          : equippedItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSeenStage: null == lastSeenStage
          ? _self.lastSeenStage
          : lastSeenStage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
