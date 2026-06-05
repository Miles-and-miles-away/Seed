/// App-wide constants
abstract class AppConstants {
  // App info
  static const appName = 'Seed';
  static const appTagline = 'Grow your sustainability habits';

  // Level system
  static const pointsPerLevel = 100; // Base points needed per level
  static const levelScalingFactor = 1.5; // Each level requires 1.5x more points

  // Streaks
  static const maxStreakBonus = 2.0; // Max 2x points at streak 30+
  static const streakBonusPerDay = 0.033; // ~1% bonus per day

  // Mascot evolution thresholds
  static const evolutionStage1Level = 1;
  static const evolutionStage2Level = 10;
  static const evolutionStage3Level = 25;
  static const evolutionStage4Level = 50;

  // Notification defaults
  static const defaultReminderHour = 9;
  static const defaultReminderMinute = 0;

  // API/Network
  static const apiTimeout = Duration(seconds: 30);
  static const maxRetries = 3;

  // Local storage keys
  static const keyOnboardingComplete = 'onboarding_complete';
  static const keyNotificationTime = 'notification_time';
  static const keyLanguage = 'language';
  static const keyThemeMode = 'theme_mode';

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

  // Auth throttling
  static const authCooldownSeconds = 3;

  // Daily challenges
  static const recentChallengeIdsLimit = 7;

  // Firestore user document fields
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

/// Point values for common actions (move to database later)
abstract class ActionPoints {
  static const recycleAluminumCan = 5;
  static const recyclePlasticBottle = 3;
  static const recycleCardboard = 2;
  static const reusableBag = 2;
  static const reusableCup = 5;
  static const bikeShortTrip = 20;
  static const bikeMediumTrip = 50;
  static const publicTransit = 30;
  static const meatlessMeal = 20;
  static const localProduce = 10;
  static const composting = 15;
  static const shorterShower = 5;
  static const airDryClothes = 10;
  static const unplugDevices = 3;
  static const bringOwnContainer = 10;
}
