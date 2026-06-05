import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';

// =============================================================================
// Mock Classes
// =============================================================================

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUserInfo extends Mock implements UserInfo {}

// =============================================================================
// Test Wrapper Widget
// =============================================================================

/// Wraps a widget with MaterialApp and ProviderScope for testing.
Widget createTestWidget({
  required Widget child,
  FirebaseAuth? firebaseAuth,
  FirebaseFirestore? firestore,
}) {
  return ProviderScope(
    overrides: [
      if (firebaseAuth != null)
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
      if (firestore != null) firestoreProvider.overrideWithValue(firestore),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

// =============================================================================
// Mock Setup Helpers
// =============================================================================

/// Creates a mock FirebaseAuth with common configurations.
MockFirebaseAuth createMockFirebaseAuth({
  User? currentUser,
  Stream<User?>? authStateChanges,
}) {
  final mockAuth = MockFirebaseAuth();

  when(() => mockAuth.currentUser).thenReturn(currentUser);
  when(mockAuth.authStateChanges)
      .thenAnswer((_) => authStateChanges ?? Stream.value(currentUser));

  return mockAuth;
}

/// Creates a mock User with common configurations.
MockUser createMockUser({
  String uid = 'test-uid',
  String? email = 'test@example.com',
  bool emailVerified = true,
  String? displayName = 'Test User',
  List<UserInfo>? providerData,
}) {
  final mockUser = MockUser();

  when(() => mockUser.uid).thenReturn(uid);
  when(() => mockUser.email).thenReturn(email);
  when(() => mockUser.emailVerified).thenReturn(emailVerified);
  when(() => mockUser.displayName).thenReturn(displayName);

  // Create default provider data if not specified
  var resolvedProviderData = providerData;
  if (resolvedProviderData == null) {
    final mockUserInfo = MockUserInfo();
    when(() => mockUserInfo.providerId).thenReturn('password');
    resolvedProviderData = [mockUserInfo];
  }
  when(() => mockUser.providerData).thenReturn(resolvedProviderData);

  return mockUser;
}

/// Creates a FakeFirebaseFirestore with optional seed data.
FakeFirebaseFirestore createFakeFirestore() {
  return FakeFirebaseFirestore();
}

// =============================================================================
// Common Test Utilities
// =============================================================================

/// Pumps a widget and waits for all animations and async operations.
Future<void> pumpAndSettle(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 100),
}) async {
  await tester.pump(duration);
  await tester.pumpAndSettle();
}

/// Finds a widget by text and taps it.
Future<void> tapByText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

/// Enters text into a text field identified by its label.
Future<void> enterTextByLabel(
  WidgetTester tester,
  String label,
  String text,
) async {
  final field = find.widgetWithText(TextFormField, label);
  await tester.enterText(field, text);
  await tester.pumpAndSettle();
}
