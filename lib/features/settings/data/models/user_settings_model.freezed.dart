// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettingsModel {

/// Daily reminder to complete the challenge that unlocks the fact.
 bool get notificationsEnabled;/// Local time of the daily reminder.
 int get reminderHour; int get reminderMinute;/// Master switch for the reminders in [actionReminders].
 bool get actionRemindersEnabled;/// Reminders the user set on library actions, by action id.
 Map<String, ActionReminder> get actionReminders;/// Language the user chose ('en', 'es' or 'ja'); null if never chosen.
 String? get language;/// Whether user has completed initial onboarding.
 bool get hasSeenOnboarding;/// Map of streak week milestones that have been seen.
/// Key: week number (1, 2, 3, etc.), Value: whether seen.
 Map<String, bool> get seenStreakMilestones;/// Whether the streak grace period has been used (Phase 4 foundation).
/// When true, user cannot use grace period again until streak resets.
 bool get streakGracePeriodUsed;/// Whether analytics and crashlytics collection is enabled.
 bool get analyticsEnabled;/// Preferred theme: a ThemeMode name ('system', 'light', 'dark').
 String get themeMode;/// Walkthrough item ids the user has found (see WalkthroughItem).
 List<String> get walkthroughFound;
/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsModelCopyWith<UserSettingsModel> get copyWith => _$UserSettingsModelCopyWithImpl<UserSettingsModel>(this as UserSettingsModel, _$identity);

  /// Serializes this UserSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserSettingsModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsModel&&(identical(other.notificationsEnabled, _this.notificationsEnabled) || other.notificationsEnabled == _this.notificationsEnabled)&&(identical(other.reminderHour, _this.reminderHour) || other.reminderHour == _this.reminderHour)&&(identical(other.reminderMinute, _this.reminderMinute) || other.reminderMinute == _this.reminderMinute)&&(identical(other.actionRemindersEnabled, _this.actionRemindersEnabled) || other.actionRemindersEnabled == _this.actionRemindersEnabled)&&const DeepCollectionEquality().equals(other.actionReminders, _this.actionReminders)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.hasSeenOnboarding, _this.hasSeenOnboarding) || other.hasSeenOnboarding == _this.hasSeenOnboarding)&&const DeepCollectionEquality().equals(other.seenStreakMilestones, _this.seenStreakMilestones)&&(identical(other.streakGracePeriodUsed, _this.streakGracePeriodUsed) || other.streakGracePeriodUsed == _this.streakGracePeriodUsed)&&(identical(other.analyticsEnabled, _this.analyticsEnabled) || other.analyticsEnabled == _this.analyticsEnabled)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&const DeepCollectionEquality().equals(other.walkthroughFound, _this.walkthroughFound));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserSettingsModel;
  return Object.hash(runtimeType,_this.notificationsEnabled,_this.reminderHour,_this.reminderMinute,_this.actionRemindersEnabled,const DeepCollectionEquality().hash(_this.actionReminders),_this.language,_this.hasSeenOnboarding,const DeepCollectionEquality().hash(_this.seenStreakMilestones),_this.streakGracePeriodUsed,_this.analyticsEnabled,_this.themeMode,const DeepCollectionEquality().hash(_this.walkthroughFound));
}

@override
String toString() {
  final _this = this as UserSettingsModel;
  return 'UserSettingsModel(notificationsEnabled: ${_this.notificationsEnabled}, reminderHour: ${_this.reminderHour}, reminderMinute: ${_this.reminderMinute}, actionRemindersEnabled: ${_this.actionRemindersEnabled}, actionReminders: ${_this.actionReminders}, language: ${_this.language}, hasSeenOnboarding: ${_this.hasSeenOnboarding}, seenStreakMilestones: ${_this.seenStreakMilestones}, streakGracePeriodUsed: ${_this.streakGracePeriodUsed}, analyticsEnabled: ${_this.analyticsEnabled}, themeMode: ${_this.themeMode}, walkthroughFound: ${_this.walkthroughFound})';
}


}

/// @nodoc
abstract mixin class $UserSettingsModelCopyWith<$Res>  {
  factory $UserSettingsModelCopyWith(UserSettingsModel value, $Res Function(UserSettingsModel) _then) = _$UserSettingsModelCopyWithImpl;
@useResult
$Res call({
 bool notificationsEnabled, int reminderHour, int reminderMinute, bool actionRemindersEnabled, Map<String, ActionReminder> actionReminders, String? language, bool hasSeenOnboarding, Map<String, bool> seenStreakMilestones, bool streakGracePeriodUsed, bool analyticsEnabled, String themeMode, List<String> walkthroughFound
});




}
/// @nodoc
class _$UserSettingsModelCopyWithImpl<$Res>
    implements $UserSettingsModelCopyWith<$Res> {
  _$UserSettingsModelCopyWithImpl(this._self, this._then);

  final UserSettingsModel _self;
  final $Res Function(UserSettingsModel) _then;

/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationsEnabled = null,Object? reminderHour = null,Object? reminderMinute = null,Object? actionRemindersEnabled = null,Object? actionReminders = null,Object? language = freezed,Object? hasSeenOnboarding = null,Object? seenStreakMilestones = null,Object? streakGracePeriodUsed = null,Object? analyticsEnabled = null,Object? themeMode = null,Object? walkthroughFound = null,}) {
  return _then(UserSettingsModel(
notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderHour: null == reminderHour ? _self.reminderHour : reminderHour // ignore: cast_nullable_to_non_nullable
as int,reminderMinute: null == reminderMinute ? _self.reminderMinute : reminderMinute // ignore: cast_nullable_to_non_nullable
as int,actionRemindersEnabled: null == actionRemindersEnabled ? _self.actionRemindersEnabled : actionRemindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,actionReminders: null == actionReminders ? _self.actionReminders : actionReminders // ignore: cast_nullable_to_non_nullable
as Map<String, ActionReminder>,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,hasSeenOnboarding: null == hasSeenOnboarding ? _self.hasSeenOnboarding : hasSeenOnboarding // ignore: cast_nullable_to_non_nullable
as bool,seenStreakMilestones: null == seenStreakMilestones ? _self.seenStreakMilestones : seenStreakMilestones // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,streakGracePeriodUsed: null == streakGracePeriodUsed ? _self.streakGracePeriodUsed : streakGracePeriodUsed // ignore: cast_nullable_to_non_nullable
as bool,analyticsEnabled: null == analyticsEnabled ? _self.analyticsEnabled : analyticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,walkthroughFound: null == walkthroughFound ? _self.walkthroughFound : walkthroughFound // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettingsModel].
extension UserSettingsModelPatterns on UserSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _UserSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool notificationsEnabled,  int reminderHour,  int reminderMinute,  bool actionRemindersEnabled,  Map<String, ActionReminder> actionReminders,  String? language,  bool hasSeenOnboarding,  Map<String, bool> seenStreakMilestones,  bool streakGracePeriodUsed,  bool analyticsEnabled,  String themeMode,  List<String> walkthroughFound)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettingsModel() when $default != null:
return $default(_that.notificationsEnabled,_that.reminderHour,_that.reminderMinute,_that.actionRemindersEnabled,_that.actionReminders,_that.language,_that.hasSeenOnboarding,_that.seenStreakMilestones,_that.streakGracePeriodUsed,_that.analyticsEnabled,_that.themeMode,_that.walkthroughFound);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool notificationsEnabled,  int reminderHour,  int reminderMinute,  bool actionRemindersEnabled,  Map<String, ActionReminder> actionReminders,  String? language,  bool hasSeenOnboarding,  Map<String, bool> seenStreakMilestones,  bool streakGracePeriodUsed,  bool analyticsEnabled,  String themeMode,  List<String> walkthroughFound)  $default,) {final _that = this;
switch (_that) {
case _UserSettingsModel():
return $default(_that.notificationsEnabled,_that.reminderHour,_that.reminderMinute,_that.actionRemindersEnabled,_that.actionReminders,_that.language,_that.hasSeenOnboarding,_that.seenStreakMilestones,_that.streakGracePeriodUsed,_that.analyticsEnabled,_that.themeMode,_that.walkthroughFound);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool notificationsEnabled,  int reminderHour,  int reminderMinute,  bool actionRemindersEnabled,  Map<String, ActionReminder> actionReminders,  String? language,  bool hasSeenOnboarding,  Map<String, bool> seenStreakMilestones,  bool streakGracePeriodUsed,  bool analyticsEnabled,  String themeMode,  List<String> walkthroughFound)?  $default,) {final _that = this;
switch (_that) {
case _UserSettingsModel() when $default != null:
return $default(_that.notificationsEnabled,_that.reminderHour,_that.reminderMinute,_that.actionRemindersEnabled,_that.actionReminders,_that.language,_that.hasSeenOnboarding,_that.seenStreakMilestones,_that.streakGracePeriodUsed,_that.analyticsEnabled,_that.themeMode,_that.walkthroughFound);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSettingsModel extends UserSettingsModel {
  const _UserSettingsModel({this.notificationsEnabled = false, this.reminderHour = AppConstants.defaultReminderHour, this.reminderMinute = AppConstants.defaultReminderMinute, this.actionRemindersEnabled = false,  Map<String, ActionReminder> actionReminders = const {}, this.language, this.hasSeenOnboarding = false,  Map<String, bool> seenStreakMilestones = const {}, this.streakGracePeriodUsed = false, this.analyticsEnabled = true, this.themeMode = 'system',  List<String> walkthroughFound = const []}): _actionReminders = actionReminders,_seenStreakMilestones = seenStreakMilestones,_walkthroughFound = walkthroughFound,super._();
  factory _UserSettingsModel.fromJson(Map<String, dynamic> json) => _$UserSettingsModelFromJson(json);

/// Daily reminder to complete the challenge that unlocks the fact.
@override@JsonKey() final  bool notificationsEnabled;
/// Local time of the daily reminder.
@override@JsonKey() final  int reminderHour;
@override@JsonKey() final  int reminderMinute;
/// Master switch for the reminders in [actionReminders].
@override@JsonKey() final  bool actionRemindersEnabled;
/// Reminders the user set on library actions, by action id.
 final  Map<String, ActionReminder> _actionReminders;
/// Reminders the user set on library actions, by action id.
@override@JsonKey() Map<String, ActionReminder> get actionReminders {
  if (_actionReminders is EqualUnmodifiableMapView) return _actionReminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_actionReminders);
}

/// Language the user chose ('en', 'es' or 'ja'); null if never chosen.
@override final  String? language;
/// Whether user has completed initial onboarding.
@override@JsonKey() final  bool hasSeenOnboarding;
/// Map of streak week milestones that have been seen.
/// Key: week number (1, 2, 3, etc.), Value: whether seen.
 final  Map<String, bool> _seenStreakMilestones;
/// Map of streak week milestones that have been seen.
/// Key: week number (1, 2, 3, etc.), Value: whether seen.
@override@JsonKey() Map<String, bool> get seenStreakMilestones {
  if (_seenStreakMilestones is EqualUnmodifiableMapView) return _seenStreakMilestones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_seenStreakMilestones);
}

/// Whether the streak grace period has been used (Phase 4 foundation).
/// When true, user cannot use grace period again until streak resets.
@override@JsonKey() final  bool streakGracePeriodUsed;
/// Whether analytics and crashlytics collection is enabled.
@override@JsonKey() final  bool analyticsEnabled;
/// Preferred theme: a ThemeMode name ('system', 'light', 'dark').
@override@JsonKey() final  String themeMode;
/// Walkthrough item ids the user has found (see WalkthroughItem).
 final  List<String> _walkthroughFound;
/// Walkthrough item ids the user has found (see WalkthroughItem).
@override@JsonKey() List<String> get walkthroughFound {
  if (_walkthroughFound is EqualUnmodifiableListView) return _walkthroughFound;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_walkthroughFound);
}


/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsModelCopyWith<_UserSettingsModel> get copyWith => __$UserSettingsModelCopyWithImpl<_UserSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettingsModel&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.reminderHour, reminderHour) || other.reminderHour == reminderHour)&&(identical(other.reminderMinute, reminderMinute) || other.reminderMinute == reminderMinute)&&(identical(other.actionRemindersEnabled, actionRemindersEnabled) || other.actionRemindersEnabled == actionRemindersEnabled)&&const DeepCollectionEquality().equals(other.actionReminders, _actionReminders)&&(identical(other.language, language) || other.language == language)&&(identical(other.hasSeenOnboarding, hasSeenOnboarding) || other.hasSeenOnboarding == hasSeenOnboarding)&&const DeepCollectionEquality().equals(other.seenStreakMilestones, _seenStreakMilestones)&&(identical(other.streakGracePeriodUsed, streakGracePeriodUsed) || other.streakGracePeriodUsed == streakGracePeriodUsed)&&(identical(other.analyticsEnabled, analyticsEnabled) || other.analyticsEnabled == analyticsEnabled)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&const DeepCollectionEquality().equals(other.walkthroughFound, _walkthroughFound));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,notificationsEnabled,reminderHour,reminderMinute,actionRemindersEnabled,const DeepCollectionEquality().hash(_actionReminders),language,hasSeenOnboarding,const DeepCollectionEquality().hash(_seenStreakMilestones),streakGracePeriodUsed,analyticsEnabled,themeMode,const DeepCollectionEquality().hash(_walkthroughFound));
}

@override
String toString() {
    return 'UserSettingsModel(notificationsEnabled: $notificationsEnabled, reminderHour: $reminderHour, reminderMinute: $reminderMinute, actionRemindersEnabled: $actionRemindersEnabled, actionReminders: $actionReminders, language: $language, hasSeenOnboarding: $hasSeenOnboarding, seenStreakMilestones: $seenStreakMilestones, streakGracePeriodUsed: $streakGracePeriodUsed, analyticsEnabled: $analyticsEnabled, themeMode: $themeMode, walkthroughFound: $walkthroughFound)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsModelCopyWith<$Res> implements $UserSettingsModelCopyWith<$Res> {
  factory _$UserSettingsModelCopyWith(_UserSettingsModel value, $Res Function(_UserSettingsModel) _then) = __$UserSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 bool notificationsEnabled, int reminderHour, int reminderMinute, bool actionRemindersEnabled, Map<String, ActionReminder> actionReminders, String? language, bool hasSeenOnboarding, Map<String, bool> seenStreakMilestones, bool streakGracePeriodUsed, bool analyticsEnabled, String themeMode, List<String> walkthroughFound
});




}
/// @nodoc
class __$UserSettingsModelCopyWithImpl<$Res>
    implements _$UserSettingsModelCopyWith<$Res> {
  __$UserSettingsModelCopyWithImpl(this._self, this._then);

  final _UserSettingsModel _self;
  final $Res Function(_UserSettingsModel) _then;

/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationsEnabled = null,Object? reminderHour = null,Object? reminderMinute = null,Object? actionRemindersEnabled = null,Object? actionReminders = null,Object? language = freezed,Object? hasSeenOnboarding = null,Object? seenStreakMilestones = null,Object? streakGracePeriodUsed = null,Object? analyticsEnabled = null,Object? themeMode = null,Object? walkthroughFound = null,}) {
  return _then(_UserSettingsModel(
notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderHour: null == reminderHour ? _self.reminderHour : reminderHour // ignore: cast_nullable_to_non_nullable
as int,reminderMinute: null == reminderMinute ? _self.reminderMinute : reminderMinute // ignore: cast_nullable_to_non_nullable
as int,actionRemindersEnabled: null == actionRemindersEnabled ? _self.actionRemindersEnabled : actionRemindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,actionReminders: null == actionReminders ? _self._actionReminders : actionReminders // ignore: cast_nullable_to_non_nullable
as Map<String, ActionReminder>,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,hasSeenOnboarding: null == hasSeenOnboarding ? _self.hasSeenOnboarding : hasSeenOnboarding // ignore: cast_nullable_to_non_nullable
as bool,seenStreakMilestones: null == seenStreakMilestones ? _self._seenStreakMilestones : seenStreakMilestones // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,streakGracePeriodUsed: null == streakGracePeriodUsed ? _self.streakGracePeriodUsed : streakGracePeriodUsed // ignore: cast_nullable_to_non_nullable
as bool,analyticsEnabled: null == analyticsEnabled ? _self.analyticsEnabled : analyticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,walkthroughFound: null == walkthroughFound ? _self._walkthroughFound : walkthroughFound // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
