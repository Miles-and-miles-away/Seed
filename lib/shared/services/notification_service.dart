import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seed_app/core/utils/app_logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

/// One local notification; [payload] is the route a tap opens.
typedef Reminder = ({
  DateTime time,
  String title,
  String body,
  String channelId,
  String? payload,
});

/// The user-visible name and description of an Android channel.
typedef ReminderChannel = ({String name, String description});

/// Local notifications for the daily challenge and action reminders.
class NotificationService {
  NotificationService._();

  @visibleForTesting
  factory NotificationService.forTesting() => NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void>? _initialization;
  Future<void> _lastReschedule = Future.value();
  (List<Reminder>, Map<String, ReminderChannel>)? _scheduled;

  // Instants are scheduled in UTC, so the device zone and the timezone
  // database are never needed. 'UTC' is a name both iOS and Java resolve.
  static final _utc = tz.Location('UTC', [tz.minTime], [0], [tz.TimeZone.UTC]);

  static const _settingsChannel = MethodChannel('seed/app_settings');

  /// Android channel IDs.
  static const challengeChannelId = 'daily_reminder';
  static const actionChannelId = 'action_reminders';

  /// Route of the last tapped notification, until the app opens it.
  final tappedRoute = ValueNotifier<String?>(null);

  /// Initializes the plugin once; later calls await the same future,
  /// and a failed attempt is retried by the next call.
  Future<void> initialize() =>
      _initialization ??= _initialize().onError<Object>((e, stack) {
        _initialization = null;
        Error.throwWithStackTrace(e, stack);
      });

  Future<void> _initialize() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.notificationResponse case final response?
        when launch!.didNotificationLaunchApp) {
      _handleNotificationResponse(response);
    }
    appLogger.debug('NotificationService initialized');
  }

  void _handleNotificationResponse(NotificationResponse response) {
    appLogger.debug('Notification tapped: ${response.payload}');
    if (response.payload case final route?) tappedRoute.value = route;
  }

  /// Request notification permissions.
  ///
  /// Returns true if permissions were granted.
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      final result = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return result ?? false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final result = await androidPlugin?.requestNotificationsPermission();
      return result ?? false;
    }

    return false;
  }

  /// Check if notification permissions are granted.
  Future<bool> checkPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      final settings = await iosPlugin?.checkPermissions();
      return (settings?.isEnabled ?? false) ||
          (settings?.isProvisionalEnabled ?? false);
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final result = await androidPlugin?.areNotificationsEnabled();
      return result ?? false;
    }

    return false;
  }

  /// Opens this app's notification settings in the OS.
  Future<void> openSettings() async {
    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse('app-settings:'));
      } else if (Platform.isAndroid) {
        await _settingsChannel.invokeMethod<void>('notifications');
      }
    } on Object catch (e, stack) {
      appLogger.error('Opening settings failed', error: e, stackTrace: stack);
    }
  }

  /// Replaces every pending reminder with [reminders], refreshing the
  /// user-visible name of each Android channel in [channels].
  ///
  /// One-shot rather than a repeating daily trigger: an iOS repeating
  /// trigger ignores the date, so it cannot skip a day already done.
  /// Calls run one at a time so overlapping reschedules cannot mix, and
  /// a call matching what is already queued does nothing.
  Future<void> scheduleReminders(
    List<Reminder> reminders, {
    required Map<String, ReminderChannel> channels,
  }) {
    return _lastReschedule = _lastReschedule
        .catchError((Object _) {})
        .then((_) => _replaceReminders(reminders, channels));
  }

  Future<void> _replaceReminders(
    List<Reminder> reminders,
    Map<String, ReminderChannel> channels,
  ) async {
    await initialize();
    if (_scheduled case (
      final queued,
      final named,
    ) when listEquals(queued, reminders) && mapEquals(named, channels)) {
      return;
    }
    _scheduled = null;
    // Pending only: cancelAll also clears notifications already shown.
    await _plugin.cancelAllPendingNotifications();
    if (reminders.isEmpty) {
      _scheduled = (reminders, channels);
      return;
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    for (final MapEntry(key: id, value: channel) in channels.entries) {
      await android?.createNotificationChannel(
        AndroidNotificationChannel(
          id,
          channel.name,
          description: channel.description,
          importance: Importance.high,
        ),
      );
    }

    for (final (i, reminder) in reminders.indexed) {
      final channel = channels[reminder.channelId]!;
      await _plugin.zonedSchedule(
        id: i,
        title: reminder.title,
        body: reminder.body,
        payload: reminder.payload,
        scheduledDate: tz.TZDateTime.from(reminder.time, _utc),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            reminder.channelId,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        // Inexact suffices for daily reminders and avoids the Play Store
        // SCHEDULE_EXACT_ALARM declaration.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
    _scheduled = (reminders, channels);
    appLogger.debug('Scheduled ${reminders.length} reminders');
  }
}
