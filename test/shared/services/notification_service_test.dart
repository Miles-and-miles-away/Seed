import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/services/notification_service.dart';

void main() {
  group('NotificationService', () {
    group('constants', () {
      test('channelId is correct', () {
        expect(NotificationService.channelId, 'daily_reminder');
      });

      test('channelName is correct', () {
        expect(NotificationService.channelName, 'Daily Reminders');
      });

      test('channelDescription is correct', () {
        expect(
          NotificationService.channelDescription,
          'Reminders to log your sustainable actions',
        );
      });
    });

    group('instance', () {
      test('returns same instance', () {
        final instance1 = NotificationService.instance;
        final instance2 = NotificationService.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });
  });
}
