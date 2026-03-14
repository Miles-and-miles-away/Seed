import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/utils/app_logger.dart';
import 'firebase_options.dart';
import 'shared/services/services.dart';

// ignore: do_not_use_environment
const _useEmulator = bool.fromEnvironment('USE_EMULATOR');

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize App Check before other Firebase services
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode
          ? const AppleDebugProvider()
          : const AppleDeviceCheckProvider(),
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

    // Disable performance monitoring in debug mode
    await FirebasePerformance.instance
        .setPerformanceCollectionEnabled(!kDebugMode);

    // Connect to Firebase Emulator Suite in debug mode
    if (_useEmulator) {
      const emulatorHost = '10.0.2.2'; // Android emulator
      FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
      await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
      await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
      AppLogger.debug('Connected to Firebase Emulator Suite');
    }

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
