import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../core/utils/app_logger.dart';

/// Service for managing local notifications.
///
/// Handles scheduling daily reminders at user-specified times.
/// Supports smart notifications that can be conditionally shown.
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Notification channel ID for Android.
  static const String channelId = 'daily_reminder';

  /// Notification channel name for Android.
  static const String channelName = 'Daily Reminders';

  /// Notification channel description for Android.
  static const String channelDescription =
      'Reminders to log your sustainable actions';

  /// Callback when a notification is tapped.
  void Function(String? payload)? onNotificationTap;

  /// Initialize the notification service.
  ///
  /// Must be called before any other methods.
  Future<void> initialize({
    void Function(String? payload)? onTap,
  }) async {
    if (_initialized) return;

    onNotificationTap = onTap;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _createAndroidChannel();
    }

    _initialized = true;
    AppLogger.debug('NotificationService initialized');
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _handleNotificationResponse(NotificationResponse response) {
    AppLogger.debug('Notification tapped: ${response.payload}');
    onNotificationTap?.call(response.payload);
  }

  /// Request notification permissions.
  ///
  /// Returns true if permissions were granted.
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      final result = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return result ?? false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final result = await androidPlugin?.requestNotificationsPermission();
      return result ?? false;
    }

    return false;
  }

  /// Check if notification permissions are granted.
  Future<bool> checkPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      final settings = await iosPlugin?.checkPermissions();
      return settings?.isEnabled ?? false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final result = await androidPlugin?.areNotificationsEnabled();
      return result ?? false;
    }

    return false;
  }

  /// Schedule a daily notification at the specified time.
  ///
  /// [id] - Unique notification ID
  /// [hour] - Hour of day (0-23)
  /// [minute] - Minute of hour (0-59)
  /// [title] - Notification title
  /// [body] - Notification body
  /// [payload] - Optional payload for tap handling
  Future<void> scheduleDailyNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      AppLogger.warning('NotificationService not initialized');
      return;
    }

    final scheduledTime = _nextInstanceOfTime(hour, minute);

    AppLogger.debug(
      'Scheduling notification $id at $hour:$minute '
      '(next: ${scheduledTime.toLocal()})',
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  /// Cancel a specific notification.
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
    AppLogger.debug('Cancelled notification $id');
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
    AppLogger.debug('Cancelled all notifications');
  }

  /// Get all pending notifications.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  /// Show an immediate notification (for testing).
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  /// Calculate the next instance of the specified time.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// Notification details for both platforms.
  NotificationDetails get _notificationDetails => NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
}
