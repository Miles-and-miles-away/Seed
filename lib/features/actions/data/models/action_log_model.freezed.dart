// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionLogModel {
  String get id;
  String get actionId;
  String get actionName;
  String get category;
  int get points;
  @RequiredTimestampConverter()
  DateTime get loggedAt;
  int get co2Grams;
  String? get note;
  List<String> get relatedSdgs;

  /// Create a copy of ActionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActionLogModelCopyWith<ActionLogModel> get copyWith =>
      _$ActionLogModelCopyWithImpl<ActionLogModel>(
          this as ActionLogModel, _$identity);

  /// Serializes this ActionLogModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActionLogModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionId, actionId) ||
                other.actionId == actionId) &&
            (identical(other.actionName, actionName) ||
                other.actionName == actionName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.co2Grams, co2Grams) ||
                other.co2Grams == co2Grams) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality()
                .equals(other.relatedSdgs, relatedSdgs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      actionId,
      actionName,
      category,
      points,
      loggedAt,
      co2Grams,
      note,
      const DeepCollectionEquality().hash(relatedSdgs));

  @override
  String toString() {
    return 'ActionLogModel(id: $id, actionId: $actionId, actionName: $actionName, category: $category, points: $points, loggedAt: $loggedAt, co2Grams: $co2Grams, note: $note, relatedSdgs: $relatedSdgs)';
  }
}

/// @nodoc
abstract mixin class $ActionLogModelCopyWith<$Res> {
  factory $ActionLogModelCopyWith(
          ActionLogModel value, $Res Function(ActionLogModel) _then) =
      _$ActionLogModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String actionId,
      String actionName,
      String category,
      int points,
      @RequiredTimestampConverter() DateTime loggedAt,
      int co2Grams,
      String? note,
      List<String> relatedSdgs});
}

/// @nodoc
class _$ActionLogModelCopyWithImpl<$Res>
    implements $ActionLogModelCopyWith<$Res> {
  _$ActionLogModelCopyWithImpl(this._self, this._then);

  final ActionLogModel _self;
  final $Res Function(ActionLogModel) _then;

  /// Create a copy of ActionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actionId = null,
    Object? actionName = null,
    Object? category = null,
    Object? points = null,
    Object? loggedAt = null,
    Object? co2Grams = null,
    Object? note = freezed,
    Object? relatedSdgs = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actionId: null == actionId
          ? _self.actionId
          : actionId // ignore: cast_nullable_to_non_nullable
              as String,
      actionName: null == actionName
          ? _self.actionName
          : actionName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      loggedAt: null == loggedAt
          ? _self.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      co2Grams: null == co2Grams
          ? _self.co2Grams
          : co2Grams // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedSdgs: null == relatedSdgs
          ? _self.relatedSdgs
          : relatedSdgs // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActionLogModel].
extension ActionLogModelPatterns on ActionLogModel {
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
    TResult Function(_ActionLogModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActionLogModel() when $default != null:
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
    TResult Function(_ActionLogModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActionLogModel():
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
    TResult? Function(_ActionLogModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActionLogModel() when $default != null:
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
            String actionId,
            String actionName,
            String category,
            int points,
            @RequiredTimestampConverter() DateTime loggedAt,
            int co2Grams,
            String? note,
            List<String> relatedSdgs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActionLogModel() when $default != null:
        return $default(
            _that.id,
            _that.actionId,
            _that.actionName,
            _that.category,
            _that.points,
            _that.loggedAt,
            _that.co2Grams,
            _that.note,
            _that.relatedSdgs);
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
            String actionId,
            String actionName,
            String category,
            int points,
            @RequiredTimestampConverter() DateTime loggedAt,
            int co2Grams,
            String? note,
            List<String> relatedSdgs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActionLogModel():
        return $default(
            _that.id,
            _that.actionId,
            _that.actionName,
            _that.category,
            _that.points,
            _that.loggedAt,
            _that.co2Grams,
            _that.note,
            _that.relatedSdgs);
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
            String actionId,
            String actionName,
            String category,
            int points,
            @RequiredTimestampConverter() DateTime loggedAt,
            int co2Grams,
            String? note,
            List<String> relatedSdgs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActionLogModel() when $default != null:
        return $default(
            _that.id,
            _that.actionId,
            _that.actionName,
            _that.category,
            _that.points,
            _that.loggedAt,
            _that.co2Grams,
            _that.note,
            _that.relatedSdgs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActionLogModel implements ActionLogModel {
  const _ActionLogModel(
      {required this.id,
      required this.actionId,
      required this.actionName,
      required this.category,
      required this.points,
      @RequiredTimestampConverter() required this.loggedAt,
      this.co2Grams = 0,
      this.note,
      final List<String> relatedSdgs = const []})
      : _relatedSdgs = relatedSdgs;
  factory _ActionLogModel.fromJson(Map<String, dynamic> json) =>
      _$ActionLogModelFromJson(json);

  @override
  final String id;
  @override
  final String actionId;
  @override
  final String actionName;
  @override
  final String category;
  @override
  final int points;
  @override
  @RequiredTimestampConverter()
  final DateTime loggedAt;
  @override
  @JsonKey()
  final int co2Grams;
  @override
  final String? note;
  final List<String> _relatedSdgs;
  @override
  @JsonKey()
  List<String> get relatedSdgs {
    if (_relatedSdgs is EqualUnmodifiableListView) return _relatedSdgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedSdgs);
  }

  /// Create a copy of ActionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActionLogModelCopyWith<_ActionLogModel> get copyWith =>
      __$ActionLogModelCopyWithImpl<_ActionLogModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActionLogModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActionLogModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionId, actionId) ||
                other.actionId == actionId) &&
            (identical(other.actionName, actionName) ||
                other.actionName == actionName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.co2Grams, co2Grams) ||
                other.co2Grams == co2Grams) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality()
                .equals(other._relatedSdgs, _relatedSdgs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      actionId,
      actionName,
      category,
      points,
      loggedAt,
      co2Grams,
      note,
      const DeepCollectionEquality().hash(_relatedSdgs));

  @override
  String toString() {
    return 'ActionLogModel(id: $id, actionId: $actionId, actionName: $actionName, category: $category, points: $points, loggedAt: $loggedAt, co2Grams: $co2Grams, note: $note, relatedSdgs: $relatedSdgs)';
  }
}

/// @nodoc
abstract mixin class _$ActionLogModelCopyWith<$Res>
    implements $ActionLogModelCopyWith<$Res> {
  factory _$ActionLogModelCopyWith(
          _ActionLogModel value, $Res Function(_ActionLogModel) _then) =
      __$ActionLogModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String actionId,
      String actionName,
      String category,
      int points,
      @RequiredTimestampConverter() DateTime loggedAt,
      int co2Grams,
      String? note,
      List<String> relatedSdgs});
}

/// @nodoc
class __$ActionLogModelCopyWithImpl<$Res>
    implements _$ActionLogModelCopyWith<$Res> {
  __$ActionLogModelCopyWithImpl(this._self, this._then);

  final _ActionLogModel _self;
  final $Res Function(_ActionLogModel) _then;

  /// Create a copy of ActionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? actionId = null,
    Object? actionName = null,
    Object? category = null,
    Object? points = null,
    Object? loggedAt = null,
    Object? co2Grams = null,
    Object? note = freezed,
    Object? relatedSdgs = null,
  }) {
    return _then(_ActionLogModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actionId: null == actionId
          ? _self.actionId
          : actionId // ignore: cast_nullable_to_non_nullable
              as String,
      actionName: null == actionName
          ? _self.actionName
          : actionName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      loggedAt: null == loggedAt
          ? _self.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      co2Grams: null == co2Grams
          ? _self.co2Grams
          : co2Grams // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedSdgs: null == relatedSdgs
          ? _self._relatedSdgs
          : relatedSdgs // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
