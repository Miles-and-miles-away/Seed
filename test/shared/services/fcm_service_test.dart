import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/shared/services/fcm_service.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  const userId = 'user-1';
  // Long enough for the token-prefix debug log (substring(0, 20)).
  const fakeToken = 'fake-fcm-token-0123456789abcdef';

  late MockFirebaseMessaging messaging;
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late FCMService service;

  setUp(() {
    messaging = MockFirebaseMessaging();
    auth = MockFirebaseAuth();
    firestore = FakeFirebaseFirestore();
    service = FCMService.withDependencies(
      messaging: messaging,
      firestore: firestore,
      auth: auth,
    );

    when(() => auth.currentUser).thenReturn(null);
    when(() => messaging.onTokenRefresh)
        .thenAnswer((_) => const Stream<String>.empty());
    when(messaging.getToken).thenAnswer((_) async => null);
    when(messaging.getInitialMessage).thenAnswer((_) async => null);
  });

  Future<void> signIn() async {
    final user = MockUser();
    when(() => user.uid).thenReturn(userId);
    when(() => auth.currentUser).thenReturn(user);
    // _storeToken uses update(), which requires an existing doc.
    await firestore
        .collection(AppConstants.collectionUsers)
        .doc(userId)
        .set(<String, dynamic>{});
  }

  Future<String?> storedToken() async {
    final doc = await firestore
        .collection(AppConstants.collectionUsers)
        .doc(userId)
        .get();
    return doc.data()?['fcmToken'] as String?;
  }

  group('FCMService.initialize', () {
    test('never requests notification permission', () async {
      await service.initialize();

      verifyNever(messaging.requestPermission);
    });

    test('registers token listener and message handlers', () async {
      await service.initialize();

      verify(() => messaging.onTokenRefresh).called(1);
      verify(messaging.getToken).called(1);
      verify(messaging.getInitialMessage).called(1);
    });

    test('survives getToken failure (APNS token not set)', () async {
      when(messaging.getToken).thenThrow(
        FirebaseException(
          plugin: 'firebase_messaging',
          code: 'apns-token-not-set',
        ),
      );

      await service.initialize();

      // Handler registration must not depend on token retrieval.
      verify(() => messaging.onTokenRefresh).called(1);
      verify(messaging.getInitialMessage).called(1);
    });

    test('stores token for signed-in user', () async {
      await signIn();
      when(messaging.getToken).thenAnswer((_) async => fakeToken);

      await service.initialize();

      expect(await storedToken(), fakeToken);
    });

    test('stores refreshed tokens', () async {
      await signIn();
      final controller = StreamController<String>();
      addTearDown(controller.close);
      when(() => messaging.onTokenRefresh).thenAnswer((_) => controller.stream);

      await service.initialize();
      controller.add(fakeToken);
      await pumpEventQueue();

      expect(await storedToken(), fakeToken);
    });

    test('delivers initial message to onTap callback', () async {
      const message = RemoteMessage(messageId: 'msg-1');
      when(messaging.getInitialMessage).thenAnswer((_) async => message);

      RemoteMessage? tapped;
      await service.initialize(onTap: (m) => tapped = m);

      expect(tapped, same(message));
    });

    test('is a no-op when called twice', () async {
      await service.initialize();
      await service.initialize();

      verify(messaging.getToken).called(1);
    });
  });
}
