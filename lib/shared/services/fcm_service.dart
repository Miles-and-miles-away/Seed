// ignore_for_file: unreachable_from_main

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/app_logger.dart';

/// Service for managing Firebase Cloud Messaging (push notifications).
///
/// Handles FCM token management and message handling.
class FCMService {
  FCMService._();

  static final FCMService _instance = FCMService._();
  static FCMService get instance => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _initialized = false;

  /// Callback when a foreground message is received.
  void Function(RemoteMessage message)? onForegroundMessage;

  /// Callback when a notification is tapped (from background/terminated).
  void Function(RemoteMessage message)? onMessageTap;

  /// Initialize FCM service.
  ///
  /// Must be called after Firebase.initializeApp().
  Future<void> initialize({
    void Function(RemoteMessage message)? onForeground,
    void Function(RemoteMessage message)? onTap,
  }) async {
    if (_initialized) return;

    onForegroundMessage = onForeground;
    onMessageTap = onTap;

    // Request permission
    final settings = await _messaging.requestPermission();

    AppLogger.debug('FCM auth status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Get and store token (may fail on simulators - no APNS support)
      try {
        final token = await _messaging.getToken();
        if (token != null) {
          await _storeToken(token);
          AppLogger.debug('FCM token: ${token.substring(0, 20)}...');
        }
      } on Exception catch (e) {
        // Expected on iOS simulator - APNS tokens not available
        AppLogger.warning('FCM token unavailable (expected on simulator): $e');
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_storeToken);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background message tap
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

      // Check for initial message (app opened from terminated state)
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }
    }

    _initialized = true;
    AppLogger.debug('FCMService initialized');
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
    AppLogger.debug('FCM token deleted');
  }

  /// Subscribe to a topic for group notifications.
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    AppLogger.debug('Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    AppLogger.debug('Unsubscribed from topic: $topic');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.debug('Foreground message: ${message.notification?.title}');
    onForegroundMessage?.call(message);
  }

  void _handleMessageTap(RemoteMessage message) {
    AppLogger.debug('Message tapped: ${message.notification?.title}');
    onMessageTap?.call(message);
  }

  Future<void> _storeToken(String token) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      AppLogger.warning('Cannot store FCM token: no user logged in');
      return;
    }

    try {
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .update({'fcmToken': token});
      AppLogger.debug('FCM token stored for user $userId');
    } on Exception catch (e) {
      AppLogger.warning('Failed to store FCM token: $e');
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
      AppLogger.debug('FCM token removed for user $userId');
    } on Exception catch (e) {
      AppLogger.warning('Failed to remove FCM token: $e');
    }
  }
}

/// Background message handler.
///
/// Must be a top-level function (not a class method).
/// Register this in main.dart: FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.debug('Background message: ${message.notification?.title}');
  // Handle the background message
  // Note: This runs in a separate isolate, so you can't access instance state
}
