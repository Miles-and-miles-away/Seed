import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/data/repositories/auth_repository.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';
import 'package:seed_app/shared/services/fcm_service.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockFcmService extends Mock implements FCMService {}

/// Records every analytics call in order.
class _RecordingAnalytics extends Fake implements AnalyticsService {
  final calls = <String>[];

  @override
  Future<void> logLogin({required String method}) async =>
      calls.add('login:$method');

  @override
  Future<void> logSignUp({required String method}) async =>
      calls.add('signup:$method');

  @override
  Future<void> logLogout() async => calls.add('logout');

  @override
  Future<void> setUserId(String? userId) async => calls.add('userId:$userId');
}

class _RecordingCrashlytics extends Fake implements FirebaseCrashlytics {
  String? identifier;

  @override
  Future<void> setUserIdentifier(String identifier) async =>
      this.identifier = identifier;
}

const _user = AppUserModel(uid: 'u', email: 'e');

void main() {
  late _MockAuthRepository repo;
  late _MockFcmService fcm;
  late _RecordingAnalytics analytics;
  late _RecordingCrashlytics crashlytics;
  late ProviderContainer container;

  setUp(() {
    repo = _MockAuthRepository();
    fcm = _MockFcmService();
    analytics = _RecordingAnalytics();
    crashlytics = _RecordingCrashlytics();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        fcmServiceProvider.overrideWithValue(fcm),
        analyticsServiceProvider.overrideWithValue(analytics),
        crashlyticsProvider.overrideWithValue(crashlytics),
      ],
    );
    addTearDown(container.dispose);
  });

  AuthNotifier notifier() => container.read(authProvider.notifier);

  group('sign-in and sign-up', () {
    test('email sign-in delegates and logs an email login', () async {
      when(
        () => repo.signInWithEmailAndPassword('a@b.com', 'pw'),
      ).thenAnswer((_) async => _user);

      await notifier().signInWithEmailAndPassword('a@b.com', 'pw');

      verify(() => repo.signInWithEmailAndPassword('a@b.com', 'pw')).called(1);
      expect(analytics.calls, ['login:email']);
      expect(container.read(authProvider).hasValue, isTrue);
    });

    test('email sign-up delegates and logs an email sign-up', () async {
      when(
        () => repo.createUserWithEmailAndPassword('a@b.com', 'pw'),
      ).thenAnswer((_) async => _user);

      await notifier().createUserWithEmailAndPassword('a@b.com', 'pw');

      verify(
        () => repo.createUserWithEmailAndPassword('a@b.com', 'pw'),
      ).called(1);
      expect(analytics.calls, ['signup:email']);
    });

    test('Google sign-in delegates and logs a google login', () async {
      when(repo.signInWithGoogle).thenAnswer((_) async => _user);

      await notifier().signInWithGoogle();

      verify(repo.signInWithGoogle).called(1);
      expect(analytics.calls, ['login:google']);
    });

    test('Apple sign-in delegates and logs an apple login', () async {
      when(repo.signInWithApple).thenAnswer((_) async => _user);

      await notifier().signInWithApple();

      verify(repo.signInWithApple).called(1);
      expect(analytics.calls, ['login:apple']);
    });

    test('a repository failure surfaces as an error state', () async {
      when(
        () => repo.signInWithEmailAndPassword(any(), any()),
      ).thenThrow(Exception('wrong-password'));

      await notifier().signInWithEmailAndPassword('a@b.com', 'pw');

      expect(container.read(authProvider).hasError, isTrue);
      expect(analytics.calls, isEmpty);
    });
  });

  group('signOut', () {
    test('clears FCM, signs out, then resets analytics identity', () async {
      when(repo.signOut).thenAnswer((_) async {});
      when(fcm.removeStoredToken).thenAnswer((_) async {});
      when(fcm.deleteToken).thenAnswer((_) async {});

      await notifier().signOut();

      verifyInOrder([fcm.removeStoredToken, fcm.deleteToken, repo.signOut]);
      expect(analytics.calls, ['logout', 'userId:null']);
      expect(crashlytics.identifier, '');
      expect(container.read(authProvider).hasValue, isTrue);
    });

    // Regression: signOut must still sign out of the repository when the
    // best-effort FCM cleanup fails (deleteToken throws on iOS without an
    // APNS token). This also guards keepAlive on AuthNotifier -- an
    // autoDispose notifier invoked via read() would be disposed during the
    // FCM await, so repository.signOut() would never run and logout would
    // silently fail.
    test('still signs out of the repository when FCM cleanup throws', () async {
      when(repo.signOut).thenAnswer((_) async {});
      when(fcm.removeStoredToken).thenAnswer((_) async {});
      when(fcm.deleteToken).thenThrow(Exception('apns-token-not-set'));

      // read (not watch) mirrors the profile logout button.
      await notifier().signOut();

      verify(repo.signOut).called(1);
      expect(analytics.calls, ['logout', 'userId:null']);
    });
  });

  group('profile edits', () {
    test(
      'updateDisplayName writes through without touching auth state',
      () async {
        when(() => repo.updateDisplayName('Ada')).thenAnswer((_) async {});
        var sawLoading = false;
        container.listen(authProvider, (_, next) {
          if (next.isLoading) sawLoading = true;
        });

        await notifier().updateDisplayName('Ada');

        verify(() => repo.updateDisplayName('Ada')).called(1);
        expect(sawLoading, isFalse);
      },
    );

    test('updatePersonalGoal writes through and rethrows failures', () async {
      when(
        () => repo.updatePersonalGoal('Go car-free'),
      ).thenAnswer((_) async {});
      await notifier().updatePersonalGoal('Go car-free');
      verify(() => repo.updatePersonalGoal('Go car-free')).called(1);

      when(
        () => repo.updatePersonalGoal('too long'),
      ).thenThrow(Exception('rejected'));
      await expectLater(
        notifier().updatePersonalGoal('too long'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
