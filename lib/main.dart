import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/utils/app_logger.dart';
import 'firebase_options.dart';
import 'shared/services/services.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure Crashlytics
    // Disable in debug mode to avoid noise during development
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);

    // Pass all uncaught Flutter errors to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Configure Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Register background message handler for FCM
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Initialize notification services in parallel
    await Future.wait([
      NotificationService.instance.initialize(
        onTap: _handleNotificationTap,
      ),
      FCMService.instance.initialize(
        onForeground: _handleForegroundMessage,
        onTap: _handleFCMMessageTap,
      ),
    ]);

    runApp(
      const ProviderScope(
        child: SeedApp(),
      ),
    );
  }, (error, stack) {
    // Catch any errors that weren't caught by the Flutter framework
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

/// Handle local notification tap.
void _handleNotificationTap(String? payload) {
  AppLogger.debug('Local notification tapped: $payload');
  // Navigation will be handled via router based on payload
}

/// Handle FCM foreground message.
void _handleForegroundMessage(RemoteMessage message) {
  AppLogger.debug('FCM foreground: ${message.notification?.title}');
  // Show in-app notification or update UI
}

/// Handle FCM message tap (from background/terminated).
void _handleFCMMessageTap(RemoteMessage message) {
  AppLogger.debug('FCM tapped: ${message.notification?.title}');
  // Navigation will be handled via router based on message data
}
