// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettingsModel {

/// Master toggle for all notifications.
 bool get notificationsEnabled;/// List of scheduled reminder times (max 5).
 List<NotificationScheduleModel> get reminderSchedules;/// Whether to use smart reminders (only notify if no action logged today).
 bool get smartRemindersEnabled;/// Preferred language code ('en' or 'ja').
 String get language;/// Whether user has completed initial onboarding.
 bool get hasSeenOnboarding;/// Map of streak week milestones that have been seen.
/// Key: week number (1, 2, 3, etc.), Value: whether seen.
 Map<String, bool> get seenStreakMilestones;/// Whether the streak grace period has been used (Phase 4 foundation).
/// When true, user cannot use grace period again until streak resets.
 bool get streakGracePeriodUsed;/// Whether analytics and crashlytics collection is enabled.
 bool get analyticsEnabled;
/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsModelCopyWith<UserSettingsModel> get copyWith => _$UserSettingsModelCopyWithImpl<UserSettingsModel>(this as UserSettingsModel, _$identity);

  /// Serializes this UserSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsModel&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&const DeepCollectionEquality().equals(other.reminderSchedules, reminderSchedules)&&(identical(other.smartRemindersEnabled, smartRemindersEnabled) || other.smartRemindersEnabled == smartRemindersEnabled)&&(identical(other.language, language) || other.language == language)&&(identical(other.hasSeenOnboarding, hasSeenOnboarding) || other.hasSeenOnboarding == hasSeenOnboarding)&&const DeepCollectionEquality().equals(other.seenStreakMilestones, seenStreakMilestones)&&(identical(other.streakGracePeriodUsed, streakGracePeriodUsed) || other.streakGracePeriodUsed == streakGracePeriodUsed)&&(identical(other.analyticsEnabled, analyticsEnabled) || other.analyticsEnabled == analyticsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationsEnabled,const DeepCollectionEquality().hash(reminderSchedules),smartRemindersEnabled,language,hasSeenOnboarding,const DeepCollectionEquality().hash(seenStreakMilestones),streakGracePeriodUsed,analyticsEnabled);

@override
String toString() {
  return 'UserSettingsModel(notificationsEnabled: $notificationsEnabled, reminderSchedules: $reminderSchedules, smartRemindersEnabled: $smartRemindersEnabled, language: $language, hasSeenOnboarding: $hasSeenOnboarding, seenStreakMilestones: $seenStreakMilestones, streakGracePeriodUsed: $streakGracePeriodUsed, analyticsEnabled: $analyticsEnabled)';
}


}

/// @nodoc
abstract mixin class $UserSettingsModelCopyWith<$Res>  {
  factory $UserSettingsModelCopyWith(UserSettingsModel value, $Res Function(UserSettingsModel) _then) = _$UserSettingsModelCopyWithImpl;
@useResult
$Res call({
 bool notificationsEnabled, List<NotificationScheduleModel> reminderSchedules, bool smartRemindersEnabled, String language, bool hasSeenOnboarding, Map<String, bool> seenStreakMilestones, bool streakGracePeriodUsed, bool analyticsEnabled
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
@pragma('vm:prefer-inline') @override $Res call({Object? notificationsEnabled = null,Object? reminderSchedules = null,Object? smartRemindersEnabled = null,Object? language = null,Object? hasSeenOnboarding = null,Object? seenStreakMilestones = null,Object? streakGracePeriodUsed = null,Object? analyticsEnabled = null,}) {
  return _then(_self.copyWith(
notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderSchedules: null == reminderSchedules ? _self.reminderSchedules : reminderSchedules // ignore: cast_nullable_to_non_nullable
as List<NotificationScheduleModel>,smartRemindersEnabled: null == smartRemindersEnabled ? _self.smartRemindersEnabled : smartRemindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,hasSeenOnboarding: null == hasSeenOnboarding ? _self.hasSeenOnboarding : hasSeenOnboarding // ignore: cast_nullable_to_non_nullable
as bool,seenStreakMilestones: null == seenStreakMilestones ? _self.seenStreakMilestones : seenStreakMilestones // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,streakGracePeriodUsed: null == streakGracePeriodUsed ? _self.streakGracePeriodUsed : streakGracePeriodUsed // ignore: cast_nullable_to_non_nullable
as bool,analyticsEnabled: null == analyticsEnabled ? _self.analyticsEnabled : analyticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool notificationsEnabled,  List<NotificationScheduleModel> reminderSchedules,  bool smartRemindersEnabled,  String language,  bool hasSeenOnboarding,  Map<String, bool> seenStreakMilestones,  bool streakGracePeriodUsed,  bool analyticsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettingsModel() when $default != null:
return $default(_that.notificationsEnabled,_that.reminderSchedules,_that.smartRemindersEnabled,_that.language,_that.hasSeenOnboarding,_that.seenStreakMilestones,_that.streakGracePeriodUsed,_that.analyticsEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool notificationsEnabled,  List<NotificationScheduleModel> reminderSchedules,  bool smartRemindersEnabled,  String language,  bool hasSeenOnboarding,  Map<String, bool> seenStreakMilestones,  bool streakGracePeriodUsed,  bool analyticsEnabled)  $default,) {final _that = this;
switch (_that) {
case _UserSettingsModel():
return $default(_that.notificationsEnabled,_that.reminderSchedules,_that.smartRemindersEnabled,_that.language,_that.hasSeenOnboarding,_that.seenStreakMilestones,_that.streakGracePeriodUsed,_that.analyticsEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool notificationsEnabled,  List<NotificationScheduleModel> reminderSchedules,  bool smartRemindersEnabled,  String language,  bool hasSeenOnboarding,  Map<String, bool> seenStreakMilestones,  bool streakGracePeriodUsed,  bool analyticsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UserSettingsModel() when $default != null:
return $default(_that.notificationsEnabled,_that.reminderSchedules,_that.smartRemindersEnabled,_that.language,_that.hasSeenOnboarding,_that.seenStreakMilestones,_that.streakGracePeriodUsed,_that.analyticsEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSettingsModel extends UserSettingsModel {
  const _UserSettingsModel({this.notificationsEnabled = true, final  List<NotificationScheduleModel> reminderSchedules = const [], this.smartRemindersEnabled = true, this.language = 'en', this.hasSeenOnboarding = false, final  Map<String, bool> seenStreakMilestones = const {}, this.streakGracePeriodUsed = false, this.analyticsEnabled = true}): _reminderSchedules = reminderSchedules,_seenStreakMilestones = seenStreakMilestones,super._();
  factory _UserSettingsModel.fromJson(Map<String, dynamic> json) => _$UserSettingsModelFromJson(json);

/// Master toggle for all notifications.
@override@JsonKey() final  bool notificationsEnabled;
/// List of scheduled reminder times (max 5).
 final  List<NotificationScheduleModel> _reminderSchedules;
/// List of scheduled reminder times (max 5).
@override@JsonKey() List<NotificationScheduleModel> get reminderSchedules {
  if (_reminderSchedules is EqualUnmodifiableListView) return _reminderSchedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminderSchedules);
}

/// Whether to use smart reminders (only notify if no action logged today).
@override@JsonKey() final  bool smartRemindersEnabled;
/// Preferred language code ('en' or 'ja').
@override@JsonKey() final  String language;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettingsModel&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&const DeepCollectionEquality().equals(other._reminderSchedules, _reminderSchedules)&&(identical(other.smartRemindersEnabled, smartRemindersEnabled) || other.smartRemindersEnabled == smartRemindersEnabled)&&(identical(other.language, language) || other.language == language)&&(identical(other.hasSeenOnboarding, hasSeenOnboarding) || other.hasSeenOnboarding == hasSeenOnboarding)&&const DeepCollectionEquality().equals(other._seenStreakMilestones, _seenStreakMilestones)&&(identical(other.streakGracePeriodUsed, streakGracePeriodUsed) || other.streakGracePeriodUsed == streakGracePeriodUsed)&&(identical(other.analyticsEnabled, analyticsEnabled) || other.analyticsEnabled == analyticsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationsEnabled,const DeepCollectionEquality().hash(_reminderSchedules),smartRemindersEnabled,language,hasSeenOnboarding,const DeepCollectionEquality().hash(_seenStreakMilestones),streakGracePeriodUsed,analyticsEnabled);

@override
String toString() {
  return 'UserSettingsModel(notificationsEnabled: $notificationsEnabled, reminderSchedules: $reminderSchedules, smartRemindersEnabled: $smartRemindersEnabled, language: $language, hasSeenOnboarding: $hasSeenOnboarding, seenStreakMilestones: $seenStreakMilestones, streakGracePeriodUsed: $streakGracePeriodUsed, analyticsEnabled: $analyticsEnabled)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsModelCopyWith<$Res> implements $UserSettingsModelCopyWith<$Res> {
  factory _$UserSettingsModelCopyWith(_UserSettingsModel value, $Res Function(_UserSettingsModel) _then) = __$UserSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 bool notificationsEnabled, List<NotificationScheduleModel> reminderSchedules, bool smartRemindersEnabled, String language, bool hasSeenOnboarding, Map<String, bool> seenStreakMilestones, bool streakGracePeriodUsed, bool analyticsEnabled
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
@override @pragma('vm:prefer-inline') $Res call({Object? notificationsEnabled = null,Object? reminderSchedules = null,Object? smartRemindersEnabled = null,Object? language = null,Object? hasSeenOnboarding = null,Object? seenStreakMilestones = null,Object? streakGracePeriodUsed = null,Object? analyticsEnabled = null,}) {
  return _then(_UserSettingsModel(
notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderSchedules: null == reminderSchedules ? _self._reminderSchedules : reminderSchedules // ignore: cast_nullable_to_non_nullable
as List<NotificationScheduleModel>,smartRemindersEnabled: null == smartRemindersEnabled ? _self.smartRemindersEnabled : smartRemindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,hasSeenOnboarding: null == hasSeenOnboarding ? _self.hasSeenOnboarding : hasSeenOnboarding // ignore: cast_nullable_to_non_nullable
as bool,seenStreakMilestones: null == seenStreakMilestones ? _self._seenStreakMilestones : seenStreakMilestones // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,streakGracePeriodUsed: null == streakGracePeriodUsed ? _self.streakGracePeriodUsed : streakGracePeriodUsed // ignore: cast_nullable_to_non_nullable
as bool,analyticsEnabled: null == analyticsEnabled ? _self.analyticsEnabled : analyticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
