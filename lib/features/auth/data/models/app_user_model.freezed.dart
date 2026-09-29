// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUserModel {

 String get uid; String get email; String? get displayName; String? get photoUrl;/// Personal sustainability goal: a preset ID or free text.
 String? get personalGoal; int get points; int get level; int get currentStreak; int get longestStreak; String get language; String get notificationTime;@TimestampConverter() DateTime? get createdAt; bool get emailVerified; int? get dailyGoalTarget;/// All owned mascots.
 List<MascotModel> get mascots;/// ID of the currently active mascot.
 String? get activeMascotId;/// Pending egg waiting to hatch.
 EggModel? get egg;/// Flag set when a mascot maxes out evolution.
 bool get eggPendingDiscovery;/// When the egg pending discovery flag was set.
@TimestampConverter() DateTime? get eggPendingDiscoverySince;/// Master toggle for notifications.
 bool get notificationsEnabled;/// Date of the user's last logged action.
@TimestampConverter() DateTime? get lastActionDate;/// FCM token for push notifications.
 String? get fcmToken;/// Total CO2 saved across all actions (grams).
 int get totalCo2Grams;/// Total number of actions logged.
 int get totalActionsCount;/// Per-SDG aggregated stats: { "1": { "count": 5, "co2": 1200 } }
 Map<String, Map<String, int>> get sdgStats;/// Dates (yyyy-MM-dd) when the user viewed their daily eco-fact.
 List<String> get viewedFactDates;/// Dates (yyyy-MM-dd) when the user's daily eco-fact was unlocked
/// (challenge completed). Distinct from viewedFactDates: a day can
/// be unlocked without being read.
 List<String> get unlockedFactDates;/// Date (yyyy-MM-dd) when the user last completed a challenge.
 String get challengeCompletedDate;/// Consecutive days of challenge completion.
 int get challengeStreak;/// Lifetime count of challenges completed.
 int get challengesCompleted;/// Last N template IDs to avoid repetition.
 List<String> get recentChallengeIds;/// Active multi-day challenge state map.
 Map<String, dynamic> get activeMultiDayChallenge;/// IDs of completed multi-day challenge templates.
 List<String> get completedMultiDayChallenges;/// IDs of discovered Eco-Dex entries.
 List<String> get ecodexDiscovered;/// Distinct action IDs the user has ever logged.
 List<String> get uniqueActionIds;/// Per-category action counts: { "food": 12, "energy": 5 }
 Map<String, int> get categoryActionCounts;
/// Create a copy of AppUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserModelCopyWith<AppUserModel> get copyWith => _$AppUserModelCopyWithImpl<AppUserModel>(this as AppUserModel, _$identity);

  /// Serializes this AppUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppUserModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUserModel&&(identical(other.uid, _this.uid) || other.uid == _this.uid)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.personalGoal, _this.personalGoal) || other.personalGoal == _this.personalGoal)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.currentStreak, _this.currentStreak) || other.currentStreak == _this.currentStreak)&&(identical(other.longestStreak, _this.longestStreak) || other.longestStreak == _this.longestStreak)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.notificationTime, _this.notificationTime) || other.notificationTime == _this.notificationTime)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.emailVerified, _this.emailVerified) || other.emailVerified == _this.emailVerified)&&(identical(other.dailyGoalTarget, _this.dailyGoalTarget) || other.dailyGoalTarget == _this.dailyGoalTarget)&&const DeepCollectionEquality().equals(other.mascots, _this.mascots)&&(identical(other.activeMascotId, _this.activeMascotId) || other.activeMascotId == _this.activeMascotId)&&(identical(other.egg, _this.egg) || other.egg == _this.egg)&&(identical(other.eggPendingDiscovery, _this.eggPendingDiscovery) || other.eggPendingDiscovery == _this.eggPendingDiscovery)&&(identical(other.eggPendingDiscoverySince, _this.eggPendingDiscoverySince) || other.eggPendingDiscoverySince == _this.eggPendingDiscoverySince)&&(identical(other.notificationsEnabled, _this.notificationsEnabled) || other.notificationsEnabled == _this.notificationsEnabled)&&(identical(other.lastActionDate, _this.lastActionDate) || other.lastActionDate == _this.lastActionDate)&&(identical(other.fcmToken, _this.fcmToken) || other.fcmToken == _this.fcmToken)&&(identical(other.totalCo2Grams, _this.totalCo2Grams) || other.totalCo2Grams == _this.totalCo2Grams)&&(identical(other.totalActionsCount, _this.totalActionsCount) || other.totalActionsCount == _this.totalActionsCount)&&const DeepCollectionEquality().equals(other.sdgStats, _this.sdgStats)&&const DeepCollectionEquality().equals(other.viewedFactDates, _this.viewedFactDates)&&const DeepCollectionEquality().equals(other.unlockedFactDates, _this.unlockedFactDates)&&(identical(other.challengeCompletedDate, _this.challengeCompletedDate) || other.challengeCompletedDate == _this.challengeCompletedDate)&&(identical(other.challengeStreak, _this.challengeStreak) || other.challengeStreak == _this.challengeStreak)&&(identical(other.challengesCompleted, _this.challengesCompleted) || other.challengesCompleted == _this.challengesCompleted)&&const DeepCollectionEquality().equals(other.recentChallengeIds, _this.recentChallengeIds)&&const DeepCollectionEquality().equals(other.activeMultiDayChallenge, _this.activeMultiDayChallenge)&&const DeepCollectionEquality().equals(other.completedMultiDayChallenges, _this.completedMultiDayChallenges)&&const DeepCollectionEquality().equals(other.ecodexDiscovered, _this.ecodexDiscovered)&&const DeepCollectionEquality().equals(other.uniqueActionIds, _this.uniqueActionIds)&&const DeepCollectionEquality().equals(other.categoryActionCounts, _this.categoryActionCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppUserModel;
  return Object.hashAll([runtimeType,_this.uid,_this.email,_this.displayName,_this.photoUrl,_this.personalGoal,_this.points,_this.level,_this.currentStreak,_this.longestStreak,_this.language,_this.notificationTime,_this.createdAt,_this.emailVerified,_this.dailyGoalTarget,const DeepCollectionEquality().hash(_this.mascots),_this.activeMascotId,_this.egg,_this.eggPendingDiscovery,_this.eggPendingDiscoverySince,_this.notificationsEnabled,_this.lastActionDate,_this.fcmToken,_this.totalCo2Grams,_this.totalActionsCount,const DeepCollectionEquality().hash(_this.sdgStats),const DeepCollectionEquality().hash(_this.viewedFactDates),const DeepCollectionEquality().hash(_this.unlockedFactDates),_this.challengeCompletedDate,_this.challengeStreak,_this.challengesCompleted,const DeepCollectionEquality().hash(_this.recentChallengeIds),const DeepCollectionEquality().hash(_this.activeMultiDayChallenge),const DeepCollectionEquality().hash(_this.completedMultiDayChallenges),const DeepCollectionEquality().hash(_this.ecodexDiscovered),const DeepCollectionEquality().hash(_this.uniqueActionIds),const DeepCollectionEquality().hash(_this.categoryActionCounts)]);
}

@override
String toString() {
  final _this = this as AppUserModel;
  return 'AppUserModel(uid: ${_this.uid}, email: ${_this.email}, displayName: ${_this.displayName}, photoUrl: ${_this.photoUrl}, personalGoal: ${_this.personalGoal}, points: ${_this.points}, level: ${_this.level}, currentStreak: ${_this.currentStreak}, longestStreak: ${_this.longestStreak}, language: ${_this.language}, notificationTime: ${_this.notificationTime}, createdAt: ${_this.createdAt}, emailVerified: ${_this.emailVerified}, dailyGoalTarget: ${_this.dailyGoalTarget}, mascots: ${_this.mascots}, activeMascotId: ${_this.activeMascotId}, egg: ${_this.egg}, eggPendingDiscovery: ${_this.eggPendingDiscovery}, eggPendingDiscoverySince: ${_this.eggPendingDiscoverySince}, notificationsEnabled: ${_this.notificationsEnabled}, lastActionDate: ${_this.lastActionDate}, fcmToken: ${_this.fcmToken}, totalCo2Grams: ${_this.totalCo2Grams}, totalActionsCount: ${_this.totalActionsCount}, sdgStats: ${_this.sdgStats}, viewedFactDates: ${_this.viewedFactDates}, unlockedFactDates: ${_this.unlockedFactDates}, challengeCompletedDate: ${_this.challengeCompletedDate}, challengeStreak: ${_this.challengeStreak}, challengesCompleted: ${_this.challengesCompleted}, recentChallengeIds: ${_this.recentChallengeIds}, activeMultiDayChallenge: ${_this.activeMultiDayChallenge}, completedMultiDayChallenges: ${_this.completedMultiDayChallenges}, ecodexDiscovered: ${_this.ecodexDiscovered}, uniqueActionIds: ${_this.uniqueActionIds}, categoryActionCounts: ${_this.categoryActionCounts})';
}


}

/// @nodoc
abstract mixin class $AppUserModelCopyWith<$Res>  {
  factory $AppUserModelCopyWith(AppUserModel value, $Res Function(AppUserModel) _then) = _$AppUserModelCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String? displayName, String? photoUrl, String? personalGoal, int points, int level, int currentStreak, int longestStreak, String language, String notificationTime,@TimestampConverter() DateTime? createdAt, bool emailVerified, int? dailyGoalTarget, List<MascotModel> mascots, String? activeMascotId, EggModel? egg, bool eggPendingDiscovery,@TimestampConverter() DateTime? eggPendingDiscoverySince, bool notificationsEnabled,@TimestampConverter() DateTime? lastActionDate, String? fcmToken, int totalCo2Grams, int totalActionsCount, Map<String, Map<String, int>> sdgStats, List<String> viewedFactDates, List<String> unlockedFactDates, String challengeCompletedDate, int challengeStreak, int challengesCompleted, List<String> recentChallengeIds, Map<String, dynamic> activeMultiDayChallenge, List<String> completedMultiDayChallenges, List<String> ecodexDiscovered, List<String> uniqueActionIds, Map<String, int> categoryActionCounts
});


$EggModelCopyWith<$Res>? get egg;

}
/// @nodoc
class _$AppUserModelCopyWithImpl<$Res>
    implements $AppUserModelCopyWith<$Res> {
  _$AppUserModelCopyWithImpl(this._self, this._then);

  final AppUserModel _self;
  final $Res Function(AppUserModel) _then;

/// Create a copy of AppUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = freezed,Object? photoUrl = freezed,Object? personalGoal = freezed,Object? points = null,Object? level = null,Object? currentStreak = null,Object? longestStreak = null,Object? language = null,Object? notificationTime = null,Object? createdAt = freezed,Object? emailVerified = null,Object? dailyGoalTarget = freezed,Object? mascots = null,Object? activeMascotId = freezed,Object? egg = freezed,Object? eggPendingDiscovery = null,Object? eggPendingDiscoverySince = freezed,Object? notificationsEnabled = null,Object? lastActionDate = freezed,Object? fcmToken = freezed,Object? totalCo2Grams = null,Object? totalActionsCount = null,Object? sdgStats = null,Object? viewedFactDates = null,Object? unlockedFactDates = null,Object? challengeCompletedDate = null,Object? challengeStreak = null,Object? challengesCompleted = null,Object? recentChallengeIds = null,Object? activeMultiDayChallenge = null,Object? completedMultiDayChallenges = null,Object? ecodexDiscovered = null,Object? uniqueActionIds = null,Object? categoryActionCounts = null,}) {
  return _then(AppUserModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,personalGoal: freezed == personalGoal ? _self.personalGoal : personalGoal // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,notificationTime: null == notificationTime ? _self.notificationTime : notificationTime // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,dailyGoalTarget: freezed == dailyGoalTarget ? _self.dailyGoalTarget : dailyGoalTarget // ignore: cast_nullable_to_non_nullable
as int?,mascots: null == mascots ? _self.mascots : mascots // ignore: cast_nullable_to_non_nullable
as List<MascotModel>,activeMascotId: freezed == activeMascotId ? _self.activeMascotId : activeMascotId // ignore: cast_nullable_to_non_nullable
as String?,egg: freezed == egg ? _self.egg : egg // ignore: cast_nullable_to_non_nullable
as EggModel?,eggPendingDiscovery: null == eggPendingDiscovery ? _self.eggPendingDiscovery : eggPendingDiscovery // ignore: cast_nullable_to_non_nullable
as bool,eggPendingDiscoverySince: freezed == eggPendingDiscoverySince ? _self.eggPendingDiscoverySince : eggPendingDiscoverySince // ignore: cast_nullable_to_non_nullable
as DateTime?,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,lastActionDate: freezed == lastActionDate ? _self.lastActionDate : lastActionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,totalCo2Grams: null == totalCo2Grams ? _self.totalCo2Grams : totalCo2Grams // ignore: cast_nullable_to_non_nullable
as int,totalActionsCount: null == totalActionsCount ? _self.totalActionsCount : totalActionsCount // ignore: cast_nullable_to_non_nullable
as int,sdgStats: null == sdgStats ? _self.sdgStats : sdgStats // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, int>>,viewedFactDates: null == viewedFactDates ? _self.viewedFactDates : viewedFactDates // ignore: cast_nullable_to_non_nullable
as List<String>,unlockedFactDates: null == unlockedFactDates ? _self.unlockedFactDates : unlockedFactDates // ignore: cast_nullable_to_non_nullable
as List<String>,challengeCompletedDate: null == challengeCompletedDate ? _self.challengeCompletedDate : challengeCompletedDate // ignore: cast_nullable_to_non_nullable
as String,challengeStreak: null == challengeStreak ? _self.challengeStreak : challengeStreak // ignore: cast_nullable_to_non_nullable
as int,challengesCompleted: null == challengesCompleted ? _self.challengesCompleted : challengesCompleted // ignore: cast_nullable_to_non_nullable
as int,recentChallengeIds: null == recentChallengeIds ? _self.recentChallengeIds : recentChallengeIds // ignore: cast_nullable_to_non_nullable
as List<String>,activeMultiDayChallenge: null == activeMultiDayChallenge ? _self.activeMultiDayChallenge : activeMultiDayChallenge // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,completedMultiDayChallenges: null == completedMultiDayChallenges ? _self.completedMultiDayChallenges : completedMultiDayChallenges // ignore: cast_nullable_to_non_nullable
as List<String>,ecodexDiscovered: null == ecodexDiscovered ? _self.ecodexDiscovered : ecodexDiscovered // ignore: cast_nullable_to_non_nullable
as List<String>,uniqueActionIds: null == uniqueActionIds ? _self.uniqueActionIds : uniqueActionIds // ignore: cast_nullable_to_non_nullable
as List<String>,categoryActionCounts: null == categoryActionCounts ? _self.categoryActionCounts : categoryActionCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}
/// Create a copy of AppUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EggModelCopyWith<$Res>? get egg {
    if (_self.egg == null) {
    return null;
  }

  return $EggModelCopyWith<$Res>(_self.egg!, (value) {
    return _then(_self.copyWith(egg: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppUserModel].
extension AppUserModelPatterns on AppUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUserModel value)  $default,){
final _that = this;
switch (_that) {
case _AppUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String? displayName,  String? photoUrl,  String? personalGoal,  int points,  int level,  int currentStreak,  int longestStreak,  String language,  String notificationTime, @TimestampConverter()  DateTime? createdAt,  bool emailVerified,  int? dailyGoalTarget,  List<MascotModel> mascots,  String? activeMascotId,  EggModel? egg,  bool eggPendingDiscovery, @TimestampConverter()  DateTime? eggPendingDiscoverySince,  bool notificationsEnabled, @TimestampConverter()  DateTime? lastActionDate,  String? fcmToken,  int totalCo2Grams,  int totalActionsCount,  Map<String, Map<String, int>> sdgStats,  List<String> viewedFactDates,  List<String> unlockedFactDates,  String challengeCompletedDate,  int challengeStreak,  int challengesCompleted,  List<String> recentChallengeIds,  Map<String, dynamic> activeMultiDayChallenge,  List<String> completedMultiDayChallenges,  List<String> ecodexDiscovered,  List<String> uniqueActionIds,  Map<String, int> categoryActionCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUserModel() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.photoUrl,_that.personalGoal,_that.points,_that.level,_that.currentStreak,_that.longestStreak,_that.language,_that.notificationTime,_that.createdAt,_that.emailVerified,_that.dailyGoalTarget,_that.mascots,_that.activeMascotId,_that.egg,_that.eggPendingDiscovery,_that.eggPendingDiscoverySince,_that.notificationsEnabled,_that.lastActionDate,_that.fcmToken,_that.totalCo2Grams,_that.totalActionsCount,_that.sdgStats,_that.viewedFactDates,_that.unlockedFactDates,_that.challengeCompletedDate,_that.challengeStreak,_that.challengesCompleted,_that.recentChallengeIds,_that.activeMultiDayChallenge,_that.completedMultiDayChallenges,_that.ecodexDiscovered,_that.uniqueActionIds,_that.categoryActionCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String? displayName,  String? photoUrl,  String? personalGoal,  int points,  int level,  int currentStreak,  int longestStreak,  String language,  String notificationTime, @TimestampConverter()  DateTime? createdAt,  bool emailVerified,  int? dailyGoalTarget,  List<MascotModel> mascots,  String? activeMascotId,  EggModel? egg,  bool eggPendingDiscovery, @TimestampConverter()  DateTime? eggPendingDiscoverySince,  bool notificationsEnabled, @TimestampConverter()  DateTime? lastActionDate,  String? fcmToken,  int totalCo2Grams,  int totalActionsCount,  Map<String, Map<String, int>> sdgStats,  List<String> viewedFactDates,  List<String> unlockedFactDates,  String challengeCompletedDate,  int challengeStreak,  int challengesCompleted,  List<String> recentChallengeIds,  Map<String, dynamic> activeMultiDayChallenge,  List<String> completedMultiDayChallenges,  List<String> ecodexDiscovered,  List<String> uniqueActionIds,  Map<String, int> categoryActionCounts)  $default,) {final _that = this;
switch (_that) {
case _AppUserModel():
return $default(_that.uid,_that.email,_that.displayName,_that.photoUrl,_that.personalGoal,_that.points,_that.level,_that.currentStreak,_that.longestStreak,_that.language,_that.notificationTime,_that.createdAt,_that.emailVerified,_that.dailyGoalTarget,_that.mascots,_that.activeMascotId,_that.egg,_that.eggPendingDiscovery,_that.eggPendingDiscoverySince,_that.notificationsEnabled,_that.lastActionDate,_that.fcmToken,_that.totalCo2Grams,_that.totalActionsCount,_that.sdgStats,_that.viewedFactDates,_that.unlockedFactDates,_that.challengeCompletedDate,_that.challengeStreak,_that.challengesCompleted,_that.recentChallengeIds,_that.activeMultiDayChallenge,_that.completedMultiDayChallenges,_that.ecodexDiscovered,_that.uniqueActionIds,_that.categoryActionCounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String? displayName,  String? photoUrl,  String? personalGoal,  int points,  int level,  int currentStreak,  int longestStreak,  String language,  String notificationTime, @TimestampConverter()  DateTime? createdAt,  bool emailVerified,  int? dailyGoalTarget,  List<MascotModel> mascots,  String? activeMascotId,  EggModel? egg,  bool eggPendingDiscovery, @TimestampConverter()  DateTime? eggPendingDiscoverySince,  bool notificationsEnabled, @TimestampConverter()  DateTime? lastActionDate,  String? fcmToken,  int totalCo2Grams,  int totalActionsCount,  Map<String, Map<String, int>> sdgStats,  List<String> viewedFactDates,  List<String> unlockedFactDates,  String challengeCompletedDate,  int challengeStreak,  int challengesCompleted,  List<String> recentChallengeIds,  Map<String, dynamic> activeMultiDayChallenge,  List<String> completedMultiDayChallenges,  List<String> ecodexDiscovered,  List<String> uniqueActionIds,  Map<String, int> categoryActionCounts)?  $default,) {final _that = this;
switch (_that) {
case _AppUserModel() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.photoUrl,_that.personalGoal,_that.points,_that.level,_that.currentStreak,_that.longestStreak,_that.language,_that.notificationTime,_that.createdAt,_that.emailVerified,_that.dailyGoalTarget,_that.mascots,_that.activeMascotId,_that.egg,_that.eggPendingDiscovery,_that.eggPendingDiscoverySince,_that.notificationsEnabled,_that.lastActionDate,_that.fcmToken,_that.totalCo2Grams,_that.totalActionsCount,_that.sdgStats,_that.viewedFactDates,_that.unlockedFactDates,_that.challengeCompletedDate,_that.challengeStreak,_that.challengesCompleted,_that.recentChallengeIds,_that.activeMultiDayChallenge,_that.completedMultiDayChallenges,_that.ecodexDiscovered,_that.uniqueActionIds,_that.categoryActionCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUserModel implements AppUserModel {
  const _AppUserModel({required this.uid, required this.email, this.displayName, this.photoUrl, this.personalGoal, this.points = 0, this.level = 1, this.currentStreak = 0, this.longestStreak = 0, this.language = 'en', this.notificationTime = '09:00', @TimestampConverter() this.createdAt, this.emailVerified = false, this.dailyGoalTarget,  List<MascotModel> mascots = const [], this.activeMascotId, this.egg, this.eggPendingDiscovery = false, @TimestampConverter() this.eggPendingDiscoverySince, this.notificationsEnabled = false, @TimestampConverter() this.lastActionDate, this.fcmToken, this.totalCo2Grams = 0, this.totalActionsCount = 0,  Map<String, Map<String, int>> sdgStats = const {},  List<String> viewedFactDates = const [],  List<String> unlockedFactDates = const [], this.challengeCompletedDate = '', this.challengeStreak = 0, this.challengesCompleted = 0,  List<String> recentChallengeIds = const [],  Map<String, dynamic> activeMultiDayChallenge = const {},  List<String> completedMultiDayChallenges = const [],  List<String> ecodexDiscovered = const [],  List<String> uniqueActionIds = const [],  Map<String, int> categoryActionCounts = const {}}): _mascots = mascots,_sdgStats = sdgStats,_viewedFactDates = viewedFactDates,_unlockedFactDates = unlockedFactDates,_recentChallengeIds = recentChallengeIds,_activeMultiDayChallenge = activeMultiDayChallenge,_completedMultiDayChallenges = completedMultiDayChallenges,_ecodexDiscovered = ecodexDiscovered,_uniqueActionIds = uniqueActionIds,_categoryActionCounts = categoryActionCounts;
  factory _AppUserModel.fromJson(Map<String, dynamic> json) => _$AppUserModelFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String? displayName;
@override final  String? photoUrl;
/// Personal sustainability goal: a preset ID or free text.
@override final  String? personalGoal;
@override@JsonKey() final  int points;
@override@JsonKey() final  int level;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override@JsonKey() final  String language;
@override@JsonKey() final  String notificationTime;
@override@TimestampConverter() final  DateTime? createdAt;
@override@JsonKey() final  bool emailVerified;
@override final  int? dailyGoalTarget;
/// All owned mascots.
 final  List<MascotModel> _mascots;
/// All owned mascots.
@override@JsonKey() List<MascotModel> get mascots {
  if (_mascots is EqualUnmodifiableListView) return _mascots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mascots);
}

/// ID of the currently active mascot.
@override final  String? activeMascotId;
/// Pending egg waiting to hatch.
@override final  EggModel? egg;
/// Flag set when a mascot maxes out evolution.
@override@JsonKey() final  bool eggPendingDiscovery;
/// When the egg pending discovery flag was set.
@override@TimestampConverter() final  DateTime? eggPendingDiscoverySince;
/// Master toggle for notifications.
@override@JsonKey() final  bool notificationsEnabled;
/// Date of the user's last logged action.
@override@TimestampConverter() final  DateTime? lastActionDate;
/// FCM token for push notifications.
@override final  String? fcmToken;
/// Total CO2 saved across all actions (grams).
@override@JsonKey() final  int totalCo2Grams;
/// Total number of actions logged.
@override@JsonKey() final  int totalActionsCount;
/// Per-SDG aggregated stats: { "1": { "count": 5, "co2": 1200 } }
 final  Map<String, Map<String, int>> _sdgStats;
/// Per-SDG aggregated stats: { "1": { "count": 5, "co2": 1200 } }
@override@JsonKey() Map<String, Map<String, int>> get sdgStats {
  if (_sdgStats is EqualUnmodifiableMapView) return _sdgStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_sdgStats);
}

/// Dates (yyyy-MM-dd) when the user viewed their daily eco-fact.
 final  List<String> _viewedFactDates;
/// Dates (yyyy-MM-dd) when the user viewed their daily eco-fact.
@override@JsonKey() List<String> get viewedFactDates {
  if (_viewedFactDates is EqualUnmodifiableListView) return _viewedFactDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_viewedFactDates);
}

/// Dates (yyyy-MM-dd) when the user's daily eco-fact was unlocked
/// (challenge completed). Distinct from viewedFactDates: a day can
/// be unlocked without being read.
 final  List<String> _unlockedFactDates;
/// Dates (yyyy-MM-dd) when the user's daily eco-fact was unlocked
/// (challenge completed). Distinct from viewedFactDates: a day can
/// be unlocked without being read.
@override@JsonKey() List<String> get unlockedFactDates {
  if (_unlockedFactDates is EqualUnmodifiableListView) return _unlockedFactDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unlockedFactDates);
}

/// Date (yyyy-MM-dd) when the user last completed a challenge.
@override@JsonKey() final  String challengeCompletedDate;
/// Consecutive days of challenge completion.
@override@JsonKey() final  int challengeStreak;
/// Lifetime count of challenges completed.
@override@JsonKey() final  int challengesCompleted;
/// Last N template IDs to avoid repetition.
 final  List<String> _recentChallengeIds;
/// Last N template IDs to avoid repetition.
@override@JsonKey() List<String> get recentChallengeIds {
  if (_recentChallengeIds is EqualUnmodifiableListView) return _recentChallengeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentChallengeIds);
}

/// Active multi-day challenge state map.
 final  Map<String, dynamic> _activeMultiDayChallenge;
/// Active multi-day challenge state map.
@override@JsonKey() Map<String, dynamic> get activeMultiDayChallenge {
  if (_activeMultiDayChallenge is EqualUnmodifiableMapView) return _activeMultiDayChallenge;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_activeMultiDayChallenge);
}

/// IDs of completed multi-day challenge templates.
 final  List<String> _completedMultiDayChallenges;
/// IDs of completed multi-day challenge templates.
@override@JsonKey() List<String> get completedMultiDayChallenges {
  if (_completedMultiDayChallenges is EqualUnmodifiableListView) return _completedMultiDayChallenges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedMultiDayChallenges);
}

/// IDs of discovered Eco-Dex entries.
 final  List<String> _ecodexDiscovered;
/// IDs of discovered Eco-Dex entries.
@override@JsonKey() List<String> get ecodexDiscovered {
  if (_ecodexDiscovered is EqualUnmodifiableListView) return _ecodexDiscovered;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ecodexDiscovered);
}

/// Distinct action IDs the user has ever logged.
 final  List<String> _uniqueActionIds;
/// Distinct action IDs the user has ever logged.
@override@JsonKey() List<String> get uniqueActionIds {
  if (_uniqueActionIds is EqualUnmodifiableListView) return _uniqueActionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uniqueActionIds);
}

/// Per-category action counts: { "food": 12, "energy": 5 }
 final  Map<String, int> _categoryActionCounts;
/// Per-category action counts: { "food": 12, "energy": 5 }
@override@JsonKey() Map<String, int> get categoryActionCounts {
  if (_categoryActionCounts is EqualUnmodifiableMapView) return _categoryActionCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoryActionCounts);
}


/// Create a copy of AppUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserModelCopyWith<_AppUserModel> get copyWith => __$AppUserModelCopyWithImpl<_AppUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUserModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.personalGoal, personalGoal) || other.personalGoal == personalGoal)&&(identical(other.points, points) || other.points == points)&&(identical(other.level, level) || other.level == level)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.language, language) || other.language == language)&&(identical(other.notificationTime, notificationTime) || other.notificationTime == notificationTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.dailyGoalTarget, dailyGoalTarget) || other.dailyGoalTarget == dailyGoalTarget)&&const DeepCollectionEquality().equals(other.mascots, _mascots)&&(identical(other.activeMascotId, activeMascotId) || other.activeMascotId == activeMascotId)&&(identical(other.egg, egg) || other.egg == egg)&&(identical(other.eggPendingDiscovery, eggPendingDiscovery) || other.eggPendingDiscovery == eggPendingDiscovery)&&(identical(other.eggPendingDiscoverySince, eggPendingDiscoverySince) || other.eggPendingDiscoverySince == eggPendingDiscoverySince)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.lastActionDate, lastActionDate) || other.lastActionDate == lastActionDate)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.totalCo2Grams, totalCo2Grams) || other.totalCo2Grams == totalCo2Grams)&&(identical(other.totalActionsCount, totalActionsCount) || other.totalActionsCount == totalActionsCount)&&const DeepCollectionEquality().equals(other.sdgStats, _sdgStats)&&const DeepCollectionEquality().equals(other.viewedFactDates, _viewedFactDates)&&const DeepCollectionEquality().equals(other.unlockedFactDates, _unlockedFactDates)&&(identical(other.challengeCompletedDate, challengeCompletedDate) || other.challengeCompletedDate == challengeCompletedDate)&&(identical(other.challengeStreak, challengeStreak) || other.challengeStreak == challengeStreak)&&(identical(other.challengesCompleted, challengesCompleted) || other.challengesCompleted == challengesCompleted)&&const DeepCollectionEquality().equals(other.recentChallengeIds, _recentChallengeIds)&&const DeepCollectionEquality().equals(other.activeMultiDayChallenge, _activeMultiDayChallenge)&&const DeepCollectionEquality().equals(other.completedMultiDayChallenges, _completedMultiDayChallenges)&&const DeepCollectionEquality().equals(other.ecodexDiscovered, _ecodexDiscovered)&&const DeepCollectionEquality().equals(other.uniqueActionIds, _uniqueActionIds)&&const DeepCollectionEquality().equals(other.categoryActionCounts, _categoryActionCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,uid,email,displayName,photoUrl,personalGoal,points,level,currentStreak,longestStreak,language,notificationTime,createdAt,emailVerified,dailyGoalTarget,const DeepCollectionEquality().hash(_mascots),activeMascotId,egg,eggPendingDiscovery,eggPendingDiscoverySince,notificationsEnabled,lastActionDate,fcmToken,totalCo2Grams,totalActionsCount,const DeepCollectionEquality().hash(_sdgStats),const DeepCollectionEquality().hash(_viewedFactDates),const DeepCollectionEquality().hash(_unlockedFactDates),challengeCompletedDate,challengeStreak,challengesCompleted,const DeepCollectionEquality().hash(_recentChallengeIds),const DeepCollectionEquality().hash(_activeMultiDayChallenge),const DeepCollectionEquality().hash(_completedMultiDayChallenges),const DeepCollectionEquality().hash(_ecodexDiscovered),const DeepCollectionEquality().hash(_uniqueActionIds),const DeepCollectionEquality().hash(_categoryActionCounts)]);
}

@override
String toString() {
    return 'AppUserModel(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, personalGoal: $personalGoal, points: $points, level: $level, currentStreak: $currentStreak, longestStreak: $longestStreak, language: $language, notificationTime: $notificationTime, createdAt: $createdAt, emailVerified: $emailVerified, dailyGoalTarget: $dailyGoalTarget, mascots: $mascots, activeMascotId: $activeMascotId, egg: $egg, eggPendingDiscovery: $eggPendingDiscovery, eggPendingDiscoverySince: $eggPendingDiscoverySince, notificationsEnabled: $notificationsEnabled, lastActionDate: $lastActionDate, fcmToken: $fcmToken, totalCo2Grams: $totalCo2Grams, totalActionsCount: $totalActionsCount, sdgStats: $sdgStats, viewedFactDates: $viewedFactDates, unlockedFactDates: $unlockedFactDates, challengeCompletedDate: $challengeCompletedDate, challengeStreak: $challengeStreak, challengesCompleted: $challengesCompleted, recentChallengeIds: $recentChallengeIds, activeMultiDayChallenge: $activeMultiDayChallenge, completedMultiDayChallenges: $completedMultiDayChallenges, ecodexDiscovered: $ecodexDiscovered, uniqueActionIds: $uniqueActionIds, categoryActionCounts: $categoryActionCounts)';
}


}

/// @nodoc
abstract mixin class _$AppUserModelCopyWith<$Res> implements $AppUserModelCopyWith<$Res> {
  factory _$AppUserModelCopyWith(_AppUserModel value, $Res Function(_AppUserModel) _then) = __$AppUserModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String? displayName, String? photoUrl, String? personalGoal, int points, int level, int currentStreak, int longestStreak, String language, String notificationTime,@TimestampConverter() DateTime? createdAt, bool emailVerified, int? dailyGoalTarget, List<MascotModel> mascots, String? activeMascotId, EggModel? egg, bool eggPendingDiscovery,@TimestampConverter() DateTime? eggPendingDiscoverySince, bool notificationsEnabled,@TimestampConverter() DateTime? lastActionDate, String? fcmToken, int totalCo2Grams, int totalActionsCount, Map<String, Map<String, int>> sdgStats, List<String> viewedFactDates, List<String> unlockedFactDates, String challengeCompletedDate, int challengeStreak, int challengesCompleted, List<String> recentChallengeIds, Map<String, dynamic> activeMultiDayChallenge, List<String> completedMultiDayChallenges, List<String> ecodexDiscovered, List<String> uniqueActionIds, Map<String, int> categoryActionCounts
});


@override $EggModelCopyWith<$Res>? get egg;

}
/// @nodoc
class __$AppUserModelCopyWithImpl<$Res>
    implements _$AppUserModelCopyWith<$Res> {
  __$AppUserModelCopyWithImpl(this._self, this._then);

  final _AppUserModel _self;
  final $Res Function(_AppUserModel) _then;

/// Create a copy of AppUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = freezed,Object? photoUrl = freezed,Object? personalGoal = freezed,Object? points = null,Object? level = null,Object? currentStreak = null,Object? longestStreak = null,Object? language = null,Object? notificationTime = null,Object? createdAt = freezed,Object? emailVerified = null,Object? dailyGoalTarget = freezed,Object? mascots = null,Object? activeMascotId = freezed,Object? egg = freezed,Object? eggPendingDiscovery = null,Object? eggPendingDiscoverySince = freezed,Object? notificationsEnabled = null,Object? lastActionDate = freezed,Object? fcmToken = freezed,Object? totalCo2Grams = null,Object? totalActionsCount = null,Object? sdgStats = null,Object? viewedFactDates = null,Object? unlockedFactDates = null,Object? challengeCompletedDate = null,Object? challengeStreak = null,Object? challengesCompleted = null,Object? recentChallengeIds = null,Object? activeMultiDayChallenge = null,Object? completedMultiDayChallenges = null,Object? ecodexDiscovered = null,Object? uniqueActionIds = null,Object? categoryActionCounts = null,}) {
  return _then(_AppUserModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,personalGoal: freezed == personalGoal ? _self.personalGoal : personalGoal // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,notificationTime: null == notificationTime ? _self.notificationTime : notificationTime // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,dailyGoalTarget: freezed == dailyGoalTarget ? _self.dailyGoalTarget : dailyGoalTarget // ignore: cast_nullable_to_non_nullable
as int?,mascots: null == mascots ? _self._mascots : mascots // ignore: cast_nullable_to_non_nullable
as List<MascotModel>,activeMascotId: freezed == activeMascotId ? _self.activeMascotId : activeMascotId // ignore: cast_nullable_to_non_nullable
as String?,egg: freezed == egg ? _self.egg : egg // ignore: cast_nullable_to_non_nullable
as EggModel?,eggPendingDiscovery: null == eggPendingDiscovery ? _self.eggPendingDiscovery : eggPendingDiscovery // ignore: cast_nullable_to_non_nullable
as bool,eggPendingDiscoverySince: freezed == eggPendingDiscoverySince ? _self.eggPendingDiscoverySince : eggPendingDiscoverySince // ignore: cast_nullable_to_non_nullable
as DateTime?,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,lastActionDate: freezed == lastActionDate ? _self.lastActionDate : lastActionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,totalCo2Grams: null == totalCo2Grams ? _self.totalCo2Grams : totalCo2Grams // ignore: cast_nullable_to_non_nullable
as int,totalActionsCount: null == totalActionsCount ? _self.totalActionsCount : totalActionsCount // ignore: cast_nullable_to_non_nullable
as int,sdgStats: null == sdgStats ? _self._sdgStats : sdgStats // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, int>>,viewedFactDates: null == viewedFactDates ? _self._viewedFactDates : viewedFactDates // ignore: cast_nullable_to_non_nullable
as List<String>,unlockedFactDates: null == unlockedFactDates ? _self._unlockedFactDates : unlockedFactDates // ignore: cast_nullable_to_non_nullable
as List<String>,challengeCompletedDate: null == challengeCompletedDate ? _self.challengeCompletedDate : challengeCompletedDate // ignore: cast_nullable_to_non_nullable
as String,challengeStreak: null == challengeStreak ? _self.challengeStreak : challengeStreak // ignore: cast_nullable_to_non_nullable
as int,challengesCompleted: null == challengesCompleted ? _self.challengesCompleted : challengesCompleted // ignore: cast_nullable_to_non_nullable
as int,recentChallengeIds: null == recentChallengeIds ? _self._recentChallengeIds : recentChallengeIds // ignore: cast_nullable_to_non_nullable
as List<String>,activeMultiDayChallenge: null == activeMultiDayChallenge ? _self._activeMultiDayChallenge : activeMultiDayChallenge // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,completedMultiDayChallenges: null == completedMultiDayChallenges ? _self._completedMultiDayChallenges : completedMultiDayChallenges // ignore: cast_nullable_to_non_nullable
as List<String>,ecodexDiscovered: null == ecodexDiscovered ? _self._ecodexDiscovered : ecodexDiscovered // ignore: cast_nullable_to_non_nullable
as List<String>,uniqueActionIds: null == uniqueActionIds ? _self._uniqueActionIds : uniqueActionIds // ignore: cast_nullable_to_non_nullable
as List<String>,categoryActionCounts: null == categoryActionCounts ? _self._categoryActionCounts : categoryActionCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

/// Create a copy of AppUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EggModelCopyWith<$Res>? get egg {
    if (_self.egg == null) {
    return null;
  }

  return $EggModelCopyWith<$Res>(_self.egg!, (value) {
    return _then(_self.copyWith(egg: value));
  });
}
}

// dart format on
