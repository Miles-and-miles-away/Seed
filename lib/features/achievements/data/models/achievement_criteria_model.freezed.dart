// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievement_criteria_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AchievementCriteria _$AchievementCriteriaFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'actionCount':
      return ActionCountCriteria.fromJson(json);
    case 'streakDays':
      return StreakDaysCriteria.fromJson(json);
    case 'levelReached':
      return LevelReachedCriteria.fromJson(json);
    case 'sdgCount':
      return SdgCountCriteria.fromJson(json);
    case 'co2Saved':
      return Co2SavedCriteria.fromJson(json);
    case 'categoriesCovered':
      return CategoriesCoveredCriteria.fromJson(json);
    case 'special':
      return SpecialCriteria.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'type', 'AchievementCriteria',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$AchievementCriteria {
  /// Serializes this AchievementCriteria to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AchievementCriteria);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AchievementCriteria()';
  }
}

/// @nodoc
class $AchievementCriteriaCopyWith<$Res> {
  $AchievementCriteriaCopyWith(
      AchievementCriteria _, $Res Function(AchievementCriteria) __);
}

/// Adds pattern-matching-related methods to [AchievementCriteria].
extension AchievementCriteriaPatterns on AchievementCriteria {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActionCountCriteria value)? actionCount,
    TResult Function(StreakDaysCriteria value)? streakDays,
    TResult Function(LevelReachedCriteria value)? levelReached,
    TResult Function(SdgCountCriteria value)? sdgCount,
    TResult Function(Co2SavedCriteria value)? co2Saved,
    TResult Function(CategoriesCoveredCriteria value)? categoriesCovered,
    TResult Function(SpecialCriteria value)? special,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ActionCountCriteria() when actionCount != null:
        return actionCount(_that);
      case StreakDaysCriteria() when streakDays != null:
        return streakDays(_that);
      case LevelReachedCriteria() when levelReached != null:
        return levelReached(_that);
      case SdgCountCriteria() when sdgCount != null:
        return sdgCount(_that);
      case Co2SavedCriteria() when co2Saved != null:
        return co2Saved(_that);
      case CategoriesCoveredCriteria() when categoriesCovered != null:
        return categoriesCovered(_that);
      case SpecialCriteria() when special != null:
        return special(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(ActionCountCriteria value) actionCount,
    required TResult Function(StreakDaysCriteria value) streakDays,
    required TResult Function(LevelReachedCriteria value) levelReached,
    required TResult Function(SdgCountCriteria value) sdgCount,
    required TResult Function(Co2SavedCriteria value) co2Saved,
    required TResult Function(CategoriesCoveredCriteria value)
        categoriesCovered,
    required TResult Function(SpecialCriteria value) special,
  }) {
    final _that = this;
    switch (_that) {
      case ActionCountCriteria():
        return actionCount(_that);
      case StreakDaysCriteria():
        return streakDays(_that);
      case LevelReachedCriteria():
        return levelReached(_that);
      case SdgCountCriteria():
        return sdgCount(_that);
      case Co2SavedCriteria():
        return co2Saved(_that);
      case CategoriesCoveredCriteria():
        return categoriesCovered(_that);
      case SpecialCriteria():
        return special(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActionCountCriteria value)? actionCount,
    TResult? Function(StreakDaysCriteria value)? streakDays,
    TResult? Function(LevelReachedCriteria value)? levelReached,
    TResult? Function(SdgCountCriteria value)? sdgCount,
    TResult? Function(Co2SavedCriteria value)? co2Saved,
    TResult? Function(CategoriesCoveredCriteria value)? categoriesCovered,
    TResult? Function(SpecialCriteria value)? special,
  }) {
    final _that = this;
    switch (_that) {
      case ActionCountCriteria() when actionCount != null:
        return actionCount(_that);
      case StreakDaysCriteria() when streakDays != null:
        return streakDays(_that);
      case LevelReachedCriteria() when levelReached != null:
        return levelReached(_that);
      case SdgCountCriteria() when sdgCount != null:
        return sdgCount(_that);
      case Co2SavedCriteria() when co2Saved != null:
        return co2Saved(_that);
      case CategoriesCoveredCriteria() when categoriesCovered != null:
        return categoriesCovered(_that);
      case SpecialCriteria() when special != null:
        return special(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int count, String? category)? actionCount,
    TResult Function(int days)? streakDays,
    TResult Function(int level)? levelReached,
    TResult Function(int count)? sdgCount,
    TResult Function(int grams)? co2Saved,
    TResult Function(int count)? categoriesCovered,
    TResult Function(String specialType)? special,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ActionCountCriteria() when actionCount != null:
        return actionCount(_that.count, _that.category);
      case StreakDaysCriteria() when streakDays != null:
        return streakDays(_that.days);
      case LevelReachedCriteria() when levelReached != null:
        return levelReached(_that.level);
      case SdgCountCriteria() when sdgCount != null:
        return sdgCount(_that.count);
      case Co2SavedCriteria() when co2Saved != null:
        return co2Saved(_that.grams);
      case CategoriesCoveredCriteria() when categoriesCovered != null:
        return categoriesCovered(_that.count);
      case SpecialCriteria() when special != null:
        return special(_that.specialType);
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
  TResult when<TResult extends Object?>({
    required TResult Function(int count, String? category) actionCount,
    required TResult Function(int days) streakDays,
    required TResult Function(int level) levelReached,
    required TResult Function(int count) sdgCount,
    required TResult Function(int grams) co2Saved,
    required TResult Function(int count) categoriesCovered,
    required TResult Function(String specialType) special,
  }) {
    final _that = this;
    switch (_that) {
      case ActionCountCriteria():
        return actionCount(_that.count, _that.category);
      case StreakDaysCriteria():
        return streakDays(_that.days);
      case LevelReachedCriteria():
        return levelReached(_that.level);
      case SdgCountCriteria():
        return sdgCount(_that.count);
      case Co2SavedCriteria():
        return co2Saved(_that.grams);
      case CategoriesCoveredCriteria():
        return categoriesCovered(_that.count);
      case SpecialCriteria():
        return special(_that.specialType);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int count, String? category)? actionCount,
    TResult? Function(int days)? streakDays,
    TResult? Function(int level)? levelReached,
    TResult? Function(int count)? sdgCount,
    TResult? Function(int grams)? co2Saved,
    TResult? Function(int count)? categoriesCovered,
    TResult? Function(String specialType)? special,
  }) {
    final _that = this;
    switch (_that) {
      case ActionCountCriteria() when actionCount != null:
        return actionCount(_that.count, _that.category);
      case StreakDaysCriteria() when streakDays != null:
        return streakDays(_that.days);
      case LevelReachedCriteria() when levelReached != null:
        return levelReached(_that.level);
      case SdgCountCriteria() when sdgCount != null:
        return sdgCount(_that.count);
      case Co2SavedCriteria() when co2Saved != null:
        return co2Saved(_that.grams);
      case CategoriesCoveredCriteria() when categoriesCovered != null:
        return categoriesCovered(_that.count);
      case SpecialCriteria() when special != null:
        return special(_that.specialType);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class ActionCountCriteria implements AchievementCriteria {
  const ActionCountCriteria(
      {required this.count, this.category, final String? $type})
      : $type = $type ?? 'actionCount';
  factory ActionCountCriteria.fromJson(Map<String, dynamic> json) =>
      _$ActionCountCriteriaFromJson(json);

  final int count;
  final String? category;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActionCountCriteriaCopyWith<ActionCountCriteria> get copyWith =>
      _$ActionCountCriteriaCopyWithImpl<ActionCountCriteria>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActionCountCriteriaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActionCountCriteria &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count, category);

  @override
  String toString() {
    return 'AchievementCriteria.actionCount(count: $count, category: $category)';
  }
}

/// @nodoc
abstract mixin class $ActionCountCriteriaCopyWith<$Res>
    implements $AchievementCriteriaCopyWith<$Res> {
  factory $ActionCountCriteriaCopyWith(
          ActionCountCriteria value, $Res Function(ActionCountCriteria) _then) =
      _$ActionCountCriteriaCopyWithImpl;
  @useResult
  $Res call({int count, String? category});
}

/// @nodoc
class _$ActionCountCriteriaCopyWithImpl<$Res>
    implements $ActionCountCriteriaCopyWith<$Res> {
  _$ActionCountCriteriaCopyWithImpl(this._self, this._then);

  final ActionCountCriteria _self;
  final $Res Function(ActionCountCriteria) _then;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
    Object? category = freezed,
  }) {
    return _then(ActionCountCriteria(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class StreakDaysCriteria implements AchievementCriteria {
  const StreakDaysCriteria({required this.days, final String? $type})
      : $type = $type ?? 'streakDays';
  factory StreakDaysCriteria.fromJson(Map<String, dynamic> json) =>
      _$StreakDaysCriteriaFromJson(json);

  final int days;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StreakDaysCriteriaCopyWith<StreakDaysCriteria> get copyWith =>
      _$StreakDaysCriteriaCopyWithImpl<StreakDaysCriteria>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StreakDaysCriteriaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StreakDaysCriteria &&
            (identical(other.days, days) || other.days == days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, days);

  @override
  String toString() {
    return 'AchievementCriteria.streakDays(days: $days)';
  }
}

/// @nodoc
abstract mixin class $StreakDaysCriteriaCopyWith<$Res>
    implements $AchievementCriteriaCopyWith<$Res> {
  factory $StreakDaysCriteriaCopyWith(
          StreakDaysCriteria value, $Res Function(StreakDaysCriteria) _then) =
      _$StreakDaysCriteriaCopyWithImpl;
  @useResult
  $Res call({int days});
}

/// @nodoc
class _$StreakDaysCriteriaCopyWithImpl<$Res>
    implements $StreakDaysCriteriaCopyWith<$Res> {
  _$StreakDaysCriteriaCopyWithImpl(this._self, this._then);

  final StreakDaysCriteria _self;
  final $Res Function(StreakDaysCriteria) _then;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? days = null,
  }) {
    return _then(StreakDaysCriteria(
      days: null == days
          ? _self.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class LevelReachedCriteria implements AchievementCriteria {
  const LevelReachedCriteria({required this.level, final String? $type})
      : $type = $type ?? 'levelReached';
  factory LevelReachedCriteria.fromJson(Map<String, dynamic> json) =>
      _$LevelReachedCriteriaFromJson(json);

  final int level;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LevelReachedCriteriaCopyWith<LevelReachedCriteria> get copyWith =>
      _$LevelReachedCriteriaCopyWithImpl<LevelReachedCriteria>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LevelReachedCriteriaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LevelReachedCriteria &&
            (identical(other.level, level) || other.level == level));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level);

  @override
  String toString() {
    return 'AchievementCriteria.levelReached(level: $level)';
  }
}

/// @nodoc
abstract mixin class $LevelReachedCriteriaCopyWith<$Res>
    implements $AchievementCriteriaCopyWith<$Res> {
  factory $LevelReachedCriteriaCopyWith(LevelReachedCriteria value,
          $Res Function(LevelReachedCriteria) _then) =
      _$LevelReachedCriteriaCopyWithImpl;
  @useResult
  $Res call({int level});
}

/// @nodoc
class _$LevelReachedCriteriaCopyWithImpl<$Res>
    implements $LevelReachedCriteriaCopyWith<$Res> {
  _$LevelReachedCriteriaCopyWithImpl(this._self, this._then);

  final LevelReachedCriteria _self;
  final $Res Function(LevelReachedCriteria) _then;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? level = null,
  }) {
    return _then(LevelReachedCriteria(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class SdgCountCriteria implements AchievementCriteria {
  const SdgCountCriteria({required this.count, final String? $type})
      : $type = $type ?? 'sdgCount';
  factory SdgCountCriteria.fromJson(Map<String, dynamic> json) =>
      _$SdgCountCriteriaFromJson(json);

  final int count;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SdgCountCriteriaCopyWith<SdgCountCriteria> get copyWith =>
      _$SdgCountCriteriaCopyWithImpl<SdgCountCriteria>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SdgCountCriteriaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SdgCountCriteria &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count);

  @override
  String toString() {
    return 'AchievementCriteria.sdgCount(count: $count)';
  }
}

/// @nodoc
abstract mixin class $SdgCountCriteriaCopyWith<$Res>
    implements $AchievementCriteriaCopyWith<$Res> {
  factory $SdgCountCriteriaCopyWith(
          SdgCountCriteria value, $Res Function(SdgCountCriteria) _then) =
      _$SdgCountCriteriaCopyWithImpl;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$SdgCountCriteriaCopyWithImpl<$Res>
    implements $SdgCountCriteriaCopyWith<$Res> {
  _$SdgCountCriteriaCopyWithImpl(this._self, this._then);

  final SdgCountCriteria _self;
  final $Res Function(SdgCountCriteria) _then;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
  }) {
    return _then(SdgCountCriteria(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class Co2SavedCriteria implements AchievementCriteria {
  const Co2SavedCriteria({required this.grams, final String? $type})
      : $type = $type ?? 'co2Saved';
  factory Co2SavedCriteria.fromJson(Map<String, dynamic> json) =>
      _$Co2SavedCriteriaFromJson(json);

  final int grams;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Co2SavedCriteriaCopyWith<Co2SavedCriteria> get copyWith =>
      _$Co2SavedCriteriaCopyWithImpl<Co2SavedCriteria>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$Co2SavedCriteriaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Co2SavedCriteria &&
            (identical(other.grams, grams) || other.grams == grams));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, grams);

  @override
  String toString() {
    return 'AchievementCriteria.co2Saved(grams: $grams)';
  }
}

/// @nodoc
abstract mixin class $Co2SavedCriteriaCopyWith<$Res>
    implements $AchievementCriteriaCopyWith<$Res> {
  factory $Co2SavedCriteriaCopyWith(
          Co2SavedCriteria value, $Res Function(Co2SavedCriteria) _then) =
      _$Co2SavedCriteriaCopyWithImpl;
  @useResult
  $Res call({int grams});
}

/// @nodoc
class _$Co2SavedCriteriaCopyWithImpl<$Res>
    implements $Co2SavedCriteriaCopyWith<$Res> {
  _$Co2SavedCriteriaCopyWithImpl(this._self, this._then);

  final Co2SavedCriteria _self;
  final $Res Function(Co2SavedCriteria) _then;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? grams = null,
  }) {
    return _then(Co2SavedCriteria(
      grams: null == grams
          ? _self.grams
          : grams // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class CategoriesCoveredCriteria implements AchievementCriteria {
  const CategoriesCoveredCriteria({required this.count, final String? $type})
      : $type = $type ?? 'categoriesCovered';
  factory CategoriesCoveredCriteria.fromJson(Map<String, dynamic> json) =>
      _$CategoriesCoveredCriteriaFromJson(json);

  final int count;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoriesCoveredCriteriaCopyWith<CategoriesCoveredCriteria> get copyWith =>
      _$CategoriesCoveredCriteriaCopyWithImpl<CategoriesCoveredCriteria>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoriesCoveredCriteriaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoriesCoveredCriteria &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count);

  @override
  String toString() {
    return 'AchievementCriteria.categoriesCovered(count: $count)';
  }
}

/// @nodoc
abstract mixin class $CategoriesCoveredCriteriaCopyWith<$Res>
    implements $AchievementCriteriaCopyWith<$Res> {
  factory $CategoriesCoveredCriteriaCopyWith(CategoriesCoveredCriteria value,
          $Res Function(CategoriesCoveredCriteria) _then) =
      _$CategoriesCoveredCriteriaCopyWithImpl;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$CategoriesCoveredCriteriaCopyWithImpl<$Res>
    implements $CategoriesCoveredCriteriaCopyWith<$Res> {
  _$CategoriesCoveredCriteriaCopyWithImpl(this._self, this._then);

  final CategoriesCoveredCriteria _self;
  final $Res Function(CategoriesCoveredCriteria) _then;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
  }) {
    return _then(CategoriesCoveredCriteria(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class SpecialCriteria implements AchievementCriteria {
  const SpecialCriteria({required this.specialType, final String? $type})
      : $type = $type ?? 'special';
  factory SpecialCriteria.fromJson(Map<String, dynamic> json) =>
      _$SpecialCriteriaFromJson(json);

  final String specialType;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpecialCriteriaCopyWith<SpecialCriteria> get copyWith =>
      _$SpecialCriteriaCopyWithImpl<SpecialCriteria>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpecialCriteriaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpecialCriteria &&
            (identical(other.specialType, specialType) ||
                other.specialType == specialType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, specialType);

  @override
  String toString() {
    return 'AchievementCriteria.special(specialType: $specialType)';
  }
}

/// @nodoc
abstract mixin class $SpecialCriteriaCopyWith<$Res>
    implements $AchievementCriteriaCopyWith<$Res> {
  factory $SpecialCriteriaCopyWith(
          SpecialCriteria value, $Res Function(SpecialCriteria) _then) =
      _$SpecialCriteriaCopyWithImpl;
  @useResult
  $Res call({String specialType});
}

/// @nodoc
class _$SpecialCriteriaCopyWithImpl<$Res>
    implements $SpecialCriteriaCopyWith<$Res> {
  _$SpecialCriteriaCopyWithImpl(this._self, this._then);

  final SpecialCriteria _self;
  final $Res Function(SpecialCriteria) _then;

  /// Create a copy of AchievementCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? specialType = null,
  }) {
    return _then(SpecialCriteria(
      specialType: null == specialType
          ? _self.specialType
          : specialType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
