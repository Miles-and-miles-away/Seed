// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUserModel _$AppUserModelFromJson(Map<String, dynamic> json) =>
    _AppUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      personalGoal: json['personalGoal'] as String?,
      points: (json['points'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      language: json['language'] as String? ?? 'en',
      notificationTime: json['notificationTime'] as String? ?? '09:00',
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp?,
      ),
      emailVerified: json['emailVerified'] as bool? ?? false,
      dailyGoalTarget: (json['dailyGoalTarget'] as num?)?.toInt(),
      mascots:
          (json['mascots'] as List<dynamic>?)
              ?.map((e) => MascotModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activeMascotId: json['activeMascotId'] as String?,
      egg: json['egg'] == null
          ? null
          : EggModel.fromJson(json['egg'] as Map<String, dynamic>),
      eggPendingDiscovery: json['eggPendingDiscovery'] as bool? ?? false,
      eggPendingDiscoverySince: const TimestampConverter().fromJson(
        json['eggPendingDiscoverySince'] as Timestamp?,
      ),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      lastActionDate: const TimestampConverter().fromJson(
        json['lastActionDate'] as Timestamp?,
      ),
      fcmToken: json['fcmToken'] as String?,
      totalCo2Grams: (json['totalCo2Grams'] as num?)?.toInt() ?? 0,
      totalActionsCount: (json['totalActionsCount'] as num?)?.toInt() ?? 0,
      sdgStats:
          (json['sdgStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Map<String, int>.from(e as Map)),
          ) ??
          const {},
      viewedFactDates:
          (json['viewedFactDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      unlockedFactDates:
          (json['unlockedFactDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      challengeCompletedDate: json['challengeCompletedDate'] as String? ?? '',
      challengeStreak: (json['challengeStreak'] as num?)?.toInt() ?? 0,
      challengesCompleted: (json['challengesCompleted'] as num?)?.toInt() ?? 0,
      recentChallengeIds:
          (json['recentChallengeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      activeMultiDayChallenge:
          json['activeMultiDayChallenge'] as Map<String, dynamic>? ?? const {},
      completedMultiDayChallenges:
          (json['completedMultiDayChallenges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ecodexDiscovered:
          (json['ecodexDiscovered'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      uniqueActionIds:
          (json['uniqueActionIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categoryActionCounts:
          (json['categoryActionCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$AppUserModelToJson(
  _AppUserModel instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoUrl': instance.photoUrl,
  'personalGoal': instance.personalGoal,
  'points': instance.points,
  'level': instance.level,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'language': instance.language,
  'notificationTime': instance.notificationTime,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'emailVerified': instance.emailVerified,
  'dailyGoalTarget': instance.dailyGoalTarget,
  'mascots': instance.mascots,
  'activeMascotId': instance.activeMascotId,
  'egg': instance.egg,
  'eggPendingDiscovery': instance.eggPendingDiscovery,
  'eggPendingDiscoverySince': const TimestampConverter().toJson(
    instance.eggPendingDiscoverySince,
  ),
  'notificationsEnabled': instance.notificationsEnabled,
  'lastActionDate': const TimestampConverter().toJson(instance.lastActionDate),
  'fcmToken': instance.fcmToken,
  'totalCo2Grams': instance.totalCo2Grams,
  'totalActionsCount': instance.totalActionsCount,
  'sdgStats': instance.sdgStats,
  'viewedFactDates': instance.viewedFactDates,
  'unlockedFactDates': instance.unlockedFactDates,
  'challengeCompletedDate': instance.challengeCompletedDate,
  'challengeStreak': instance.challengeStreak,
  'challengesCompleted': instance.challengesCompleted,
  'recentChallengeIds': instance.recentChallengeIds,
  'activeMultiDayChallenge': instance.activeMultiDayChallenge,
  'completedMultiDayChallenges': instance.completedMultiDayChallenges,
  'ecodexDiscovered': instance.ecodexDiscovered,
  'uniqueActionIds': instance.uniqueActionIds,
  'categoryActionCounts': instance.categoryActionCounts,
};
