import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/services/notification_service.dart';

const _channel = MethodChannel('dexterous.com/flutter/local_notifications');

const _channels = {
  NotificationService.actionChannelId: (name: 'Actions', description: 'A'),
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;
  late NotificationService service;

  setUp(() {
    calls = [];
    service = NotificationService.forTesting();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    FlutterLocalNotificationsPlatform.instance =
        AndroidFlutterLocalNotificationsPlugin();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          return call.method == 'initialize' ? true : null;
        });
  });

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  List<String> methods() => [
    for (final call in calls)
      if (call.method != 'initialize' &&
          call.method != 'getNotificationAppLaunchDetails')
        call.method,
  ];

  Reminder reminder(DateTime time) => (
    time: time,
    title: 'Bring a bag',
    body: 'Time for it',
    channelId: NotificationService.actionChannelId,
    payload: '/log-action',
  );

  test('queues reminders as UTC instants, keeping shown ones', () async {
    final time = DateTime.now().add(const Duration(days: 1));

    await service.scheduleReminders([reminder(time)], channels: _channels);

    expect(methods(), [
      'cancelAllPendingNotifications',
      'createNotificationChannel',
      'zonedSchedule',
    ]);
    final args = calls.last.arguments as Map<Object?, Object?>;
    expect(args['timeZoneName'], 'UTC');
    expect(
      DateTime.parse('${args['scheduledDateTime']}Z'),
      time.toUtc().copyWith(microsecond: 0, millisecond: 0),
    );
    expect(args['payload'], '/log-action');
  });

  test('skips a reschedule identical to the last', () async {
    final time = DateTime.now().add(const Duration(days: 1));

    await service.scheduleReminders([reminder(time)], channels: _channels);
    calls.clear();
    await service.scheduleReminders([reminder(time)], channels: _channels);
    expect(methods(), isEmpty);

    await service.scheduleReminders([], channels: _channels);
    expect(methods(), ['cancelAllPendingNotifications']);
  });

  test('retries a failed initialization', () async {
    var fail = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          if (call.method == 'initialize' && fail) {
            throw PlatformException(code: 'boom');
          }
          return call.method == 'initialize' ? true : null;
        });

    await expectLater(service.initialize(), throwsA(isA<PlatformException>()));
    fail = false;
    await service.initialize();

    expect(calls.where((c) => c.method == 'initialize'), hasLength(2));
  });
}
