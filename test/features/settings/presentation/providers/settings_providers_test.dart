import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

import '../../../../helpers/test_helpers.dart';

Future<ProviderContainer> _container(UserSettingsModel settings) =>
    pumpedContainer([
      userIdProvider.overrideWithValue('u'),
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

    test('reminderTimeProvider mirrors the setting', () async {
      final c = await _container(
        const UserSettingsModel(reminderHour: 21, reminderMinute: 5),
      );

      expect(
        c.read(reminderTimeProvider),
        const TimeOfDay(hour: 21, minute: 5),
      );
    });

    test(
      'actionRemindersProvider drops spent and orphaned reminders',
      () async {
        const daily = ActionReminder(hour: 9, minute: 0, weekdays: [1]);
        const saturday = ActionReminder(
          hour: 0,
          minute: 0,
          weekdays: [6],
          lastDay: '2026-11-07',
        );
        final c = await pumpedContainer([
          userIdProvider.overrideWithValue('u'),
          userSettingsProvider.overrideWith(
            (_) => Stream.value(
              UserSettingsModel(
                actionReminders: {
                  'bag': daily,
                  // Ends today: 18:00 is still to come, 08:00 has passed.
                  'bus': saturday.copyWith(hour: 18),
                  'cup': saturday.copyWith(hour: 8),
                  'old': daily.copyWith(lastDay: '2026-11-06'),
                  'gone': daily,
                },
              ),
            ),
          ),
          clockProvider.overrideWithValue(() => DateTime(2026, 11, 7, 9)),
          actionLibraryProvider.overrideWith(
            (_) async => [
              for (final id in ['bag', 'bus', 'cup', 'old'])
                ActionModel(
                  id: id,
                  nameEn: id,
                  nameJa: id,
                  category: 'waste',
                  points: 1,
                ),
            ],
          ),
        ], warm: userSettingsProvider);
        await c.read(actionLibraryProvider.future);

        expect(c.read(actionRemindersProvider).keys, ['bag', 'bus']);
      },
    );

    test('analyticsEnabledProvider mirrors the setting', () async {
      final c = await _container(
        const UserSettingsModel(analyticsEnabled: false),
      );

      expect(c.read(analyticsEnabledProvider), isFalse);
    });

    test('themeModeProvider maps the stored name', () async {
      final c = await _container(const UserSettingsModel(themeMode: 'dark'));

      expect(c.read(themeModeProvider), ThemeMode.dark);
    });

    test('themeModeProvider falls back to system on an unknown name', () async {
      final c = await _container(const UserSettingsModel(themeMode: 'sepia'));

      expect(c.read(themeModeProvider), ThemeMode.system);
    });

    test('appLocaleProvider wraps the language in a Locale', () async {
      final c = await _container(const UserSettingsModel(language: 'es'));

      expect(c.read(appLocaleProvider).languageCode, 'es');
    });
  });

  group('fallbacks while settings are loading', () {
    test('selectors report their defaults until the stream emits', () async {
      final c = await pumpedContainer([
        userIdProvider.overrideWithValue('u'),
        osLocalesProvider.overrideWithBuild(
          (_, _) => const [Locale('ja', 'JP')],
        ),
        userSettingsProvider.overrideWith(
          (_) => StreamController<UserSettingsModel>().stream,
        ),
      ], warm: userSettingsProvider);

      expect(c.read(currentLanguageProvider), 'ja');
      expect(c.read(notificationsEnabledProvider), isFalse);
      expect(
        c.read(reminderTimeProvider),
        const TimeOfDay(hour: 18, minute: 0),
      );
      expect(c.read(analyticsEnabledProvider), isTrue);
    });
  });
}
