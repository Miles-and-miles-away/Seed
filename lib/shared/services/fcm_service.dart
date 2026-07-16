// ignore_for_file: unreachable_from_main

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/app_logger.dart';

/// Service for managing Firebase Cloud Messaging (push notifications).
///
/// Handles FCM token management and message handling.
class FCMService {
  FCMService._()
    : _messagingOverride = null,
      _firestoreOverride = null,
      _authOverride = null;

  /// Test seam: unit tests inject mocks because the real Firebase
  /// singletons require platform channels and Firebase.initializeApp.
  @visibleForTesting
  FCMService.withDependencies({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _messagingOverride = messaging,
       _firestoreOverride = firestore,
       _authOverride = auth;

  static final FCMService _instance = FCMService._();
  static FCMService get instance => _instance;

  final FirebaseMessaging? _messagingOverride;
  final FirebaseFirestore? _firestoreOverride;
  final FirebaseAuth? _authOverride;

  // Resolved lazily so the singleton can exist before Firebase is
  // initialized; real instances are only touched once methods run.
  FirebaseMessaging get _messaging =>
      _messagingOverride ?? FirebaseMessaging.instance;
  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;
  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;

  bool _initialized = false;

  /// Callback when a foreground message is received.
  void Function(RemoteMessage message)? onForegroundMessage;

  /// Callback when a notification is tapped (from background/terminated).
  void Function(RemoteMessage message)? onMessageTap;

  /// Initialize FCM service.
  ///
  /// Must be called after Firebase.initializeApp().
  ///
  /// Deliberately does NOT request notification permission: the
  /// reminder feature is postponed (see NOTE(postponed) in
  /// lib/shared/providers/notification_providers.dart), and permission
  /// will be requested contextually when that feature ships. Listeners
  /// are still registered unconditionally so message taps start
  /// working as soon as the user grants permission in OS settings.
  Future<void> initialize({
    void Function(RemoteMessage message)? onForeground,
    void Function(RemoteMessage message)? onTap,
  }) async {
    if (_initialized) return;

    onForegroundMessage = onForeground;
    onMessageTap = onTap;

    // Register listeners before any awaits so a token failure can
    // never leave message handling unwired.
    _messaging.onTokenRefresh.listen(_storeToken);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Best-effort token fetch: on iOS getToken throws until the user
    // grants notification permission (APNS token not set), and on
    // simulators APNS is unavailable entirely.
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _storeToken(token);
        appLogger.debug('FCM token: ${token.substring(0, 20)}...');
      }
    } on Exception catch (e) {
      appLogger.info('FCM token unavailable: $e');
    }

    // Check for initial message (app opened from terminated state)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }

    _initialized = true;
    appLogger.debug('FCMService initialized');
  }

  /// Request notification permissions.
  ///
  /// Returns the authorization status.
  Future<AuthorizationStatus> requestPermissions() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus;
  }

  /// Get the current FCM token.
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  /// Delete the FCM token (e.g., on logout).
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    appLogger.debug('FCM token deleted');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    appLogger.debug('Foreground message: ${message.notification?.title}');
    onForegroundMessage?.call(message);
  }

  void _handleMessageTap(RemoteMessage message) {
    appLogger.debug('Message tapped: ${message.notification?.title}');
    onMessageTap?.call(message);
  }

  Future<void> _storeToken(String token) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      appLogger.warning('Cannot store FCM token: no user logged in');
      return;
    }

    try {
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .update({'fcmToken': token});
      appLogger.debug('FCM token stored for user $userId');
    } on Exception catch (e) {
      appLogger.warning('Failed to store FCM token: $e');
    }
  }

  /// Remove the stored FCM token for the current user.
  Future<void> removeStoredToken() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .update({'fcmToken': FieldValue.delete()});
      appLogger.debug('FCM token removed for user $userId');
    } on Exception catch (e) {
      appLogger.warning('Failed to remove FCM token: $e');
    }
  }
}

/// Background message handler.
///
/// Must be a top-level function (not a class method).
/// Register this in main.dart: FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  appLogger.debug('Background message: ${message.notification?.title}');
  // Handle the background message
  // Note: This runs in a separate isolate, so you can't access instance state
}
