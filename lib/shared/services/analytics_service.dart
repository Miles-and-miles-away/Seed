import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:seed_app/core/utils/app_logger.dart';

/// Service for tracking analytics events.
///
/// Wraps Firebase Analytics in a type-safe API. The event surface is
/// intentionally complete: some methods are defined ahead of their call
/// sites and get wired up as the matching feature ships (e.g. the shop
/// events land with Phase 7; see the section dividers). An uncalled method
/// here is scaffolding, not dead code -- check Plan/PLAN_PHASE_*.md before
/// removing one.
///
/// Gracefully handles cases where Firebase isn't initialized (e.g. in unit
/// tests) by catching exceptions and logging warnings.
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

  /// Toggle analytics and crashlytics collection on Firebase.
  Future<void> setCollectionEnabled({required bool enabled}) async {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);
    } on Object catch (e) {
      appLogger.warning('Analytics toggle failed: $e');
    }
  }

  /// Get the Firebase Analytics instance, initializing lazily.
  /// Returns null if Firebase is not available or disabled.
  FirebaseAnalytics? get _safeAnalytics {
    if (!_enabled) return null;
    try {
      return _analytics ??= FirebaseAnalytics.instance;
    } on Object catch (e) {
      // Firebase not initialized (e.g., in tests)
      appLogger.warning('Analytics: Firebase not available - $e');
      return null;
    }
  }

  /// Null-guarded logEvent + debug trace shared by every event method.
  Future<void> _log(
    String name, [
    Map<String, Object> parameters = const {},
  ]) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logEvent(
      name: name,
      parameters: parameters.isEmpty ? null : parameters,
    );
    appLogger.debug(
      'Analytics: $name${parameters.isEmpty ? '' : ' - $parameters'}',
    );
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
    appLogger.debug('Analytics: Set user ID: $userId');
  }

  // ============================================================
  // Authentication Events
  // ============================================================

  /// Log when a user signs up.
  Future<void> logSignUp({required String method}) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logSignUp(signUpMethod: method);
    appLogger.debug('Analytics: sign_up - method: $method');
  }

  /// Log when a user logs in.
  Future<void> logLogin({required String method}) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logLogin(loginMethod: method);
    appLogger.debug('Analytics: login - method: $method');
  }

  /// Log when a user logs out.
  Future<void> logLogout() => _log('logout');

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
  }) {
    return _log('action_logged', {
      'action_id': actionId,
      'category': category,
      'points': points,
      'co2_grams': co2Grams,
      'sdg_count': sdgs.length,
      'sdgs': sdgs.take(5).join(','), // Limit to avoid param size issues
    });
  }

  // ============================================================
  // Mascot Events
  // ============================================================

  /// Log when a mascot evolves to a new stage.
  ///
  /// NOTE(planned): uncalled until the Phase 6.11 analytics wiring
  /// task lands -- keep, do not flag as dead code.
  Future<void> logMascotEvolved({
    required String species,
    required int newStage,
    required int userLevel,
  }) {
    return _log('mascot_evolved', {
      'species': species,
      'new_stage': newStage,
      'user_level': userLevel,
    });
  }

  /// Log when a user unlocks a new mascot species.
  ///
  /// NOTE(planned): uncalled until the Phase 6.11 analytics wiring
  /// task lands -- keep, do not flag as dead code. Unlocks now happen
  /// via egg hatching, so `pointsSpent` likely changes when wired.
  Future<void> logMascotUnlocked({
    required String species,
    required int pointsSpent,
  }) {
    return _log('mascot_unlocked', {
      'species': species,
      'points_spent': pointsSpent,
    });
  }

  // ============================================================
  // Streak Events
  // ============================================================

  /// Log when a user reaches a streak milestone.
  Future<void> logStreakMilestone({required int days}) {
    return _log('streak_milestone', {'days': days, 'weeks': days ~/ 7});
  }

  /// Log when a user's streak is broken.
  ///
  /// NOTE(planned): uncalled until the Phase 6.11 analytics wiring
  /// task lands -- keep, do not flag as dead code.
  Future<void> logStreakBroken({required int previousStreak}) {
    return _log('streak_broken', {'previous_streak': previousStreak});
  }

  // ============================================================
  // SDG Events
  // ============================================================

  /// Log when a user views an SDG detail screen.
  Future<void> logSdgViewed({required int sdgNumber}) {
    return _log('sdg_viewed', {'sdg_number': sdgNumber});
  }

  // ============================================================
  // Shop Events (Phase 7 -- cosmetic shop / premium)
  // ============================================================

  /// Log when a user views a shop item.
  ///
  /// NOTE(planned): uncalled until the Phase 7 shop ships -- keep,
  /// do not flag as dead code.
  Future<void> logShopItemViewed({
    required String itemId,
    required String itemType,
    required int pointsCost,
  }) {
    return _log('shop_item_viewed', {
      'item_id': itemId,
      'item_type': itemType,
      'points_cost': pointsCost,
    });
  }

  /// Log when a user purchases a shop item.
  ///
  /// NOTE(planned): uncalled until the Phase 7 shop ships -- keep,
  /// do not flag as dead code.
  Future<void> logShopItemPurchased({
    required String itemId,
    required String itemType,
    required int pointsSpent,
  }) {
    return _log('shop_item_purchased', {
      'item_id': itemId,
      'item_type': itemType,
      'points_spent': pointsSpent,
    });
  }

  // ============================================================
  // Transport Calculator Events (Phase 8)
  // ============================================================

  /// Log when the transport carbon calculator is opened.
  Future<void> logTransportCalculatorOpened() =>
      _log('transport_calculator_opened');

  /// Log when a user runs a journey comparison (Phase 8.3).
  ///
  /// NOTE(planned): defined with the 8.3 comparison feature but not
  /// yet wired -- keep, do not flag as dead code.
  Future<void> logTransportComparisonRun({
    required List<String> modeIds,
    required List<int> legCounts,
    required String winningModeId,
  }) {
    return _log('transport_comparison_run', {
      'mode_ids': modeIds.take(10).join(','),
      'option_count': legCounts.length,
      'leg_counts': legCounts.join(','),
      'winning_mode': winningModeId,
    });
  }

  // ============================================================
  // Food Calculator Events (Phase 8, Part 2)
  // ============================================================

  /// Log when the food carbon calculator is opened.
  Future<void> logFoodCalculatorOpened() => _log('food_calculator_opened');

  /// Log when the home energy calculator is opened (Phase 8.17).
  Future<void> logEnergyCalculatorOpened() => _log('energy_calculator_opened');

  /// Log when a user runs a meal comparison (Phase 8.9).
  ///
  /// NOTE(planned): defined with the 8.9 comparison feature but not
  /// yet wired -- keep, do not flag as dead code.
  Future<void> logFoodComparisonRun({
    required List<String> itemIds,
    required List<int> ingredientCounts,
    required String winningItemId,
  }) {
    return _log('food_comparison_run', {
      'item_ids': itemIds.take(10).join(','),
      'option_count': ingredientCounts.length,
      'ingredient_counts': ingredientCounts.join(','),
      'winning_item': winningItemId,
    });
  }

  // ============================================================
  // Settings Events
  // ============================================================

  /// Log when a user enables notifications.
  Future<void> logNotificationEnabled() => _log('notification_enabled');

  /// Log when a user disables notifications.
  Future<void> logNotificationDisabled() => _log('notification_disabled');

  /// Log when a user changes their language setting.
  Future<void> logLanguageChanged({required String language}) {
    return _log('language_changed', {'language': language});
  }

  // ============================================================
  // Level & Progress Events
  // ============================================================

  /// Log when a user levels up.
  ///
  /// NOTE(planned): uncalled until the Phase 6.11 analytics wiring
  /// task lands -- keep, do not flag as dead code.
  Future<void> logLevelUp({
    required int newLevel,
    required int totalPoints,
  }) async {
    final analytics = _safeAnalytics;
    if (analytics == null) return;
    await analytics.logLevelUp(level: newLevel);
    await _log('level_up_details', {
      'new_level': newLevel,
      'total_points': totalPoints,
    });
  }
}
