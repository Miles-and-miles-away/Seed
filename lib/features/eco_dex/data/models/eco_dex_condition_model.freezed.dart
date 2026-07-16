// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eco_dex_condition_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
EcoDexCondition _$EcoDexConditionFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'totalActions':
          return TotalActionsCondition.fromJson(
            json
          );
                case 'categoryActions':
          return CategoryActionsCondition.fromJson(
            json
          );
                case 'co2Saved':
          return Co2SavedCondition.fromJson(
            json
          );
                case 'streakDays':
          return StreakDaysCondition.fromJson(
            json
          );
                case 'levelReached':
          return LevelReachedCondition.fromJson(
            json
          );
                case 'sdgBreadth':
          return SdgBreadthCondition.fromJson(
            json
          );
                case 'challengeStreak':
          return ChallengeStreakCondition.fromJson(
            json
          );
                case 'multiDayChallenge':
          return MultiDayChallengeCondition.fromJson(
            json
          );
                case 'ecoFactsViewed':
          return EcoFactsViewedCondition.fromJson(
            json
          );
                case 'categoriesCovered':
          return CategoriesCoveredCondition.fromJson(
            json
          );
                case 'uniqueActionsLogged':
          return UniqueActionsLoggedCondition.fromJson(
            json
          );
                case 'profileComplete':
          return ProfileCompleteCondition.fromJson(
            json
          );
                case 'ecodexCount':
          return EcodexCountCondition.fromJson(
            json
          );
                case 'challengesCompleted':
          return ChallengesCompletedCondition.fromJson(
            json
          );
                case 'uniqueZeroCo2Actions':
          return UniqueZeroCo2ActionsCondition.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'EcoDexCondition',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$EcoDexCondition {



  /// Serializes this EcoDexCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EcoDexCondition);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EcoDexCondition()';
}


}

/// @nodoc
class $EcoDexConditionCopyWith<$Res>  {
$EcoDexConditionCopyWith(EcoDexCondition _, $Res Function(EcoDexCondition) __);
}


/// Adds pattern-matching-related methods to [EcoDexCondition].
extension EcoDexConditionPatterns on EcoDexCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TotalActionsCondition value)?  totalActions,TResult Function( CategoryActionsCondition value)?  categoryActions,TResult Function( Co2SavedCondition value)?  co2Saved,TResult Function( StreakDaysCondition value)?  streakDays,TResult Function( LevelReachedCondition value)?  levelReached,TResult Function( SdgBreadthCondition value)?  sdgBreadth,TResult Function( ChallengeStreakCondition value)?  challengeStreak,TResult Function( MultiDayChallengeCondition value)?  multiDayChallenge,TResult Function( EcoFactsViewedCondition value)?  ecoFactsViewed,TResult Function( CategoriesCoveredCondition value)?  categoriesCovered,TResult Function( UniqueActionsLoggedCondition value)?  uniqueActionsLogged,TResult Function( ProfileCompleteCondition value)?  profileComplete,TResult Function( EcodexCountCondition value)?  ecodexCount,TResult Function( ChallengesCompletedCondition value)?  challengesCompleted,TResult Function( UniqueZeroCo2ActionsCondition value)?  uniqueZeroCo2Actions,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TotalActionsCondition() when totalActions != null:
return totalActions(_that);case CategoryActionsCondition() when categoryActions != null:
return categoryActions(_that);case Co2SavedCondition() when co2Saved != null:
return co2Saved(_that);case StreakDaysCondition() when streakDays != null:
return streakDays(_that);case LevelReachedCondition() when levelReached != null:
return levelReached(_that);case SdgBreadthCondition() when sdgBreadth != null:
return sdgBreadth(_that);case ChallengeStreakCondition() when challengeStreak != null:
return challengeStreak(_that);case MultiDayChallengeCondition() when multiDayChallenge != null:
return multiDayChallenge(_that);case EcoFactsViewedCondition() when ecoFactsViewed != null:
return ecoFactsViewed(_that);case CategoriesCoveredCondition() when categoriesCovered != null:
return categoriesCovered(_that);case UniqueActionsLoggedCondition() when uniqueActionsLogged != null:
return uniqueActionsLogged(_that);case ProfileCompleteCondition() when profileComplete != null:
return profileComplete(_that);case EcodexCountCondition() when ecodexCount != null:
return ecodexCount(_that);case ChallengesCompletedCondition() when challengesCompleted != null:
return challengesCompleted(_that);case UniqueZeroCo2ActionsCondition() when uniqueZeroCo2Actions != null:
return uniqueZeroCo2Actions(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TotalActionsCondition value)  totalActions,required TResult Function( CategoryActionsCondition value)  categoryActions,required TResult Function( Co2SavedCondition value)  co2Saved,required TResult Function( StreakDaysCondition value)  streakDays,required TResult Function( LevelReachedCondition value)  levelReached,required TResult Function( SdgBreadthCondition value)  sdgBreadth,required TResult Function( ChallengeStreakCondition value)  challengeStreak,required TResult Function( MultiDayChallengeCondition value)  multiDayChallenge,required TResult Function( EcoFactsViewedCondition value)  ecoFactsViewed,required TResult Function( CategoriesCoveredCondition value)  categoriesCovered,required TResult Function( UniqueActionsLoggedCondition value)  uniqueActionsLogged,required TResult Function( ProfileCompleteCondition value)  profileComplete,required TResult Function( EcodexCountCondition value)  ecodexCount,required TResult Function( ChallengesCompletedCondition value)  challengesCompleted,required TResult Function( UniqueZeroCo2ActionsCondition value)  uniqueZeroCo2Actions,}){
final _that = this;
switch (_that) {
case TotalActionsCondition():
return totalActions(_that);case CategoryActionsCondition():
return categoryActions(_that);case Co2SavedCondition():
return co2Saved(_that);case StreakDaysCondition():
return streakDays(_that);case LevelReachedCondition():
return levelReached(_that);case SdgBreadthCondition():
return sdgBreadth(_that);case ChallengeStreakCondition():
return challengeStreak(_that);case MultiDayChallengeCondition():
return multiDayChallenge(_that);case EcoFactsViewedCondition():
return ecoFactsViewed(_that);case CategoriesCoveredCondition():
return categoriesCovered(_that);case UniqueActionsLoggedCondition():
return uniqueActionsLogged(_that);case ProfileCompleteCondition():
return profileComplete(_that);case EcodexCountCondition():
return ecodexCount(_that);case ChallengesCompletedCondition():
return challengesCompleted(_that);case UniqueZeroCo2ActionsCondition():
return uniqueZeroCo2Actions(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TotalActionsCondition value)?  totalActions,TResult? Function( CategoryActionsCondition value)?  categoryActions,TResult? Function( Co2SavedCondition value)?  co2Saved,TResult? Function( StreakDaysCondition value)?  streakDays,TResult? Function( LevelReachedCondition value)?  levelReached,TResult? Function( SdgBreadthCondition value)?  sdgBreadth,TResult? Function( ChallengeStreakCondition value)?  challengeStreak,TResult? Function( MultiDayChallengeCondition value)?  multiDayChallenge,TResult? Function( EcoFactsViewedCondition value)?  ecoFactsViewed,TResult? Function( CategoriesCoveredCondition value)?  categoriesCovered,TResult? Function( UniqueActionsLoggedCondition value)?  uniqueActionsLogged,TResult? Function( ProfileCompleteCondition value)?  profileComplete,TResult? Function( EcodexCountCondition value)?  ecodexCount,TResult? Function( ChallengesCompletedCondition value)?  challengesCompleted,TResult? Function( UniqueZeroCo2ActionsCondition value)?  uniqueZeroCo2Actions,}){
final _that = this;
switch (_that) {
case TotalActionsCondition() when totalActions != null:
return totalActions(_that);case CategoryActionsCondition() when categoryActions != null:
return categoryActions(_that);case Co2SavedCondition() when co2Saved != null:
return co2Saved(_that);case StreakDaysCondition() when streakDays != null:
return streakDays(_that);case LevelReachedCondition() when levelReached != null:
return levelReached(_that);case SdgBreadthCondition() when sdgBreadth != null:
return sdgBreadth(_that);case ChallengeStreakCondition() when challengeStreak != null:
return challengeStreak(_that);case MultiDayChallengeCondition() when multiDayChallenge != null:
return multiDayChallenge(_that);case EcoFactsViewedCondition() when ecoFactsViewed != null:
return ecoFactsViewed(_that);case CategoriesCoveredCondition() when categoriesCovered != null:
return categoriesCovered(_that);case UniqueActionsLoggedCondition() when uniqueActionsLogged != null:
return uniqueActionsLogged(_that);case ProfileCompleteCondition() when profileComplete != null:
return profileComplete(_that);case EcodexCountCondition() when ecodexCount != null:
return ecodexCount(_that);case ChallengesCompletedCondition() when challengesCompleted != null:
return challengesCompleted(_that);case UniqueZeroCo2ActionsCondition() when uniqueZeroCo2Actions != null:
return uniqueZeroCo2Actions(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int count)?  totalActions,TResult Function( String category,  int count)?  categoryActions,TResult Function( int grams)?  co2Saved,TResult Function( int days)?  streakDays,TResult Function( int level)?  levelReached,TResult Function( int count)?  sdgBreadth,TResult Function( int days)?  challengeStreak,TResult Function( String templateId)?  multiDayChallenge,TResult Function( int count)?  ecoFactsViewed,TResult Function( int count)?  categoriesCovered,TResult Function( int count)?  uniqueActionsLogged,TResult Function()?  profileComplete,TResult Function( int count)?  ecodexCount,TResult Function( int count)?  challengesCompleted,TResult Function( int count)?  uniqueZeroCo2Actions,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TotalActionsCondition() when totalActions != null:
return totalActions(_that.count);case CategoryActionsCondition() when categoryActions != null:
return categoryActions(_that.category,_that.count);case Co2SavedCondition() when co2Saved != null:
return co2Saved(_that.grams);case StreakDaysCondition() when streakDays != null:
return streakDays(_that.days);case LevelReachedCondition() when levelReached != null:
return levelReached(_that.level);case SdgBreadthCondition() when sdgBreadth != null:
return sdgBreadth(_that.count);case ChallengeStreakCondition() when challengeStreak != null:
return challengeStreak(_that.days);case MultiDayChallengeCondition() when multiDayChallenge != null:
return multiDayChallenge(_that.templateId);case EcoFactsViewedCondition() when ecoFactsViewed != null:
return ecoFactsViewed(_that.count);case CategoriesCoveredCondition() when categoriesCovered != null:
return categoriesCovered(_that.count);case UniqueActionsLoggedCondition() when uniqueActionsLogged != null:
return uniqueActionsLogged(_that.count);case ProfileCompleteCondition() when profileComplete != null:
return profileComplete();case EcodexCountCondition() when ecodexCount != null:
return ecodexCount(_that.count);case ChallengesCompletedCondition() when challengesCompleted != null:
return challengesCompleted(_that.count);case UniqueZeroCo2ActionsCondition() when uniqueZeroCo2Actions != null:
return uniqueZeroCo2Actions(_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int count)  totalActions,required TResult Function( String category,  int count)  categoryActions,required TResult Function( int grams)  co2Saved,required TResult Function( int days)  streakDays,required TResult Function( int level)  levelReached,required TResult Function( int count)  sdgBreadth,required TResult Function( int days)  challengeStreak,required TResult Function( String templateId)  multiDayChallenge,required TResult Function( int count)  ecoFactsViewed,required TResult Function( int count)  categoriesCovered,required TResult Function( int count)  uniqueActionsLogged,required TResult Function()  profileComplete,required TResult Function( int count)  ecodexCount,required TResult Function( int count)  challengesCompleted,required TResult Function( int count)  uniqueZeroCo2Actions,}) {final _that = this;
switch (_that) {
case TotalActionsCondition():
return totalActions(_that.count);case CategoryActionsCondition():
return categoryActions(_that.category,_that.count);case Co2SavedCondition():
return co2Saved(_that.grams);case StreakDaysCondition():
return streakDays(_that.days);case LevelReachedCondition():
return levelReached(_that.level);case SdgBreadthCondition():
return sdgBreadth(_that.count);case ChallengeStreakCondition():
return challengeStreak(_that.days);case MultiDayChallengeCondition():
return multiDayChallenge(_that.templateId);case EcoFactsViewedCondition():
return ecoFactsViewed(_that.count);case CategoriesCoveredCondition():
return categoriesCovered(_that.count);case UniqueActionsLoggedCondition():
return uniqueActionsLogged(_that.count);case ProfileCompleteCondition():
return profileComplete();case EcodexCountCondition():
return ecodexCount(_that.count);case ChallengesCompletedCondition():
return challengesCompleted(_that.count);case UniqueZeroCo2ActionsCondition():
return uniqueZeroCo2Actions(_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int count)?  totalActions,TResult? Function( String category,  int count)?  categoryActions,TResult? Function( int grams)?  co2Saved,TResult? Function( int days)?  streakDays,TResult? Function( int level)?  levelReached,TResult? Function( int count)?  sdgBreadth,TResult? Function( int days)?  challengeStreak,TResult? Function( String templateId)?  multiDayChallenge,TResult? Function( int count)?  ecoFactsViewed,TResult? Function( int count)?  categoriesCovered,TResult? Function( int count)?  uniqueActionsLogged,TResult? Function()?  profileComplete,TResult? Function( int count)?  ecodexCount,TResult? Function( int count)?  challengesCompleted,TResult? Function( int count)?  uniqueZeroCo2Actions,}) {final _that = this;
switch (_that) {
case TotalActionsCondition() when totalActions != null:
return totalActions(_that.count);case CategoryActionsCondition() when categoryActions != null:
return categoryActions(_that.category,_that.count);case Co2SavedCondition() when co2Saved != null:
return co2Saved(_that.grams);case StreakDaysCondition() when streakDays != null:
return streakDays(_that.days);case LevelReachedCondition() when levelReached != null:
return levelReached(_that.level);case SdgBreadthCondition() when sdgBreadth != null:
return sdgBreadth(_that.count);case ChallengeStreakCondition() when challengeStreak != null:
return challengeStreak(_that.days);case MultiDayChallengeCondition() when multiDayChallenge != null:
return multiDayChallenge(_that.templateId);case EcoFactsViewedCondition() when ecoFactsViewed != null:
return ecoFactsViewed(_that.count);case CategoriesCoveredCondition() when categoriesCovered != null:
return categoriesCovered(_that.count);case UniqueActionsLoggedCondition() when uniqueActionsLogged != null:
return uniqueActionsLogged(_that.count);case ProfileCompleteCondition() when profileComplete != null:
return profileComplete();case EcodexCountCondition() when ecodexCount != null:
return ecodexCount(_that.count);case ChallengesCompletedCondition() when challengesCompleted != null:
return challengesCompleted(_that.count);case UniqueZeroCo2ActionsCondition() when uniqueZeroCo2Actions != null:
return uniqueZeroCo2Actions(_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TotalActionsCondition implements EcoDexCondition {
  const TotalActionsCondition({required this.count, final  String? $type}): $type = $type ?? 'totalActions';
  factory TotalActionsCondition.fromJson(Map<String, dynamic> json) => _$TotalActionsConditionFromJson(json);

 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotalActionsConditionCopyWith<TotalActionsCondition> get copyWith => _$TotalActionsConditionCopyWithImpl<TotalActionsCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TotalActionsConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotalActionsCondition&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'EcoDexCondition.totalActions(count: $count)';
}


}

/// @nodoc
abstract mixin class $TotalActionsConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $TotalActionsConditionCopyWith(TotalActionsCondition value, $Res Function(TotalActionsCondition) _then) = _$TotalActionsConditionCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$TotalActionsConditionCopyWithImpl<$Res>
    implements $TotalActionsConditionCopyWith<$Res> {
  _$TotalActionsConditionCopyWithImpl(this._self, this._then);

  final TotalActionsCondition _self;
  final $Res Function(TotalActionsCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(TotalActionsCondition(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class CategoryActionsCondition implements EcoDexCondition {
  const CategoryActionsCondition({required this.category, required this.count, final  String? $type}): $type = $type ?? 'categoryActions';
  factory CategoryActionsCondition.fromJson(Map<String, dynamic> json) => _$CategoryActionsConditionFromJson(json);

 final  String category;
 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryActionsConditionCopyWith<CategoryActionsCondition> get copyWith => _$CategoryActionsConditionCopyWithImpl<CategoryActionsCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryActionsConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryActionsCondition&&(identical(other.category, category) || other.category == category)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,count);

@override
String toString() {
  return 'EcoDexCondition.categoryActions(category: $category, count: $count)';
}


}

/// @nodoc
abstract mixin class $CategoryActionsConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $CategoryActionsConditionCopyWith(CategoryActionsCondition value, $Res Function(CategoryActionsCondition) _then) = _$CategoryActionsConditionCopyWithImpl;
@useResult
$Res call({
 String category, int count
});




}
/// @nodoc
class _$CategoryActionsConditionCopyWithImpl<$Res>
    implements $CategoryActionsConditionCopyWith<$Res> {
  _$CategoryActionsConditionCopyWithImpl(this._self, this._then);

  final CategoryActionsCondition _self;
  final $Res Function(CategoryActionsCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,Object? count = null,}) {
  return _then(CategoryActionsCondition(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class Co2SavedCondition implements EcoDexCondition {
  const Co2SavedCondition({required this.grams, final  String? $type}): $type = $type ?? 'co2Saved';
  factory Co2SavedCondition.fromJson(Map<String, dynamic> json) => _$Co2SavedConditionFromJson(json);

 final  int grams;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Co2SavedConditionCopyWith<Co2SavedCondition> get copyWith => _$Co2SavedConditionCopyWithImpl<Co2SavedCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Co2SavedConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Co2SavedCondition&&(identical(other.grams, grams) || other.grams == grams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grams);

@override
String toString() {
  return 'EcoDexCondition.co2Saved(grams: $grams)';
}


}

/// @nodoc
abstract mixin class $Co2SavedConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $Co2SavedConditionCopyWith(Co2SavedCondition value, $Res Function(Co2SavedCondition) _then) = _$Co2SavedConditionCopyWithImpl;
@useResult
$Res call({
 int grams
});




}
/// @nodoc
class _$Co2SavedConditionCopyWithImpl<$Res>
    implements $Co2SavedConditionCopyWith<$Res> {
  _$Co2SavedConditionCopyWithImpl(this._self, this._then);

  final Co2SavedCondition _self;
  final $Res Function(Co2SavedCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? grams = null,}) {
  return _then(Co2SavedCondition(
grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StreakDaysCondition implements EcoDexCondition {
  const StreakDaysCondition({required this.days, final  String? $type}): $type = $type ?? 'streakDays';
  factory StreakDaysCondition.fromJson(Map<String, dynamic> json) => _$StreakDaysConditionFromJson(json);

 final  int days;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakDaysConditionCopyWith<StreakDaysCondition> get copyWith => _$StreakDaysConditionCopyWithImpl<StreakDaysCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakDaysConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakDaysCondition&&(identical(other.days, days) || other.days == days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,days);

@override
String toString() {
  return 'EcoDexCondition.streakDays(days: $days)';
}


}

/// @nodoc
abstract mixin class $StreakDaysConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $StreakDaysConditionCopyWith(StreakDaysCondition value, $Res Function(StreakDaysCondition) _then) = _$StreakDaysConditionCopyWithImpl;
@useResult
$Res call({
 int days
});




}
/// @nodoc
class _$StreakDaysConditionCopyWithImpl<$Res>
    implements $StreakDaysConditionCopyWith<$Res> {
  _$StreakDaysConditionCopyWithImpl(this._self, this._then);

  final StreakDaysCondition _self;
  final $Res Function(StreakDaysCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? days = null,}) {
  return _then(StreakDaysCondition(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LevelReachedCondition implements EcoDexCondition {
  const LevelReachedCondition({required this.level, final  String? $type}): $type = $type ?? 'levelReached';
  factory LevelReachedCondition.fromJson(Map<String, dynamic> json) => _$LevelReachedConditionFromJson(json);

 final  int level;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelReachedConditionCopyWith<LevelReachedCondition> get copyWith => _$LevelReachedConditionCopyWithImpl<LevelReachedCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LevelReachedConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelReachedCondition&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level);

@override
String toString() {
  return 'EcoDexCondition.levelReached(level: $level)';
}


}

/// @nodoc
abstract mixin class $LevelReachedConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $LevelReachedConditionCopyWith(LevelReachedCondition value, $Res Function(LevelReachedCondition) _then) = _$LevelReachedConditionCopyWithImpl;
@useResult
$Res call({
 int level
});




}
/// @nodoc
class _$LevelReachedConditionCopyWithImpl<$Res>
    implements $LevelReachedConditionCopyWith<$Res> {
  _$LevelReachedConditionCopyWithImpl(this._self, this._then);

  final LevelReachedCondition _self;
  final $Res Function(LevelReachedCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? level = null,}) {
  return _then(LevelReachedCondition(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SdgBreadthCondition implements EcoDexCondition {
  const SdgBreadthCondition({required this.count, final  String? $type}): $type = $type ?? 'sdgBreadth';
  factory SdgBreadthCondition.fromJson(Map<String, dynamic> json) => _$SdgBreadthConditionFromJson(json);

 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdgBreadthConditionCopyWith<SdgBreadthCondition> get copyWith => _$SdgBreadthConditionCopyWithImpl<SdgBreadthCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SdgBreadthConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdgBreadthCondition&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'EcoDexCondition.sdgBreadth(count: $count)';
}


}

/// @nodoc
abstract mixin class $SdgBreadthConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $SdgBreadthConditionCopyWith(SdgBreadthCondition value, $Res Function(SdgBreadthCondition) _then) = _$SdgBreadthConditionCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$SdgBreadthConditionCopyWithImpl<$Res>
    implements $SdgBreadthConditionCopyWith<$Res> {
  _$SdgBreadthConditionCopyWithImpl(this._self, this._then);

  final SdgBreadthCondition _self;
  final $Res Function(SdgBreadthCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(SdgBreadthCondition(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChallengeStreakCondition implements EcoDexCondition {
  const ChallengeStreakCondition({required this.days, final  String? $type}): $type = $type ?? 'challengeStreak';
  factory ChallengeStreakCondition.fromJson(Map<String, dynamic> json) => _$ChallengeStreakConditionFromJson(json);

 final  int days;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeStreakConditionCopyWith<ChallengeStreakCondition> get copyWith => _$ChallengeStreakConditionCopyWithImpl<ChallengeStreakCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeStreakConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeStreakCondition&&(identical(other.days, days) || other.days == days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,days);

@override
String toString() {
  return 'EcoDexCondition.challengeStreak(days: $days)';
}


}

/// @nodoc
abstract mixin class $ChallengeStreakConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $ChallengeStreakConditionCopyWith(ChallengeStreakCondition value, $Res Function(ChallengeStreakCondition) _then) = _$ChallengeStreakConditionCopyWithImpl;
@useResult
$Res call({
 int days
});




}
/// @nodoc
class _$ChallengeStreakConditionCopyWithImpl<$Res>
    implements $ChallengeStreakConditionCopyWith<$Res> {
  _$ChallengeStreakConditionCopyWithImpl(this._self, this._then);

  final ChallengeStreakCondition _self;
  final $Res Function(ChallengeStreakCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? days = null,}) {
  return _then(ChallengeStreakCondition(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MultiDayChallengeCondition implements EcoDexCondition {
  const MultiDayChallengeCondition({required this.templateId, final  String? $type}): $type = $type ?? 'multiDayChallenge';
  factory MultiDayChallengeCondition.fromJson(Map<String, dynamic> json) => _$MultiDayChallengeConditionFromJson(json);

 final  String templateId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultiDayChallengeConditionCopyWith<MultiDayChallengeCondition> get copyWith => _$MultiDayChallengeConditionCopyWithImpl<MultiDayChallengeCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultiDayChallengeConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultiDayChallengeCondition&&(identical(other.templateId, templateId) || other.templateId == templateId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId);

@override
String toString() {
  return 'EcoDexCondition.multiDayChallenge(templateId: $templateId)';
}


}

/// @nodoc
abstract mixin class $MultiDayChallengeConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $MultiDayChallengeConditionCopyWith(MultiDayChallengeCondition value, $Res Function(MultiDayChallengeCondition) _then) = _$MultiDayChallengeConditionCopyWithImpl;
@useResult
$Res call({
 String templateId
});




}
/// @nodoc
class _$MultiDayChallengeConditionCopyWithImpl<$Res>
    implements $MultiDayChallengeConditionCopyWith<$Res> {
  _$MultiDayChallengeConditionCopyWithImpl(this._self, this._then);

  final MultiDayChallengeCondition _self;
  final $Res Function(MultiDayChallengeCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? templateId = null,}) {
  return _then(MultiDayChallengeCondition(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class EcoFactsViewedCondition implements EcoDexCondition {
  const EcoFactsViewedCondition({required this.count, final  String? $type}): $type = $type ?? 'ecoFactsViewed';
  factory EcoFactsViewedCondition.fromJson(Map<String, dynamic> json) => _$EcoFactsViewedConditionFromJson(json);

 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EcoFactsViewedConditionCopyWith<EcoFactsViewedCondition> get copyWith => _$EcoFactsViewedConditionCopyWithImpl<EcoFactsViewedCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EcoFactsViewedConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EcoFactsViewedCondition&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'EcoDexCondition.ecoFactsViewed(count: $count)';
}


}

/// @nodoc
abstract mixin class $EcoFactsViewedConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $EcoFactsViewedConditionCopyWith(EcoFactsViewedCondition value, $Res Function(EcoFactsViewedCondition) _then) = _$EcoFactsViewedConditionCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$EcoFactsViewedConditionCopyWithImpl<$Res>
    implements $EcoFactsViewedConditionCopyWith<$Res> {
  _$EcoFactsViewedConditionCopyWithImpl(this._self, this._then);

  final EcoFactsViewedCondition _self;
  final $Res Function(EcoFactsViewedCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(EcoFactsViewedCondition(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class CategoriesCoveredCondition implements EcoDexCondition {
  const CategoriesCoveredCondition({required this.count, final  String? $type}): $type = $type ?? 'categoriesCovered';
  factory CategoriesCoveredCondition.fromJson(Map<String, dynamic> json) => _$CategoriesCoveredConditionFromJson(json);

 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesCoveredConditionCopyWith<CategoriesCoveredCondition> get copyWith => _$CategoriesCoveredConditionCopyWithImpl<CategoriesCoveredCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoriesCoveredConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesCoveredCondition&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'EcoDexCondition.categoriesCovered(count: $count)';
}


}

/// @nodoc
abstract mixin class $CategoriesCoveredConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $CategoriesCoveredConditionCopyWith(CategoriesCoveredCondition value, $Res Function(CategoriesCoveredCondition) _then) = _$CategoriesCoveredConditionCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$CategoriesCoveredConditionCopyWithImpl<$Res>
    implements $CategoriesCoveredConditionCopyWith<$Res> {
  _$CategoriesCoveredConditionCopyWithImpl(this._self, this._then);

  final CategoriesCoveredCondition _self;
  final $Res Function(CategoriesCoveredCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(CategoriesCoveredCondition(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UniqueActionsLoggedCondition implements EcoDexCondition {
  const UniqueActionsLoggedCondition({required this.count, final  String? $type}): $type = $type ?? 'uniqueActionsLogged';
  factory UniqueActionsLoggedCondition.fromJson(Map<String, dynamic> json) => _$UniqueActionsLoggedConditionFromJson(json);

 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniqueActionsLoggedConditionCopyWith<UniqueActionsLoggedCondition> get copyWith => _$UniqueActionsLoggedConditionCopyWithImpl<UniqueActionsLoggedCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniqueActionsLoggedConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UniqueActionsLoggedCondition&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'EcoDexCondition.uniqueActionsLogged(count: $count)';
}


}

/// @nodoc
abstract mixin class $UniqueActionsLoggedConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $UniqueActionsLoggedConditionCopyWith(UniqueActionsLoggedCondition value, $Res Function(UniqueActionsLoggedCondition) _then) = _$UniqueActionsLoggedConditionCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$UniqueActionsLoggedConditionCopyWithImpl<$Res>
    implements $UniqueActionsLoggedConditionCopyWith<$Res> {
  _$UniqueActionsLoggedConditionCopyWithImpl(this._self, this._then);

  final UniqueActionsLoggedCondition _self;
  final $Res Function(UniqueActionsLoggedCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(UniqueActionsLoggedCondition(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ProfileCompleteCondition implements EcoDexCondition {
  const ProfileCompleteCondition({final  String? $type}): $type = $type ?? 'profileComplete';
  factory ProfileCompleteCondition.fromJson(Map<String, dynamic> json) => _$ProfileCompleteConditionFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$ProfileCompleteConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileCompleteCondition);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EcoDexCondition.profileComplete()';
}


}




/// @nodoc
@JsonSerializable()

class EcodexCountCondition implements EcoDexCondition {
  const EcodexCountCondition({required this.count, final  String? $type}): $type = $type ?? 'ecodexCount';
  factory EcodexCountCondition.fromJson(Map<String, dynamic> json) => _$EcodexCountConditionFromJson(json);

 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EcodexCountConditionCopyWith<EcodexCountCondition> get copyWith => _$EcodexCountConditionCopyWithImpl<EcodexCountCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EcodexCountConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EcodexCountCondition&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'EcoDexCondition.ecodexCount(count: $count)';
}


}

/// @nodoc
abstract mixin class $EcodexCountConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $EcodexCountConditionCopyWith(EcodexCountCondition value, $Res Function(EcodexCountCondition) _then) = _$EcodexCountConditionCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$EcodexCountConditionCopyWithImpl<$Res>
    implements $EcodexCountConditionCopyWith<$Res> {
  _$EcodexCountConditionCopyWithImpl(this._self, this._then);

  final EcodexCountCondition _self;
  final $Res Function(EcodexCountCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(EcodexCountCondition(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChallengesCompletedCondition implements EcoDexCondition {
  const ChallengesCompletedCondition({required this.count, final  String? $type}): $type = $type ?? 'challengesCompleted';
  factory ChallengesCompletedCondition.fromJson(Map<String, dynamic> json) => _$ChallengesCompletedConditionFromJson(json);

 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengesCompletedConditionCopyWith<ChallengesCompletedCondition> get copyWith => _$ChallengesCompletedConditionCopyWithImpl<ChallengesCompletedCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengesCompletedConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengesCompletedCondition&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'EcoDexCondition.challengesCompleted(count: $count)';
}


}

/// @nodoc
abstract mixin class $ChallengesCompletedConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $ChallengesCompletedConditionCopyWith(ChallengesCompletedCondition value, $Res Function(ChallengesCompletedCondition) _then) = _$ChallengesCompletedConditionCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$ChallengesCompletedConditionCopyWithImpl<$Res>
    implements $ChallengesCompletedConditionCopyWith<$Res> {
  _$ChallengesCompletedConditionCopyWithImpl(this._self, this._then);

  final ChallengesCompletedCondition _self;
  final $Res Function(ChallengesCompletedCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(ChallengesCompletedCondition(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UniqueZeroCo2ActionsCondition implements EcoDexCondition {
  const UniqueZeroCo2ActionsCondition({required this.count, final  String? $type}): $type = $type ?? 'uniqueZeroCo2Actions';
  factory UniqueZeroCo2ActionsCondition.fromJson(Map<String, dynamic> json) => _$UniqueZeroCo2ActionsConditionFromJson(json);

 final  int count;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniqueZeroCo2ActionsConditionCopyWith<UniqueZeroCo2ActionsCondition> get copyWith => _$UniqueZeroCo2ActionsConditionCopyWithImpl<UniqueZeroCo2ActionsCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniqueZeroCo2ActionsConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UniqueZeroCo2ActionsCondition&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'EcoDexCondition.uniqueZeroCo2Actions(count: $count)';
}


}

/// @nodoc
abstract mixin class $UniqueZeroCo2ActionsConditionCopyWith<$Res> implements $EcoDexConditionCopyWith<$Res> {
  factory $UniqueZeroCo2ActionsConditionCopyWith(UniqueZeroCo2ActionsCondition value, $Res Function(UniqueZeroCo2ActionsCondition) _then) = _$UniqueZeroCo2ActionsConditionCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$UniqueZeroCo2ActionsConditionCopyWithImpl<$Res>
    implements $UniqueZeroCo2ActionsConditionCopyWith<$Res> {
  _$UniqueZeroCo2ActionsConditionCopyWithImpl(this._self, this._then);

  final UniqueZeroCo2ActionsCondition _self;
  final $Res Function(UniqueZeroCo2ActionsCondition) _then;

/// Create a copy of EcoDexCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(UniqueZeroCo2ActionsCondition(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
