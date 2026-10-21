import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/shared/data/language_store.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';

import '../../helpers/test_helpers.dart';

const _channel = MethodChannel('seed/app_locale');

Future<ProviderContainer> _container({
  String os = 'en',
  StoredLanguage stored = returningDevice,
  bool signedIn = false,
  String? account,
  MemoryLanguageStore? store,
}) => pumpedContainer(
  [
    osLocalesProvider.overrideWithBuild((_, _) => [Locale(os)]),
    if (signedIn) ...[
      userIdProvider.overrideWithValue('u'),
      userSettingsProvider.overrideWith(
        (_) => Stream.value(UserSettingsModel(language: account)),
      ),
    ],
  ],
  warm: userSettingsProvider,
  languageStore: store ?? MemoryLanguageStore(stored),
);

StoredLanguage _picked(String language, String os) =>
    (pick: (language: language, os: os), firstLaunchDone: true);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('resolveOsLanguage', () {
    for (final (locales, expected) in [
      (const [Locale('ja', 'JP')], 'ja'),
      (const [Locale('fr', 'FR')], 'en'),
      (const [Locale('fr', 'FR'), Locale('es', 'MX')], 'es'),
      (const <Locale>[], 'en'),
      (const [Locale('en', 'GB')], 'en'),
    ]) {
      test('$locales gives $expected', () {
        expect(resolveOsLanguage(locales), expected);
      });
    }
  });

  group('currentLanguageProvider', () {
    test('signed out follows the pick', () async {
      final c = await _container(stored: _picked('es', 'en'));
      expect(c.read(currentLanguageProvider), 'es');
    });

    test('signed out with no pick follows the OS', () async {
      final c = await _container(os: 'ja');
      expect(c.read(currentLanguageProvider), 'ja');
    });

    test("signed in, the account's language wins over the pick", () async {
      final c = await _container(
        stored: _picked('es', 'en'),
        signedIn: true,
        account: 'ja',
      );
      expect(c.read(currentLanguageProvider), 'ja');
    });

    test('signed in without an account language uses the pick', () async {
      final c = await _container(stored: _picked('es', 'en'), signedIn: true);
      expect(c.read(currentLanguageProvider), 'es');
    });

    for (final signedIn in [false, true]) {
      test('an OS change after the pick wins (signed in: $signedIn)', () async {
        final c = await _container(
          os: 'ja',
          stored: _picked('en', 'en'),
          signedIn: signedIn,
          account: 'en',
        );
        expect(c.read(currentLanguageProvider), 'ja');
      });
    }

    test('with no pick an OS change is followed live', () async {
      final c = await _container();
      c.listen(currentLanguageProvider, (_, _) {});
      expect(c.read(currentLanguageProvider), 'en');

      c.read(osLocalesProvider.notifier).update(const [Locale('es', 'ES')]);

      expect(c.read(currentLanguageProvider), 'es');
    });
  });

  group('DeviceLanguage', () {
    final calls = <MethodCall>[];

    void handle(Object? Function(MethodCall call)? answer) {
      calls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            _channel,
            answer == null
                ? null
                : (call) async {
                    calls.add(call);
                    return answer(call);
                  },
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(_channel, null),
      );
    }

    /// A container whose start-up SDK query has answered, as in SeedApp.
    Future<ProviderContainer> started(
      MemoryLanguageStore store, {
      String os = 'en',
    }) async {
      final c = await _container(os: os, store: store)
        ..listen(androidSdkProvider, (_, _) {});
      await pumpEventQueue();
      return c;
    }

    test('a pick on Android 13+ sets the per-app locale', () async {
      handle((call) => call.method == 'sdk' ? 33 : true);
      final store = MemoryLanguageStore();
      final c = await started(store);

      await c.read(deviceLanguageProvider.notifier).pick('es');

      expect(calls.last.method, 'set');
      expect(calls.last.arguments, 'es');
      expect(store.value, _picked('es', 'es'));
    });

    test('below Android 13 the pick records the OS language', () async {
      handle((call) => call.method == 'sdk' ? 32 : true);
      final store = MemoryLanguageStore();
      final c = await started(store);

      await c.read(deviceLanguageProvider.notifier).pick('es');

      expect(calls.map((call) => call.method), ['sdk']);
      expect(store.value, _picked('es', 'en'));
    });

    test('with no platform handler the pick still lands', () async {
      handle(null);
      final store = MemoryLanguageStore();
      final c = await started(store);

      await c.read(deviceLanguageProvider.notifier).pick('ja');

      expect(store.value, _picked('ja', 'en'));
      expect(c.read(currentLanguageProvider), 'ja');
    });

    test('a refused platform write falls back to the OS snapshot', () async {
      handle((call) => call.method == 'sdk' ? 34 : false);
      final store = MemoryLanguageStore();
      final c = await started(store);

      await c.read(deviceLanguageProvider.notifier).pick('es');

      expect(store.value, _picked('es', 'en'));
      expect(c.read(currentLanguageProvider), 'es');
    });

    test('mirror under an OS override keeps it and leaves Android', () async {
      handle((call) => call.method == 'sdk' ? 33 : true);
      final store = MemoryLanguageStore(_picked('en', 'en'));
      final c = await started(store, os: 'ja');

      await c.read(deviceLanguageProvider.notifier).mirror('es');

      expect(calls.map((call) => call.method), ['sdk']);
      expect(store.value, _picked('es', 'en'));
      expect(c.read(currentLanguageProvider), 'ja');
    });

    test('mirror with no override writes back to Android 13+', () async {
      handle((call) => call.method == 'sdk' ? 33 : true);
      final store = MemoryLanguageStore(_picked('es', 'es'));
      final c = await started(store, os: 'es');

      await c.read(deviceLanguageProvider.notifier).mirror('ja');

      expect(calls.last.method, 'set');
      expect(calls.last.arguments, 'ja');
      expect(store.value, _picked('ja', 'ja'));
    });

    test('mirror writes nothing while the store read timed out', () async {
      handle(null);
      final store = MemoryLanguageStore()..loaded = false;
      final c = await _container(os: 'ja', store: store);

      await c.read(deviceLanguageProvider.notifier).mirror('en');

      expect(store.saved, isEmpty);
      expect(c.read(currentLanguageProvider), 'ja');
    });

    test('an unchanged pick is not written again', () async {
      handle(null);
      final store = MemoryLanguageStore();
      final c = await _container(store: store);
      final device = c.read(deviceLanguageProvider.notifier);

      await device.pick('es');
      await device.pick('es');
      await device.markFirstLaunchDone();

      expect(store.saved, [_picked('es', 'en')]);
    });

    test('markFirstLaunchDone keeps the pick', () async {
      final store = MemoryLanguageStore(noStoredLanguage);
      final c = await _container(store: store);

      await c.read(deviceLanguageProvider.notifier).markFirstLaunchDone();

      expect(store.value, returningDevice);
    });
  });
}
