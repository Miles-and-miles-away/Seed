import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';
import 'package:seed_app/features/settings/presentation/providers/language_sync_provider.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/shared/data/language_store.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';
import 'package:seed_app/shared/services/analytics_service.dart';

import '../../../../helpers/test_helpers.dart';

const _uid = 'u';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _RecordingAnalytics extends Fake implements AnalyticsService {
  final languages = <String>[];

  @override
  Future<void> logLanguageChanged({required String language}) async =>
      languages.add(language);
}

StoredLanguage _picked(String language, String os) =>
    (pick: (language: language, os: os), firstLaunchDone: true);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StreamController<User?> auth;
  late StreamController<UserSettingsModel> settings;
  late _MockSettingsRepository repo;
  late MockFirebaseAuth firebaseAuth;
  late _RecordingAnalytics analytics;

  setUp(() {
    auth = StreamController<User?>.broadcast();
    settings = StreamController<UserSettingsModel>.broadcast();
    addTearDown(auth.close);
    addTearDown(settings.close);
    repo = _MockSettingsRepository();
    when(() => repo.setLanguage(any(), any())).thenAnswer((_) async {});
    when(() => repo.backfillLanguage(any(), any())).thenAnswer((_) async {});
    firebaseAuth = MockFirebaseAuth();
    when(() => firebaseAuth.setLanguageCode(any())).thenAnswer((_) async {});
    analytics = _RecordingAnalytics();
  });

  Future<void> settle() => pumpEventQueue();

  /// The sync running in a container whose auth and settings streams the
  /// test drives. Nothing is signed in until [signIn].
  Future<ProviderContainer> start({
    String os = 'en',
    MemoryLanguageStore? store,
  }) async {
    final c = ProviderContainer(
      overrides: [
        languageStoreOverride(store ?? MemoryLanguageStore()),
        osLocalesProvider.overrideWithBuild((_, _) => [Locale(os)]),
        authStateChangesProvider.overrideWith((_) => auth.stream),
        userOverride(const AppUserModel(uid: _uid, email: 'e')),
        userSettingsProvider.overrideWith((ref) {
          if (ref.watch(userIdProvider) == null) {
            return Stream.value(UserSettingsModel.defaultSettings());
          }
          return settings.stream;
        }),
        settingsRepositoryProvider.overrideWithValue(repo),
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
        analyticsServiceProvider.overrideWithValue(analytics),
      ],
    );
    addTearDown(c.dispose);
    c
      ..listen(currentUserProvider, (_, _) {})
      ..listen(languageSyncProvider, (_, _) {});
    await settle();
    return c;
  }

  Future<void> signIn() async {
    auth.add(createMockUser(uid: _uid));
    await settle();
  }

  Future<void> emit(String? language, {List<String> found = const []}) async {
    settings.add(
      UserSettingsModel(language: language, walkthroughFound: found),
    );
    await settle();
  }

  String current(ProviderContainer c) => c.read(currentLanguageProvider);

  test('cold start after an OS change keeps the OS language', () async {
    final store = MemoryLanguageStore(_picked('en', 'en'));
    final c = await start(os: 'ja', store: store);
    expect(current(c), 'ja');

    await signIn();
    expect(current(c), 'ja');
    await emit('en');

    expect(current(c), 'ja');
    expect(store.value, _picked('en', 'en'));
    verifyNever(() => repo.setLanguage(any(), any()));
    verifyNever(() => repo.backfillLanguage(any(), any()));
  });

  test('a pick survives a stale snapshot until its echo', () async {
    final write = Completer<void>();
    when(() => repo.setLanguage(_uid, 'es')).thenAnswer((_) => write.future);
    final store = MemoryLanguageStore();
    final c = await start(store: store);
    await signIn();
    await emit('en');

    unawaited(c.read(languageSyncProvider.notifier).choose('es'));
    await settle();
    expect(current(c), 'es');

    await emit('en', found: ['quiz']);
    expect(current(c), 'es');

    await emit('es');
    write.complete();
    await settle();
    expect(current(c), 'es');
    expect(c.read(pendingLanguagePushProvider), isNull);
    expect(store.value, _picked('es', 'en'));
    verify(() => repo.setLanguage(_uid, 'es')).called(1);
  });

  test('a pick before the first snapshot outranks that snapshot', () async {
    final write = Completer<void>();
    when(() => repo.setLanguage(_uid, 'es')).thenAnswer((_) => write.future);
    final store = MemoryLanguageStore();
    final c = await start(store: store);
    await signIn();

    unawaited(c.read(languageSyncProvider.notifier).choose('es'));
    await settle();
    await emit('en');
    expect(current(c), 'es');
    expect(store.value.pick?.language, 'es');

    await emit('es');
    write.complete();
    await settle();
    auth.add(null);
    await settle();

    expect(current(c), 'es');
    expect(store.value.pick?.language, 'es');
  });

  test('picking and quickly picking back does not bounce', () async {
    final store = MemoryLanguageStore();
    final c = await start(store: store);
    await signIn();
    await emit('en');
    final shown = <String>[];
    c.listen(currentLanguageProvider, (_, code) => shown.add(code));
    final writesBefore = store.saved.length;

    final sync = c.read(languageSyncProvider.notifier);
    unawaited(sync.choose('es'));
    await settle();
    unawaited(sync.choose('en'));
    await settle();
    await emit('es');
    await emit('en');

    expect(shown, ['es', 'en']);
    expect(c.read(pendingLanguagePushProvider), isNull);
    expect(store.saved.length - writesBefore, 2);
  });

  test('building while already signed in modifies nothing mid-build', () async {
    final store = MemoryLanguageStore(noStoredLanguage);
    final c = ProviderContainer(
      overrides: [
        languageStoreOverride(store),
        osLocalesProvider.overrideWithBuild((_, _) => const [Locale('en')]),
        userIdProvider.overrideWithValue(_uid),
        userSettingsProvider.overrideWithValue(
          const AsyncData(UserSettingsModel(language: 'es')),
        ),
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
      ],
    );
    addTearDown(c.dispose);

    c.listen(languageSyncProvider, (_, _) {});
    await settle();

    expect(store.value, _picked('es', 'en'));
  });

  test('a live account change is adopted and ends an OS override', () async {
    final store = MemoryLanguageStore(_picked('en', 'en'));
    final c = await start(os: 'ja', store: store);
    await signIn();
    await emit('en');
    expect(current(c), 'ja');

    await emit('es');

    expect(store.value, _picked('es', 'ja'));
    expect(current(c), 'es');
  });

  test('the baseline mirror keeps an OS override', () async {
    final store = MemoryLanguageStore(_picked('en', 'en'));
    final c = await start(os: 'ja', store: store);
    await signIn();
    await emit('es');

    expect(store.value, _picked('es', 'en'));
    expect(current(c), 'ja');

    auth.add(null);
    await settle();
    expect(current(c), 'ja');
  });

  test('sign-out keeps the account language on screen', () async {
    final c = await start();
    await signIn();
    await emit('es');
    expect(current(c), 'es');

    auth.add(null);
    await settle();

    expect(c.read(userIdProvider), isNull);
    expect(current(c), 'es');
  });

  test('any sign-in marks the first launch done', () async {
    final store = MemoryLanguageStore(noStoredLanguage);
    await start(store: store);

    await signIn();

    expect(store.value.firstLaunchDone, isTrue);
  });

  group('backfill', () {
    test('an account with no language is backfilled once', () async {
      final c = await start(os: 'ja');
      await signIn();
      await emit(null);
      await emit(null, found: ['quiz']);

      expect(current(c), 'ja');
      verify(() => repo.backfillLanguage(_uid, 'ja')).called(1);
    });

    test('offline it fails quietly and changes nothing', () async {
      when(
        () => repo.backfillLanguage(any(), any()),
      ).thenThrow(FirebaseException(plugin: 'firestore', code: 'unavailable'));
      final store = MemoryLanguageStore();
      final c = await start(os: 'es', store: store);
      await signIn();
      await emit(null);

      expect(current(c), 'es');
      expect(store.value, returningDevice);
    });
  });

  test('a signed-out pick stays on this device', () async {
    final store = MemoryLanguageStore();
    final c = await start(store: store);

    await c.read(languageSyncProvider.notifier).choose('ja');

    expect(current(c), 'ja');
    expect(store.value, _picked('ja', 'en'));
    verifyNever(() => repo.setLanguage(any(), any()));
  });

  test('the Auth email language follows the app language', () async {
    final c = await start(os: 'es');
    verify(() => firebaseAuth.setLanguageCode('es')).called(1);

    await c.read(languageSyncProvider.notifier).choose('ja');
    await settle();

    verify(() => firebaseAuth.setLanguageCode('ja')).called(1);
  });

  test('only an in-app pick is logged to analytics', () async {
    final c = await start();
    await signIn();
    await emit(null);
    await emit('es');
    await emit('ja');
    expect(analytics.languages, isEmpty);

    await c.read(languageSyncProvider.notifier).choose('en');

    expect(analytics.languages, ['en']);
  });
}
