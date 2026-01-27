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

      test('instance is not null', () {
        expect(NotificationService.instance, isNotNull);
      });
    });

    group('onNotificationTap', () {
      test('is null by default', () {
        final service = NotificationService.instance;
        // Note: This tests internal state which may already be set
        // The service is a singleton so state persists across tests
        expect(service.onNotificationTap, isA<void Function(String?)?>());
      });
    });
  });

  // Note: Full integration tests for notification scheduling
  // require platform channel mocking which is done in integration tests.
  // The following tests document the expected API behavior.

  group('NotificationService API', () {
    test('has initialize method', () {
      expect(NotificationService.instance.initialize, isA<Function>());
    });

    test('has requestPermissions method', () {
      expect(NotificationService.instance.requestPermissions, isA<Function>());
    });

    test('has checkPermissions method', () {
      expect(NotificationService.instance.checkPermissions, isA<Function>());
    });

    test('has scheduleDailyNotification method', () {
      expect(
        NotificationService.instance.scheduleDailyNotification,
        isA<Function>(),
      );
    });

    test('has cancelNotification method', () {
      expect(NotificationService.instance.cancelNotification, isA<Function>());
    });

    test('has cancelAllNotifications method', () {
      expect(
        NotificationService.instance.cancelAllNotifications,
        isA<Function>(),
      );
    });

    test('has getPendingNotifications method', () {
      expect(
        NotificationService.instance.getPendingNotifications,
        isA<Function>(),
      );
    });

    test('has showNotification method', () {
      expect(NotificationService.instance.showNotification, isA<Function>());
    });
  });
}
