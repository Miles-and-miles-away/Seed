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
