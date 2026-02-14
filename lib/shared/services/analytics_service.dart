import 'package:firebase_analytics/firebase_analytics.dart';

import '../../core/utils/app_logger.dart';

/// Service for tracking analytics events.
///
/// This service wraps Firebase Analytics to provide a type-safe API
/// for tracking app events. Events are defined based on key user actions
/// that help understand user behavior and app performance.
///
/// The service gracefully handles cases where Firebase isn't initialized
/// (e.g., in unit tests) by catching exceptions and logging warnings.
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  FirebaseAnalytics? _analytics;
  bool _enabled = true;

  /// Enable or disable analytics collection at runtime.
  // ignore: use_setters_to_change_properties
  void setEnabled({required bool enabled}) {
    _enabled = enabled;
  }

  /// Get the Firebase Analytics instance, initializing lazily.
  /// Returns null if Firebase is not available or disabled.
  FirebaseAnalytics? get _safeAnalytics {
    if (!_enabled) return null;
    try {
      return _analytics ??= FirebaseAnalytics.instance;
    } on Object catch (e) {
      // Firebase not initialized (e.g., in tests)
      AppLogger.warning('Analytics: Firebase not available - $e');
      return null;
    }
  }

  /// Get the analytics observer for navigation tracking.
  /// Returns a no-op observer if Firebase is not available.
  FirebaseAnalyticsObserver? get observer {
    final analytics = _safeAnalytics;
    if (analytics == null) return null;
    return FirebaseAnalyticsObserver(analytics: analytics);
  }

  /// Set the user ID for analytics.
  Future<void> setUserId(String? userId) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.setUserId(id: userId);
    AppLogger.debug('Analytics: Set user ID: $userId');
  }

  /// Set user properties for segmentation.
  Future<void> setUserProperties({
    String? language,
    String? mascotSpecies,
    int? userLevel,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    if (language != null) {
      await analytics.setUserProperty(name: 'language', value: language);
    }
    if (mascotSpecies != null) {
      await analytics.setUserProperty(
        name: 'mascot_species',
        value: mascotSpecies,
      );
    }
    if (userLevel != null) {
      await analytics.setUserProperty(
        name: 'user_level',
        value: userLevel.toString(),
      );
    }
  }

  // ============================================================
  // Authentication Events
  // ============================================================

  /// Log when a user signs up.
  Future<void> logSignUp({required String method}) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logSignUp(signUpMethod: method);
    AppLogger.debug('Analytics: sign_up - method: $method');
  }

  /// Log when a user logs in.
  Future<void> logLogin({required String method}) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logLogin(loginMethod: method);
    AppLogger.debug('Analytics: login - method: $method');
  }

  /// Log when a user logs out.
  Future<void> logLogout() async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(name: 'logout');
    AppLogger.debug('Analytics: logout');
  }

  // ============================================================
  // Action Events
  // ============================================================

  /// Log when a user logs a sustainable action.
  Future<void> logActionLogged({
    required String actionId,
    required String category,
    required int points,
    required int co2Grams,
    required List<String> sdgs,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'action_logged',
      parameters: {
        'action_id': actionId,
        'category': category,
        'points': points,
        'co2_grams': co2Grams,
        'sdg_count': sdgs.length,
        'sdgs': sdgs.take(5).join(','), // Limit to avoid param size issues
      },
    );
    AppLogger.debug('Analytics: action_logged - $actionId, $points pts, $co2Grams g');
  }

  /// Log when a user views an action's details.
  Future<void> logActionViewed({
    required String actionId,
    required String category,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'action_viewed',
      parameters: {
        'action_id': actionId,
        'category': category,
      },
    );
  }

  // ============================================================
  // Mascot Events
  // ============================================================

  /// Log when a mascot evolves to a new stage.
  Future<void> logMascotEvolved({
    required String species,
    required int newStage,
    required int userLevel,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'mascot_evolved',
      parameters: {
        'species': species,
        'new_stage': newStage,
        'user_level': userLevel,
      },
    );
    AppLogger.debug('Analytics: mascot_evolved - $species stage $newStage');
  }

  /// Log when a user selects their initial mascot.
  Future<void> logMascotSelected({
    required String species,
    required String mascotName,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'mascot_selected',
      parameters: {
        'species': species,
        'mascot_name': mascotName,
      },
    );
    AppLogger.debug('Analytics: mascot_selected - $species named $mascotName');
  }

  /// Log when a user unlocks a new mascot species.
  Future<void> logMascotUnlocked({
    required String species,
    required int pointsSpent,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'mascot_unlocked',
      parameters: {
        'species': species,
        'points_spent': pointsSpent,
      },
    );
    AppLogger.debug('Analytics: mascot_unlocked - $species for $pointsSpent pts');
  }

  /// Log when a user renames their mascot.
  Future<void> logMascotRenamed({required String species}) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'mascot_renamed',
      parameters: {'species': species},
    );
  }

  // ============================================================
  // Streak Events
  // ============================================================

  /// Log when a user reaches a streak milestone.
  Future<void> logStreakMilestone({
    required int days,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'streak_milestone',
      parameters: {
        'days': days,
        'weeks': days ~/ 7,
      },
    );
    AppLogger.debug('Analytics: streak_milestone - $days days');
  }

  /// Log when a user's streak is broken.
  Future<void> logStreakBroken({
    required int previousStreak,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'streak_broken',
      parameters: {
        'previous_streak': previousStreak,
      },
    );
    AppLogger.debug('Analytics: streak_broken - was $previousStreak days');
  }

  // ============================================================
  // SDG Events
  // ============================================================

  /// Log when a user views an SDG detail screen.
  Future<void> logSdgViewed({required int sdgNumber}) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'sdg_viewed',
      parameters: {
        'sdg_number': sdgNumber,
      },
    );
    AppLogger.debug('Analytics: sdg_viewed - SDG $sdgNumber');
  }

  // ============================================================
  // Shop Events (for Phase 4)
  // ============================================================

  /// Log when a user views a shop item.
  Future<void> logShopItemViewed({
    required String itemId,
    required String itemType,
    required int pointsCost,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'shop_item_viewed',
      parameters: {
        'item_id': itemId,
        'item_type': itemType,
        'points_cost': pointsCost,
      },
    );
  }

  /// Log when a user purchases a shop item.
  Future<void> logShopItemPurchased({
    required String itemId,
    required String itemType,
    required int pointsSpent,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'shop_item_purchased',
      parameters: {
        'item_id': itemId,
        'item_type': itemType,
        'points_spent': pointsSpent,
      },
    );
    AppLogger.debug('Analytics: shop_item_purchased - $itemId for $pointsSpent pts');
  }

  // ============================================================
  // Settings Events
  // ============================================================

  /// Log when a user enables notifications.
  Future<void> logNotificationEnabled() async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(name: 'notification_enabled');
    AppLogger.debug('Analytics: notification_enabled');
  }

  /// Log when a user disables notifications.
  Future<void> logNotificationDisabled() async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(name: 'notification_disabled');
    AppLogger.debug('Analytics: notification_disabled');
  }

  /// Log when a user changes their language setting.
  Future<void> logLanguageChanged({required String language}) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'language_changed',
      parameters: {'language': language},
    );
    AppLogger.debug('Analytics: language_changed - $language');
  }

  // ============================================================
  // Navigation Events
  // ============================================================

  /// Log screen view for screen tracking.
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // ============================================================
  // Level & Progress Events
  // ============================================================

  /// Log when a user levels up.
  Future<void> logLevelUp({
    required int newLevel,
    required int totalPoints,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logLevelUp(level: newLevel);
    await analytics.logEvent(
      name: 'level_up_details',
      parameters: {
        'new_level': newLevel,
        'total_points': totalPoints,
      },
    );
    AppLogger.debug('Analytics: level_up - level $newLevel');
  }

  // ============================================================
  // Error Events
  // ============================================================

  /// Log a non-fatal error for analytics.
  Future<void> logError({
    required String errorType,
    String? errorMessage,
    String? screen,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        if (errorMessage != null)
          'error_message': errorMessage.substring(
            0,
            errorMessage.length.clamp(0, 100),
          ),
        if (screen != null) 'screen': screen,
      },
    );
    AppLogger.debug('Analytics: app_error - $errorType');
  }
}
