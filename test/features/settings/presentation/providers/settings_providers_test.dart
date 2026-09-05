import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';

import '../../../../helpers/test_helpers.dart';

Future<ProviderContainer> _container(UserSettingsModel settings) =>
    pumpedContainer([
      userSettingsProvider.overrideWith((_) => Stream.value(settings)),
    ], warm: userSettingsProvider);

void main() {
  group('derived settings selectors', () {
    test('currentLanguageProvider reflects the settings language', () async {
      final c = await _container(const UserSettingsModel(language: 'ja'));

      expect(c.read(currentLanguageProvider), 'ja');
    });

    test('notificationsEnabledProvider mirrors the setting', () async {
      final c = await _container(const UserSettingsModel());

      expect(c.read(notificationsEnabledProvider), isFalse);
    });

    test('smartRemindersEnabledProvider mirrors the setting', () async {
      final c = await _container(
        const UserSettingsModel(smartRemindersEnabled: false),
      );

      expect(c.read(smartRemindersEnabledProvider), isFalse);
    });

    test('analyticsEnabledProvider mirrors the setting', () async {
      final c = await _container(
        const UserSettingsModel(analyticsEnabled: false),
      );

      expect(c.read(analyticsEnabledProvider), isFalse);
    });

    test('appLocaleProvider wraps the language in a Locale', () async {
      final c = await _container(const UserSettingsModel(language: 'es'));

      expect(c.read(appLocaleProvider).languageCode, 'es');
    });
  });

  group('reminder selectors', () {
    test('canAddReminderProvider is false at 5 schedules', () async {
      final c = await _container(
        const UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(id: 'r2', hour: 10, minute: 0),
            NotificationScheduleModel(id: 'r3', hour: 11, minute: 0),
            NotificationScheduleModel(id: 'r4', hour: 12, minute: 0),
            NotificationScheduleModel(id: 'r5', hour: 13, minute: 0),
          ],
        ),
      );

      expect(c.read(canAddReminderProvider), isFalse);
    });

    test('canAddReminderProvider is true below the cap', () async {
      final c = await _container(const UserSettingsModel());

      expect(c.read(canAddReminderProvider), isTrue);
    });
  });
}
