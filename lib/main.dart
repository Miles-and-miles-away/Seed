import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'shared/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Register background message handler for FCM
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize notification services
  await NotificationService.instance.initialize(
    onTap: _handleNotificationTap,
  );

  await FCMService.instance.initialize(
    onForeground: _handleForegroundMessage,
    onTap: _handleFCMMessageTap,
  );

  runApp(
    const ProviderScope(
      child: SeedApp(),
    ),
  );
}

/// Handle local notification tap.
void _handleNotificationTap(String? payload) {
  debugPrint('Local notification tapped: $payload');
  // Navigation will be handled via router based on payload
}

/// Handle FCM foreground message.
void _handleForegroundMessage(RemoteMessage message) {
  debugPrint('FCM foreground message: ${message.notification?.title}');
  // Show in-app notification or update UI
}

/// Handle FCM message tap (from background/terminated).
void _handleFCMMessageTap(RemoteMessage message) {
  debugPrint('FCM message tapped: ${message.notification?.title}');
  // Navigation will be handled via router based on message data
}
