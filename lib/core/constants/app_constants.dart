/// App-wide constants
abstract class AppConstants {
  // Level system
  static const pointsPerLevel = 100; // Base points needed per level
  // Each level requires 1.05x more points than the last. Tuned so a
  // full evolution (level 50, ~19,800 cumulative points) takes ~4-5
  // months at ~150 points/day; stage 2 ~1 week, stage 3 ~4 weeks.
  static const levelScalingFactor = 1.05;

  // Mascot evolution thresholds
  static const evolutionStage1Level = 1;
  static const evolutionStage2Level = 10;
  static const evolutionStage3Level = 25;
  static const evolutionStage4Level = 50;

  // Notification defaults (default reminder time for the postponed reminder
  // feature -- currently hardcoded as 9:00 in user_settings_model.dart and
  // notification_settings_screen.dart; centralize here when it's revived).
  static const defaultReminderHour = 9;
  static const defaultReminderMinute = 0;

  // Firebase collections
  static const collectionUsers = 'users';
  static const collectionActionLog = 'actionLog';
  static const collectionActionLibrary = 'actionLibrary';
  static const collectionMascotSpecies = 'mascotSpecies';
  static const collectionCosmeticItems = 'cosmeticItems';
  static const collectionDailySummaries = 'dailySummaries';

  // SDG bounds
  static const sdgMinGoal = 1;
  static const sdgMaxGoal = 17;

  // SDG URLs
  static const sdgGoalsUrl = 'https://sdgs.un.org/goals';

  // Egg & hatching system
  static const eggHatchingStreakRequired = 30;
  static const maxEvolutionLevel = 50;
  static const maxMascotsPerUser = 20;
  static const maxMascotNameLength = 20;

  // Auth throttling
  static const authCooldownSeconds = 3;

  // User profile limits
  static const maxDisplayNameLength = 50;
  static const maxPersonalGoalLength = 100;
  static const maxNoteLength = 200;

  // Daily challenges
  static const recentChallengeIdsLimit = 7;

  // Firestore user document fields
  static const fieldDisplayName = 'displayName';
  static const fieldPersonalGoal = 'personalGoal';
  static const fieldPoints = 'points';
  static const fieldLevel = 'level';
  static const fieldCurrentStreak = 'currentStreak';
  static const fieldLongestStreak = 'longestStreak';
  static const fieldLastActionDate = 'lastActionDate';
  static const fieldTotalCo2Grams = 'totalCo2Grams';
  static const fieldTotalActionsCount = 'totalActionsCount';
  static const fieldCategoryActionCounts = 'categoryActionCounts';
  static const fieldUniqueActionIds = 'uniqueActionIds';
  static const fieldSdgStats = 'sdgStats';
  static const fieldActiveMascotId = 'activeMascotId';
  static const fieldMascots = 'mascots';
  static const fieldEgg = 'egg';
  static const fieldEggPendingDiscovery = 'eggPendingDiscovery';
  static const fieldEggPendingDiscoverySince = 'eggPendingDiscoverySince';
  static const fieldEmailVerified = 'emailVerified';
  static const fieldSettings = 'settings';
  static const fieldLanguage = 'language';
  static const fieldNotificationsEnabled = 'notificationsEnabled';
  static const fieldDailyGoalTarget = 'dailyGoalTarget';

  // Firestore eco-fact fields
  static const fieldViewedFactDates = 'viewedFactDates';
  static const fieldUnlockedFactDates = 'unlockedFactDates';

  // Firestore eco-dex fields
  static const fieldEcodexDiscovered = 'ecodexDiscovered';

  // Firestore challenge fields
  static const fieldChallengeCompletedDate = 'challengeCompletedDate';
  static const fieldChallengeStreak = 'challengeStreak';
  static const fieldChallengesCompleted = 'challengesCompleted';
  static const fieldRecentChallengeIds = 'recentChallengeIds';
  static const fieldActiveMultiDayChallenge = 'activeMultiDayChallenge';
  static const fieldCompletedMultiDayChallenges = 'completedMultiDayChallenges';

  // Firestore mascot nested fields
  static const fieldId = 'id';
  static const fieldName = 'name';
  static const fieldMascotPoints = 'mascotPoints';
  static const fieldMascotLevel = 'mascotLevel';
  static const fieldMascotCo2Grams = 'co2SavedGrams';
  static const fieldIsFullyEvolved = 'isFullyEvolved';
  static const fieldLastSeenStage = 'lastSeenStage';
  static const fieldSpeciesId = 'speciesId';

  // Firestore egg nested fields
  static const fieldHatchingStreakDays = 'hatchingStreakDays';
  static const fieldLastHatchingActivityDate = 'lastHatchingActivityDate';

  // Firestore settings nested fields
  static const fieldReminderSchedules = 'reminderSchedules';
  static const fieldSmartRemindersEnabled = 'smartRemindersEnabled';
  static const fieldAnalyticsEnabled = 'analyticsEnabled';
  static const fieldSeenStreakMilestones = 'seenStreakMilestones';

  // Firestore action library fields
  static const fieldIsActive = 'isActive';
  static const fieldSortOrder = 'sortOrder';
  static const fieldLoggedAt = 'loggedAt';

  // Firestore daily summary fields
  static const fieldDate = 'date';
  static const fieldGoalCount = 'goalCount';
  static const fieldCompletedSdgs = 'completedSdgs';
  static const fieldTotalPoints = 'totalPoints';
  static const fieldUpdatedAt = 'updatedAt';
  static const fieldCategoryCo2Grams = 'categoryCo2Grams';

  // Firestore SDG stats nested fields
  static const fieldCount = 'count';
  static const fieldCo2 = 'co2';

  // Firestore multi-day challenge nested fields
  static const fieldTemplateId = 'templateId';
  static const fieldStartDate = 'startDate';
  static const fieldCurrentDay = 'currentDay';
  static const fieldTargetDays = 'targetDays';
  static const fieldLastCompletionDate = 'lastCompletionDate';

  // Firestore reminder schedule nested fields
  static const fieldHour = 'hour';
  static const fieldMinute = 'minute';
  static const fieldIsEnabled = 'isEnabled';
  static const fieldLabel = 'label';
}
