import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/app/app_bottom_nav.dart';
import 'package:seed_app/app/main_shell.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:seed_app/features/auth/presentation/screens/login_screen.dart';
import 'package:seed_app/features/explore/explore.dart';
import 'package:seed_app/features/home/presentation/screens/home_screen.dart';
import 'package:seed_app/features/mascot/mascot.dart';
import 'package:seed_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:seed_app/features/settings/settings.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';
import 'package:seed_app/shared/services/fcm_service.dart';

import '../features/walkthrough/walkthrough_test_support.dart';
import '../helpers/test_helpers.dart';

// Firebase-touching services signOut() calls; no-ops keep the flow off the
// network under test.
class _FakeAnalyticsService extends Fake implements AnalyticsService {
  @override
  Future<void> logLogout() async {}
  @override
  Future<void> setUserId(String? id) async {}
}

class _FakeCrashlytics extends Fake implements FirebaseCrashlytics {
  @override
  Future<void> setCustomKey(String key, Object value) async {}
}

class _FakeFcmService extends Fake implements FCMService {
  @override
  Future<void> removeStoredToken() async {}
  @override
  Future<void> deleteToken() async {}
}

/// The routed app under a caller-supplied ProviderScope.
class _RouterApp extends StatelessWidget {
  const _RouterApp();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => MaterialApp.router(
        routerConfig: ref.watch(routerProvider),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  // Each call must return a fresh stream: the router listens twice (the
  // auth state provider and the refresh listenable) and a shared
  // single-subscription stream would throw on the second listen.
  // Production uses userChanges() (not authStateChanges) so email
  // verification via reload() propagates.
  MockFirebaseAuth authReturning(User? user) {
    final auth = MockFirebaseAuth();
    when(() => auth.currentUser).thenReturn(user);
    when(auth.userChanges).thenAnswer((_) => Stream.value(user));
    return auth;
  }

  Widget buildApp(MockFirebaseAuth auth, {bool withMascot = false}) {
    return ProviderScope(
      overrides: [
        languageStoreOverride(),
        crashlyticsProvider.overrideWithValue(_FakeCrashlytics()),
        firebaseAuthProvider.overrideWithValue(auth),
        firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
        // Home renders inside the shell; skip Firestore mascot lookups.
        hasMascotProvider.overrideWithValue(withMascot),
        if (withMascot) ...[
          userOverride(const AppUserModel(uid: 'test-uid', email: 'e')),
          activeMascotProvider.overrideWith(
            (_) => Stream.value(
              const MascotModel(id: 'm', speciesId: 'seed', name: 'Pip'),
            ),
          ),
          // An SVG keeps MascotDisplay off Rive.
          activeMascotAssetPathProvider.overrideWith(
            (_) => 'assets/images/mascot/seed_stage1.svg',
          ),
          hasNewEvolutionProvider.overrideWithValue(false),
          shouldShowEggDiscoveryProvider.overrideWithValue(false),
          // Every item found, so no walkthrough covers the screens.
          userSettingsProvider.overrideWith(
            (_) => Stream.value(settingsWith(WalkthroughItem.values)),
          ),
        ],
      ],
      child: const _RouterApp(),
    );
  }

  ProviderContainer containerOf(WidgetTester tester) {
    return ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
      listen: false,
    );
  }

  String locationOf(WidgetTester tester) => containerOf(
    tester,
  ).read(routerProvider).routerDelegate.currentConfiguration.uri.path;

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

    testWidgets('signed-in verified user reaches the home shell', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      final user = createMockUser();

      await tester.pumpWidget(buildApp(authReturning(user)));
      await pumpRedirects(tester);

      expect(locationOf(tester), appRoutes.home);
      expect(find.byType(MainShell), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('unverified password user is sent to verify-email', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      final user = createMockUser(emailVerified: false);

      await tester.pumpWidget(buildApp(authReturning(user)));
      await tester.pumpAndSettle();

      expect(locationOf(tester), appRoutes.emailVerification);
      expect(find.byType(EmailVerificationScreen), findsOneWidget);
    });

    testWidgets('sign-out mid-session lands on /login with the same router', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      final user = createMockUser();
      final auth = MockFirebaseAuth();
      final controller = StreamController<User?>.broadcast();
      addTearDown(controller.close);
      when(() => auth.currentUser).thenReturn(user);
      when(auth.userChanges).thenAnswer((_) => controller.stream);

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

    testWidgets('AuthNotifier.signOut drives the app from home to /login', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      final user = createMockUser();
      final auth = MockFirebaseAuth();
      final controller = StreamController<User?>.broadcast();
      addTearDown(controller.close);
      when(() => auth.currentUser).thenReturn(user);
      when(auth.userChanges).thenAnswer((_) => controller.stream);
      // The real repository/datasource call firebaseAuth.signOut(); simulate
      // Firebase clearing the session and emitting on userChanges.
      when(auth.signOut).thenAnswer((_) async {
        when(() => auth.currentUser).thenReturn(null);
        controller.add(null);
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            languageStoreOverride(),
            firebaseAuthProvider.overrideWithValue(auth),
            firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
            hasMascotProvider.overrideWithValue(false),
            analyticsServiceProvider.overrideWithValue(_FakeAnalyticsService()),
            crashlyticsProvider.overrideWithValue(_FakeCrashlytics()),
            fcmServiceProvider.overrideWithValue(_FakeFcmService()),
          ],
          child: const _RouterApp(),
        ),
      );
      controller.add(user);
      await pumpRedirects(tester);
      expect(locationOf(tester), appRoutes.home);

      // Exactly what the profile logout button does: read the notifier and
      // call signOut. Exercises the full notifier -> repository -> datasource
      // -> auth-stream -> router chain that the logout bugs lived in.
      await containerOf(tester).read(authProvider.notifier).signOut();
      await pumpRedirects(tester);

      expect(locationOf(tester), appRoutes.login);
      expect(find.byType(LoginScreen), findsOneWidget);

      await disposeAndFlush(tester);
    });
  });

  int? selectedTab(WidgetTester tester) =>
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).currentIndex;

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.text(label),
      ),
    );
    await pumpRedirects(tester);
  }

  group('Explore tab and Mascot screen', () {
    const homeTabIndex = 0;
    const exploreTabIndex = 2;
    const profileTabIndex = 3;

    testWidgets('Explore is the third shell branch', (tester) async {
      setLargeScreenSize(tester);
      await tester.pumpWidget(
        buildApp(authReturning(createMockUser()), withMascot: true),
      );
      await pumpRedirects(tester);

      await tapTab(tester, 'Explore');

      expect(find.byType(ExploreScreen), findsOneWidget);
      expect(selectedTab(tester), exploreTabIndex);

      await disposeAndFlush(tester);
    });

    testWidgets('the Profile row opens Mascot over Profile; back returns', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      await tester.pumpWidget(
        buildApp(authReturning(createMockUser()), withMascot: true),
      );
      await pumpRedirects(tester);
      await tapTab(tester, 'Profile');
      expect(find.byType(ProfileScreen), findsOneWidget);

      await tester.tap(find.text('Your mascot'));
      await pumpRedirects(tester);

      expect(find.byType(MascotScreen), findsOneWidget);
      expect(selectedTab(tester), profileTabIndex);

      await tester.pageBack();
      await pumpRedirects(tester);
      await pumpRedirects(tester);

      expect(find.byType(MascotScreen, skipOffstage: false), findsNothing);
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(selectedTab(tester), profileTabIndex);

      await tapTab(tester, 'Home');

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(MascotScreen, skipOffstage: false), findsNothing);
      expect(locationOf(tester), appRoutes.home);

      await disposeAndFlush(tester);
    });

    testWidgets('the Home mascot opens Mascot with Home selected', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      await tester.pumpWidget(
        buildApp(authReturning(createMockUser()), withMascot: true),
      );
      await pumpRedirects(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(HomeScreen),
          matching: find.byType(MascotDisplay),
        ),
      );
      await pumpRedirects(tester);

      expect(find.byType(MascotScreen), findsOneWidget);
      expect(selectedTab(tester), homeTabIndex);

      await disposeAndFlush(tester);
    });
  });

  group('settings entry from Home', () {
    const homeTabIndex = 0;

    testWidgets('the Home gear opens Settings over Home and back returns', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      await tester.pumpWidget(buildApp(authReturning(createMockUser())));
      await pumpRedirects(tester);
      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(HomeScreen),
          matching: find.byType(SettingsIconButton),
        ),
      );
      await pumpRedirects(tester);

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(selectedTab(tester), homeTabIndex);
      expect(find.byType(ProfileScreen, skipOffstage: false), findsNothing);

      await tester.pageBack();
      await pumpRedirects(tester);
      await pumpRedirects(tester);

      expect(find.byType(SettingsScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(ProfileScreen, skipOffstage: false), findsNothing);
      expect(selectedTab(tester), homeTabIndex);

      await disposeAndFlush(tester);
    });
  });
}
