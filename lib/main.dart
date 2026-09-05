import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/app_logger.dart';
import 'firebase_options.dart';
import 'shared/services/services.dart';

// ignore: do_not_use_environment
const _useEmulator = bool.fromEnvironment('USE_EMULATOR');

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

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
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );

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
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(
        !kDebugMode,
      );

      // Connect to Firebase Emulator Suite in debug mode
      if (_useEmulator) {
        const emulatorHost = '10.0.2.2'; // Android emulator
        FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
        await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
        await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
        FirebaseFunctions.instanceFor(
          region: AppConstants.functionsRegion,
        ).useFunctionsEmulator(emulatorHost, 5001);
        appLogger.debug('Connected to Firebase Emulator Suite');
      }

      // Configure Firestore offline persistence
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Register background message handler for FCM
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      runApp(const ProviderScope(child: SeedApp()));

      // Notification setup parses the full timezone database and makes
      // network calls (FCM token); defer it past the first frame so it
      // can never block startup.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_initializeNotificationServices());
      });
    },
    (error, stack) {
      // Catch any errors that weren't caught by the Flutter framework
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

/// Initialize local notification and FCM services after the first
/// frame. Each failure is logged independently and never rethrown:
/// notifications are an optional capability and must not crash
/// startup or be reported as fatal to Crashlytics.
Future<void> _initializeNotificationServices() async {
  try {
    await NotificationService.instance.initialize(
      onTap: _handleNotificationTap,
    );
  } on Object catch (e, stack) {
    appLogger.error(
      'NotificationService initialization failed',
      error: e,
      stackTrace: stack,
    );
  }

  try {
    await FCMService.instance.initialize(
      onForeground: _handleForegroundMessage,
      onTap: _handleFCMMessageTap,
    );
  } on Object catch (e, stack) {
    appLogger.error(
      'FCMService initialization failed',
      error: e,
      stackTrace: stack,
    );
  }
}

/// Handle local notification tap.
void _handleNotificationTap(String? payload) {
  appLogger.debug('Local notification tapped: $payload');
  // Navigation will be handled via router based on payload
}

/// Handle FCM foreground message.
void _handleForegroundMessage(RemoteMessage message) {
  appLogger.debug('FCM foreground: ${message.notification?.title}');
  // Show in-app notification or update UI
}

/// Handle FCM message tap (from background/terminated).
void _handleFCMMessageTap(RemoteMessage message) {
  appLogger.debug('FCM tapped: ${message.notification?.title}');
  // Navigation will be handled via router based on message data
}
