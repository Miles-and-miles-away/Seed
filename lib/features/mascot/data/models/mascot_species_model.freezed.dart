// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mascot_species_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MascotSpeciesModel {
  /// Unique identifier for the species (e.g., "seed").
  String get id;

  /// English name of the species.
  String get nameEn;

  /// Japanese name of the species.
  String get nameJa;

  /// English description of the species.
  String get descriptionEn;

  /// Japanese description of the species.
  String get descriptionJa;

  /// The evolution stages for this species, ordered by level threshold.
  List<EvolutionStageModel> get evolutionStages;

  /// Spanish name of the species.
  String get nameEs;

  /// Spanish description of the species.
  String get descriptionEs;

  /// Availability: 'free', 'premium', or a number (points cost to unlock).
  String get availability;

  /// Create a copy of MascotSpeciesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MascotSpeciesModelCopyWith<MascotSpeciesModel> get copyWith =>
      _$MascotSpeciesModelCopyWithImpl<MascotSpeciesModel>(
          this as MascotSpeciesModel, _$identity);

  /// Serializes this MascotSpeciesModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MascotSpeciesModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.nameJa, nameJa) || other.nameJa == nameJa) &&
            (identical(other.descriptionEn, descriptionEn) ||
                other.descriptionEn == descriptionEn) &&
            (identical(other.descriptionJa, descriptionJa) ||
                other.descriptionJa == descriptionJa) &&
            const DeepCollectionEquality()
                .equals(other.evolutionStages, evolutionStages) &&
            (identical(other.nameEs, nameEs) || other.nameEs == nameEs) &&
            (identical(other.descriptionEs, descriptionEs) ||
                other.descriptionEs == descriptionEs) &&
            (identical(other.availability, availability) ||
                other.availability == availability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nameEn,
      nameJa,
      descriptionEn,
      descriptionJa,
      const DeepCollectionEquality().hash(evolutionStages),
      nameEs,
      descriptionEs,
      availability);

  @override
  String toString() {
    return 'MascotSpeciesModel(id: $id, nameEn: $nameEn, nameJa: $nameJa, descriptionEn: $descriptionEn, descriptionJa: $descriptionJa, evolutionStages: $evolutionStages, nameEs: $nameEs, descriptionEs: $descriptionEs, availability: $availability)';
  }
}

/// @nodoc
abstract mixin class $MascotSpeciesModelCopyWith<$Res> {
  factory $MascotSpeciesModelCopyWith(
          MascotSpeciesModel value, $Res Function(MascotSpeciesModel) _then) =
      _$MascotSpeciesModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nameEn,
      String nameJa,
      String descriptionEn,
      String descriptionJa,
      List<EvolutionStageModel> evolutionStages,
      String nameEs,
      String descriptionEs,
      String availability});
}

/// @nodoc
class _$MascotSpeciesModelCopyWithImpl<$Res>
    implements $MascotSpeciesModelCopyWith<$Res> {
  _$MascotSpeciesModelCopyWithImpl(this._self, this._then);

  final MascotSpeciesModel _self;
  final $Res Function(MascotSpeciesModel) _then;

  /// Create a copy of MascotSpeciesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameEn = null,
    Object? nameJa = null,
    Object? descriptionEn = null,
    Object? descriptionJa = null,
    Object? evolutionStages = null,
    Object? nameEs = null,
    Object? descriptionEs = null,
    Object? availability = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _self.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      nameJa: null == nameJa
          ? _self.nameJa
          : nameJa // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionEn: null == descriptionEn
          ? _self.descriptionEn
          : descriptionEn // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionJa: null == descriptionJa
          ? _self.descriptionJa
          : descriptionJa // ignore: cast_nullable_to_non_nullable
              as String,
      evolutionStages: null == evolutionStages
          ? _self.evolutionStages
          : evolutionStages // ignore: cast_nullable_to_non_nullable
              as List<EvolutionStageModel>,
      nameEs: null == nameEs
          ? _self.nameEs
          : nameEs // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionEs: null == descriptionEs
          ? _self.descriptionEs
          : descriptionEs // ignore: cast_nullable_to_non_nullable
              as String,
      availability: null == availability
          ? _self.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [MascotSpeciesModel].
extension MascotSpeciesModelPatterns on MascotSpeciesModel {
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
    TResult Function(_MascotSpeciesModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MascotSpeciesModel() when $default != null:
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
    TResult Function(_MascotSpeciesModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MascotSpeciesModel():
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
    TResult? Function(_MascotSpeciesModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MascotSpeciesModel() when $default != null:
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
            String nameEn,
            String nameJa,
            String descriptionEn,
            String descriptionJa,
            List<EvolutionStageModel> evolutionStages,
            String nameEs,
            String descriptionEs,
            String availability)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MascotSpeciesModel() when $default != null:
        return $default(
            _that.id,
            _that.nameEn,
            _that.nameJa,
            _that.descriptionEn,
            _that.descriptionJa,
            _that.evolutionStages,
            _that.nameEs,
            _that.descriptionEs,
            _that.availability);
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
            String nameEn,
            String nameJa,
            String descriptionEn,
            String descriptionJa,
            List<EvolutionStageModel> evolutionStages,
            String nameEs,
            String descriptionEs,
            String availability)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MascotSpeciesModel():
        return $default(
            _that.id,
            _that.nameEn,
            _that.nameJa,
            _that.descriptionEn,
            _that.descriptionJa,
            _that.evolutionStages,
            _that.nameEs,
            _that.descriptionEs,
            _that.availability);
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
            String nameEn,
            String nameJa,
            String descriptionEn,
            String descriptionJa,
            List<EvolutionStageModel> evolutionStages,
            String nameEs,
            String descriptionEs,
            String availability)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MascotSpeciesModel() when $default != null:
        return $default(
            _that.id,
            _that.nameEn,
            _that.nameJa,
            _that.descriptionEn,
            _that.descriptionJa,
            _that.evolutionStages,
            _that.nameEs,
            _that.descriptionEs,
            _that.availability);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MascotSpeciesModel implements MascotSpeciesModel {
  const _MascotSpeciesModel(
      {required this.id,
      required this.nameEn,
      required this.nameJa,
      required this.descriptionEn,
      required this.descriptionJa,
      required final List<EvolutionStageModel> evolutionStages,
      this.nameEs = '',
      this.descriptionEs = '',
      this.availability = 'free'})
      : _evolutionStages = evolutionStages;
  factory _MascotSpeciesModel.fromJson(Map<String, dynamic> json) =>
      _$MascotSpeciesModelFromJson(json);

  /// Unique identifier for the species (e.g., "seed").
  @override
  final String id;

  /// English name of the species.
  @override
  final String nameEn;

  /// Japanese name of the species.
  @override
  final String nameJa;

  /// English description of the species.
  @override
  final String descriptionEn;

  /// Japanese description of the species.
  @override
  final String descriptionJa;

  /// The evolution stages for this species, ordered by level threshold.
  final List<EvolutionStageModel> _evolutionStages;

  /// The evolution stages for this species, ordered by level threshold.
  @override
  List<EvolutionStageModel> get evolutionStages {
    if (_evolutionStages is EqualUnmodifiableListView) return _evolutionStages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evolutionStages);
  }

  /// Spanish name of the species.
  @override
  @JsonKey()
  final String nameEs;

  /// Spanish description of the species.
  @override
  @JsonKey()
  final String descriptionEs;

  /// Availability: 'free', 'premium', or a number (points cost to unlock).
  @override
  @JsonKey()
  final String availability;

  /// Create a copy of MascotSpeciesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MascotSpeciesModelCopyWith<_MascotSpeciesModel> get copyWith =>
      __$MascotSpeciesModelCopyWithImpl<_MascotSpeciesModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MascotSpeciesModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MascotSpeciesModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.nameJa, nameJa) || other.nameJa == nameJa) &&
            (identical(other.descriptionEn, descriptionEn) ||
                other.descriptionEn == descriptionEn) &&
            (identical(other.descriptionJa, descriptionJa) ||
                other.descriptionJa == descriptionJa) &&
            const DeepCollectionEquality()
                .equals(other._evolutionStages, _evolutionStages) &&
            (identical(other.nameEs, nameEs) || other.nameEs == nameEs) &&
            (identical(other.descriptionEs, descriptionEs) ||
                other.descriptionEs == descriptionEs) &&
            (identical(other.availability, availability) ||
                other.availability == availability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nameEn,
      nameJa,
      descriptionEn,
      descriptionJa,
      const DeepCollectionEquality().hash(_evolutionStages),
      nameEs,
      descriptionEs,
      availability);

  @override
  String toString() {
    return 'MascotSpeciesModel(id: $id, nameEn: $nameEn, nameJa: $nameJa, descriptionEn: $descriptionEn, descriptionJa: $descriptionJa, evolutionStages: $evolutionStages, nameEs: $nameEs, descriptionEs: $descriptionEs, availability: $availability)';
  }
}

/// @nodoc
abstract mixin class _$MascotSpeciesModelCopyWith<$Res>
    implements $MascotSpeciesModelCopyWith<$Res> {
  factory _$MascotSpeciesModelCopyWith(
          _MascotSpeciesModel value, $Res Function(_MascotSpeciesModel) _then) =
      __$MascotSpeciesModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nameEn,
      String nameJa,
      String descriptionEn,
      String descriptionJa,
      List<EvolutionStageModel> evolutionStages,
      String nameEs,
      String descriptionEs,
      String availability});
}

/// @nodoc
class __$MascotSpeciesModelCopyWithImpl<$Res>
    implements _$MascotSpeciesModelCopyWith<$Res> {
  __$MascotSpeciesModelCopyWithImpl(this._self, this._then);

  final _MascotSpeciesModel _self;
  final $Res Function(_MascotSpeciesModel) _then;

  /// Create a copy of MascotSpeciesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nameEn = null,
    Object? nameJa = null,
    Object? descriptionEn = null,
    Object? descriptionJa = null,
    Object? evolutionStages = null,
    Object? nameEs = null,
    Object? descriptionEs = null,
    Object? availability = null,
  }) {
    return _then(_MascotSpeciesModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _self.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      nameJa: null == nameJa
          ? _self.nameJa
          : nameJa // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionEn: null == descriptionEn
          ? _self.descriptionEn
          : descriptionEn // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionJa: null == descriptionJa
          ? _self.descriptionJa
          : descriptionJa // ignore: cast_nullable_to_non_nullable
              as String,
      evolutionStages: null == evolutionStages
          ? _self._evolutionStages
          : evolutionStages // ignore: cast_nullable_to_non_nullable
              as List<EvolutionStageModel>,
      nameEs: null == nameEs
          ? _self.nameEs
          : nameEs // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionEs: null == descriptionEs
          ? _self.descriptionEs
          : descriptionEs // ignore: cast_nullable_to_non_nullable
              as String,
      availability: null == availability
          ? _self.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
