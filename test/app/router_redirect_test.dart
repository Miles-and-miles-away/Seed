import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/app/main_shell.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:seed_app/features/auth/presentation/screens/login_screen.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // CachedNetworkImage (home screen) resolves its cache directory via
    // path_provider, which has no platform implementation under test.
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
  });

  // Each call must return a fresh stream: the router listens twice (the
  // auth state provider and the refresh listenable) and a shared
  // single-subscription stream would throw on the second listen.
  MockFirebaseAuth authReturning(User? user) {
    final auth = MockFirebaseAuth();
    when(() => auth.currentUser).thenReturn(user);
    when(auth.authStateChanges).thenAnswer((_) => Stream.value(user));
    return auth;
  }

  Widget buildApp(MockFirebaseAuth auth) {
    return ProviderScope(
      overrides: [
        firebaseAuthProvider.overrideWithValue(auth),
        firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
        // Home renders inside the shell; skip Firestore mascot lookups.
        hasMascotProvider.overrideWithValue(false),
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          routerConfig: ref.watch(routerProvider),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }

  ProviderContainer containerOf(WidgetTester tester) {
    return ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
      listen: false,
    );
  }

  String locationOf(WidgetTester tester) => containerOf(tester)
      .read(routerProvider)
      .routerDelegate
      .currentConfiguration
      .uri
      .path;

  // The home shell hosts infinite animations (SDG carousel), so
  // pumpAndSettle would never return; bounded pumps let the auth event,
  // redirect and first frames complete instead.
  Future<void> pumpRedirects(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  // Unmounts the tree so container-owned resources dispose (the day-change
  // provider holds a midnight timer), then flushes the zero-duration
  // timers flutter_animate leaves behind.
  Future<void> disposeAndFlush(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  void setLargeScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  group('router redirect', () {
    testWidgets('signed-out user is redirected to /login', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(buildApp(authReturning(null)));
      await tester.pumpAndSettle();

      expect(locationOf(tester), appRoutes.login);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('signed-in verified user reaches the home shell',
        (tester) async {
      setLargeScreenSize(tester);
      final user = createMockUser();

      await tester.pumpWidget(buildApp(authReturning(user)));
      await pumpRedirects(tester);

      expect(locationOf(tester), appRoutes.home);
      expect(find.byType(MainShell), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('unverified password user is sent to verify-email',
        (tester) async {
      setLargeScreenSize(tester);
      final user = createMockUser(emailVerified: false);

      await tester.pumpWidget(buildApp(authReturning(user)));
      await tester.pumpAndSettle();

      expect(locationOf(tester), appRoutes.emailVerification);
      expect(find.byType(EmailVerificationScreen), findsOneWidget);
    });

    testWidgets('sign-out mid-session lands on /login with the same router',
        (tester) async {
      setLargeScreenSize(tester);
      final user = createMockUser();
      final auth = MockFirebaseAuth();
      final controller = StreamController<User?>.broadcast();
      addTearDown(controller.close);
      when(() => auth.currentUser).thenReturn(user);
      when(auth.authStateChanges).thenAnswer((_) => controller.stream);

      await tester.pumpWidget(buildApp(auth));
      // Listeners attach during the first build; a broadcast stream drops
      // earlier events, so emit only after pumping.
      controller.add(user);
      await pumpRedirects(tester);

      final routerBefore = containerOf(tester).read(routerProvider);
      expect(locationOf(tester), appRoutes.home);

      when(() => auth.currentUser).thenReturn(null);
      controller.add(null);
      await pumpRedirects(tester);

      final routerAfter = containerOf(tester).read(routerProvider);
      // The fix keeps one GoRouter per provider lifetime: an auth event
      // must re-run redirect, not rebuild the provider.
      expect(identical(routerBefore, routerAfter), isTrue);
      expect(locationOf(tester), appRoutes.login);
      expect(find.byType(LoginScreen), findsOneWidget);

      await disposeAndFlush(tester);
    });
  });
}
