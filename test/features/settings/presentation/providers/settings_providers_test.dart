import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';

ProviderContainer _container(UserSettingsModel settings) {
  return ProviderContainer(
    overrides: [
      userSettingsProvider.overrideWith((_) => Stream.value(settings)),
    ],
  );
}

Future<void> _pump(ProviderContainer c) async {
  c.listen(userSettingsProvider, (_, __) {});
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('derived settings selectors', () {
    test('currentLanguageProvider reflects the settings language', () async {
      final c = _container(
        const UserSettingsModel(language: 'ja'),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(currentLanguageProvider), 'ja');
    });

    test('notificationsEnabledProvider mirrors the setting', () async {
      final c = _container(
        const UserSettingsModel(notificationsEnabled: false),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(notificationsEnabledProvider), isFalse);
    });

    test('smartRemindersEnabledProvider mirrors the setting', () async {
      final c = _container(
        const UserSettingsModel(smartRemindersEnabled: false),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(smartRemindersEnabledProvider), isFalse);
    });

    test('analyticsEnabledProvider mirrors the setting', () async {
      final c = _container(
        const UserSettingsModel(analyticsEnabled: false),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(analyticsEnabledProvider), isFalse);
    });

    test('appLocaleProvider wraps the language in a Locale', () async {
      final c = _container(const UserSettingsModel(language: 'es'));
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(appLocaleProvider).languageCode, 'es');
    });
  });

  group('reminder selectors', () {
    test('enabledRemindersProvider filters disabled entries', () async {
      final c = _container(
        const UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(
              id: 'r2',
              hour: 18,
              minute: 0,
              isEnabled: false,
            ),
          ],
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final enabled = c.read(enabledRemindersProvider);
      expect(enabled, hasLength(1));
      expect(enabled.first.id, 'r1');
    });

    test('canAddReminderProvider is false at 5 schedules', () async {
      final c = _container(
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
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(canAddReminderProvider), isFalse);
    });

    test('canAddReminderProvider is true below the cap', () async {
      final c = _container(const UserSettingsModel());
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(canAddReminderProvider), isTrue);
    });
  });
}
