import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/shared/services/fcm_service.dart';

import '../../helpers/test_helpers.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

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
    when(
      () => messaging.onTokenRefresh,
    ).thenAnswer((_) => const Stream<String>.empty());
    when(messaging.getToken).thenAnswer((_) async => null);
    when(messaging.getInitialMessage).thenAnswer((_) async => null);
  });

  Future<void> signIn() async {
    final user = MockUser();
    when(() => user.uid).thenReturn(userId);
    when(() => auth.currentUser).thenReturn(user);
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

    test('stores no token for a signed-in user', () async {
      await signIn();
      when(messaging.getToken).thenAnswer((_) async => fakeToken);

      await service.initialize();

      verifyNever(messaging.getToken);
      expect(await storedToken(), isNull);
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

      verify(messaging.getInitialMessage).called(1);
    });
  });
}
