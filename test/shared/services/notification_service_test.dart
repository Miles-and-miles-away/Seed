import 'dart:io';

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
  late List<Map<String, Object?>> shown;
  late NotificationService service;

  setUp(() {
    calls = [];
    shown = [];
    service = NotificationService.forTesting();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    FlutterLocalNotificationsPlatform.instance =
        AndroidFlutterLocalNotificationsPlugin();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          return switch (call.method) {
            'initialize' => true,
            'getActiveNotifications' => shown,
            _ => null,
          };
        });
  });

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  List<String> methods() => [
    for (final call in calls)
      if (call.method != 'initialize' &&
          call.method != 'getNotificationAppLaunchDetails')
        call.method,
  ];

  List<Object?> ids() => [
    for (final call in calls)
      if (call.method == 'zonedSchedule')
        (call.arguments as Map<Object?, Object?>)['id'],
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
      'getActiveNotifications',
    ]);
    final args =
        calls.firstWhere((call) => call.method == 'zonedSchedule').arguments
            as Map<Object?, Object?>;
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
    expect(methods(), [
      'cancelAllPendingNotifications',
      'createNotificationChannel',
      'getActiveNotifications',
    ]);
  });

  test('gives a reminder the same ID wherever it sits in the queue', () async {
    final first = DateTime.now().add(const Duration(days: 1));
    final second = first.add(const Duration(days: 1));

    await service.scheduleReminders([
      reminder(first),
      reminder(second),
    ], channels: _channels);
    final queued = ids();
    calls.clear();
    await service.scheduleReminders([reminder(second)], channels: _channels);

    expect(queued.toSet(), hasLength(2));
    expect(ids(), [queued.last]);
  });

  test('keeps reminders of the same minute apart', () async {
    final time = DateTime.now().add(const Duration(days: 1));

    await service.scheduleReminders([
      for (var i = 0; i < 11; i++) reminder(time),
      reminder(time.add(const Duration(minutes: 1))),
    ], channels: _channels);

    expect(ids().toSet(), hasLength(12));
  });

  test('skips a reminder already due and queues the rest', () async {
    final now = DateTime.now();

    await service.scheduleReminders([
      reminder(now.subtract(const Duration(seconds: 1))),
      reminder(now.add(const Duration(days: 1))),
    ], channels: _channels);

    expect(ids(), hasLength(1));
  });

  test('removes the shown reminders of earlier days only', () async {
    final now = DateTime.now();
    final noon = DateTime(now.year, now.month, now.day + 1, 12);
    await service.scheduleReminders([reminder(noon)], channels: _channels);
    final tomorrow = ids().single! as int;
    const idsPerDay = 24 * 60 * 16;
    shown = [
      {'id': tomorrow - 2 * idsPerDay},
      {'id': tomorrow - idsPerDay},
      {'id': 0, 'tag': 'push'},
    ];
    calls.clear();

    await service.scheduleReminders([], channels: _channels);

    expect(
      [
        for (final call in calls)
          if (call.method == 'cancel') call.arguments,
      ],
      [
        {'id': tomorrow - 2 * idsPerDay, 'tag': null},
      ],
    );
  });

  test('clearAll also clears shown notifications and the queue', () async {
    final time = DateTime.now().add(const Duration(days: 1));
    await service.scheduleReminders([reminder(time)], channels: _channels);
    calls.clear();

    await service.clearAll();
    expect(methods(), ['cancelAll']);

    // The same queue is no longer in place, so it is scheduled again.
    await service.scheduleReminders([reminder(time)], channels: _channels);
    expect(methods(), contains('zonedSchedule'));
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

  test('uses a drawable that exists as the status bar icon', () async {
    await service.initialize();
    final args = calls.first.arguments as Map<Object?, Object?>;
    final icon = '${args['defaultIcon']}';
    expect(icon, startsWith('@drawable/'));
    final name = icon.substring('@drawable/'.length);
    final file = File('android/app/src/main/res/drawable/$name.xml');
    expect(file.existsSync(), isTrue);
  });
}
