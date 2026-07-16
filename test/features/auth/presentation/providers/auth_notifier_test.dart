import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/auth/data/repositories/auth_repository.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';
import 'package:seed_app/shared/services/fcm_service.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockFcmService extends Mock implements FCMService {}

void main() {
  // Regression: signOut must still sign out of the repository when the
  // best-effort FCM cleanup fails (deleteToken throws on iOS without an APNS
  // token). This also guards keepAlive on AuthNotifier -- an autoDispose
  // notifier invoked via read() would be disposed during the FCM await, so
  // repository.signOut() would never run and logout would silently fail.
  test(
    'signOut signs out of the repository even when FCM cleanup throws',
    () async {
      final repo = _MockAuthRepository();
      final fcm = _MockFcmService();
      when(repo.signOut).thenAnswer((_) async {});
      when(fcm.removeStoredToken).thenAnswer((_) async {});
      when(fcm.deleteToken).thenThrow(Exception('apns-token-not-set'));

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repo),
          fcmServiceProvider.overrideWithValue(fcm),
        ],
      );
      addTearDown(container.dispose);

      // read (not watch) mirrors the profile logout button.
      await container.read(authProvider.notifier).signOut();

      verify(repo.signOut).called(1);
    },
  );
}
