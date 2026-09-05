import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
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
  List<Override> overrides = const [],
  bool scaffold = false,
  Locale? locale,
  ThemeData? theme,
}) {
  return ProviderScope(
    overrides: [
      if (firebaseAuth != null)
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
      if (firestore != null) firestoreProvider.overrideWithValue(firestore),
      ...overrides,
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: theme,
      home: scaffold ? Scaffold(body: child) : child,
    ),
  );
}

// =============================================================================
// Provider Container Helpers
// =============================================================================

Override userOverride(AppUserModel? user) =>
    currentUserProvider.overrideWith((_) => Stream.value(user));

/// A container that is disposed with the test and has already let
/// [warm] (the current user by default) emit once, so synchronous
/// reads see settled state.
Future<ProviderContainer> pumpedContainer(
  List<Override> overrides, {
  ProviderListenable<Object?>? warm,
}) async {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  container.listen(warm ?? currentUserProvider, (_, _) {});
  await Future<void>.delayed(Duration.zero);
  return container;
}

// =============================================================================
// Widget Test Helpers
// =============================================================================

/// CachedNetworkImage resolves its cache directory via path_provider,
/// which has no platform implementation under test.
void stubPathProvider() {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
        switch (methodCall.method) {
          case 'getTemporaryDirectory':
          case 'getApplicationSupportDirectory':
          case 'getApplicationDocumentsDirectory':
            return '/tmp';
        }
        return null;
      });
}

/// A tall phone viewport so long screens lay out without scrolling.
void sizeViewport(WidgetTester tester, {Size size = const Size(1200, 2400)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

/// Pump until [finder] resolves or the budget runs out. For screens with
/// infinite idle animations that never settle; each step yields to the
/// real event loop via runAsync so asset futures and streams can emit.
Future<void> pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 30 && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
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
  // Production observes userChanges() (see AuthRemoteDataSource.authStateChanges);
  // the [authStateChanges] param feeds it. authStateChanges() is stubbed too
  // for any direct callers.
  when(
    mockAuth.userChanges,
  ).thenAnswer((_) => authStateChanges ?? Stream.value(currentUser));
  when(mockAuth.authStateChanges).thenAnswer((_) => Stream.value(currentUser));

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

/// WCAG contrast ratio between two opaque colours.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}
