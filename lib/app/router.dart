import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/app_constants.dart';
import '../core/l10n/generated/app_localizations.dart';
import '../core/utils/app_logger.dart';
import '../features/actions/presentation/screens/action_history_screen.dart';
import '../features/actions/presentation/screens/action_log_screen.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/email_verification_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/challenge/presentation/screens/challenges_screen.dart';
import '../features/eco_fact/eco_fact.dart';
import '../features/energy/energy.dart';
import '../features/food/food.dart';
import '../features/home/home.dart';
import '../features/mascot/mascot.dart';
import '../features/profile/profile.dart';
import '../features/progress/progress.dart';
import '../features/quiz/quiz.dart';
import '../features/sdg/sdg.dart';
import '../features/settings/presentation/screens/about_screen.dart';
import '../features/settings/presentation/screens/account_settings_screen.dart';
import '../features/settings/presentation/screens/feedback_screen.dart';
import '../features/settings/presentation/screens/language_settings_screen.dart';
import '../features/settings/presentation/screens/notification_settings_screen.dart';
import '../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/settings/presentation/screens/terms_of_service_screen.dart';
import '../features/transport/transport.dart';
import '../shared/services/analytics_service.dart';
import 'main_shell.dart';

part 'router.g.dart';

int _parseSdgGoalNumber(String? value) {
  final parsed = int.tryParse(value ?? '') ?? AppConstants.sdgMinGoal;
  return parsed.clamp(AppConstants.sdgMinGoal, AppConstants.sdgMaxGoal);
}

/// A route whose screen needs nothing from the router state.
GoRoute _route(
  String path,
  Widget child, {
  List<RouteBase> routes = const [],
}) => GoRoute(path: path, builder: (_, _) => child, routes: routes);

/// Full-path routes for use at navigation call sites via [appRoutes].
///
/// Nested `GoRoute` declarations in this file still use relative path
/// literals (go_router requires this for child routes), but every
/// `context.push` / `context.go` should reference [appRoutes] so the
/// app has a single source of truth for navigation paths.
class AppRoutes {
  const AppRoutes._();

  // Top-level (accessible while unauthenticated)
  String get splash => '/';
  String get login => '/login';
  String get register => '/register';
  String get privacy => '/privacy';
  String get terms => '/terms';

  // Top-level (require authentication)
  String get emailVerification => '/verify-email';
  String get mascotSelection => '/mascot-selection';
  String get actionLog => '/log-action';
  String get transportCalculator => '/transport-calculator';
  String get foodCalculator => '/food-calculator';
  String get energyCalculator => '/energy-calculator';
  String get energyExplore => '/energy-explore';
  String get quiz => '/quiz';

  /// Action log pre-filtered to a single [ActionCategory] name, used by the
  /// daily challenge card so its category opens already selected.
  String actionLogForCategory(String category) =>
      Uri(path: actionLog, queryParameters: {'category': category}).toString();

  // Main shell tabs
  String get home => '/home';
  String get progress => '/progress';
  String get mascot => '/mascot';
  String get profile => '/profile';

  // Nested under home
  String get dailyFact => '/home/daily-fact';
  String get challenges => '/home/challenges';
  String sdgDetail(int goalNumber) => '/home/sdg/$goalNumber';
  String dailyFactDetail(String dateKey) => '/home/daily-fact/$dateKey';

  // Nested under progress
  String get actionHistory => '/progress/history';

  // Nested under profile
  String get settings => '/profile/settings';
  String get settingsNotifications => '/profile/settings/notifications';
  String get settingsLanguage => '/profile/settings/language';
  String get settingsAccount => '/profile/settings/account';
  String get settingsAbout => '/profile/settings/about';
  String get settingsFeedback => '/profile/settings/feedback';
}

/// Single shared instance for navigation call sites.
const appRoutes = AppRoutes._();

@riverpod
GoRouter router(Ref ref) {
  // redirect reads authStateChangesProvider with ref.read (a watch would
  // recreate the router and reset the navigation stack on every auth
  // emission). read alone does not retain an autoDispose provider, so an
  // empty listen keeps it alive. Registered before the refresh stream
  // subscribes so the provider observes each auth event first and redirect
  // never reads a stale value.
  ref.listen(authStateChangesProvider, (_, _) {});

  // Re-evaluates redirect on every auth event. Built once per provider
  // lifetime and disposed below so the Firebase subscription cannot leak.
  // userChanges() (not authStateChanges()) so email verification via
  // reload() re-runs the redirect and lets a verified user reach home.
  final refreshStream = GoRouterRefreshStream(
    ref.watch(firebaseAuthProvider).userChanges(),
  );

  final analyticsObserver = AnalyticsService.instance.observer;

  final router = GoRouter(
    initialLocation: appRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    observers: [?analyticsObserver],

    // Refresh router when auth state changes
    refreshListenable: refreshStream,

    routes: [
      // Splash / Loading screen
      _route(appRoutes.splash, const _SplashScreen()),

      // Auth routes
      _route(appRoutes.login, const LoginScreen()),
      _route(appRoutes.register, const RegisterScreen()),
      _route(appRoutes.emailVerification, const EmailVerificationScreen()),

      // Mascot selection (shown after signup if user has no mascot)
      _route(appRoutes.mascotSelection, const MascotSelectionScreen()),

      // Main app routes with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Home tab (index 0)
          StatefulShellBranch(
            routes: [
              _route(
                appRoutes.home,
                const HomeScreen(),
                routes: [
                  // SDG detail is nested under home
                  GoRoute(
                    path: 'sdg/:goalNumber',
                    builder: (_, state) {
                      final goalNumber = _parseSdgGoalNumber(
                        state.pathParameters['goalNumber'],
                      );
                      return SdgDetailScreen(goalNumber: goalNumber);
                    },
                  ),
                  // Daily eco-fact inbox nested under home
                  _route(
                    'daily-fact',
                    const EcoFactScreen(),
                    routes: [
                      GoRoute(
                        path: ':dateKey',
                        builder: (_, state) {
                          final dateKey = state.pathParameters['dateKey'] ?? '';
                          return EcoFactDetailScreen(dateKey: dateKey);
                        },
                      ),
                    ],
                  ),
                  // Multi-day challenges screen
                  _route('challenges', const ChallengesScreen()),
                ],
              ),
            ],
          ),

          // Progress tab (index 1)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: appRoutes.progress,
                builder: (_, state) => ProgressScreen(
                  initialTab: state.uri.queryParameters['tab'],
                ),
                routes: [
                  // Action history nested under progress
                  _route('history', const ActionHistoryScreen()),
                ],
              ),
            ],
          ),

          // Mascot tab (index 2)
          StatefulShellBranch(
            routes: [_route(appRoutes.mascot, const MascotScreen())],
          ),

          // Profile tab (index 3)
          StatefulShellBranch(
            routes: [
              _route(
                appRoutes.profile,
                const ProfileScreen(),
                routes: [
                  _route(
                    'settings',
                    const SettingsScreen(),
                    routes: [
                      _route(
                        'notifications',
                        const NotificationSettingsScreen(),
                      ),
                      _route('language', const LanguageSettingsScreen()),
                      _route('account', const AccountSettingsScreen()),
                      _route('about', const AboutScreen()),
                      _route('feedback', const FeedbackScreen()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Action log: a primary nav destination reached via the centre Action
      // button (and contextual cards). NoTransitionPage makes entering and
      // leaving instant, matching the shell tabs' IndexedStack swap, instead
      // of sliding in as a pushed page and out to the edge on exit.
      GoRoute(
        path: appRoutes.actionLog,
        pageBuilder: (_, state) => NoTransitionPage(
          key: state.pageKey,
          child: ActionLogScreen(
            initialCategory: state.uri.queryParameters['category'],
          ),
        ),
      ),

      // Transport carbon calculator: educational tool pushed
      // full-screen from contextual entry points (Phase 8).
      _route(appRoutes.transportCalculator, const TransportCalculatorScreen()),

      // Food carbon calculator: educational tool pushed full-screen
      // from contextual entry points (Phase 8, Part 2).
      _route(appRoutes.foodCalculator, const FoodCalculatorScreen()),

      // Home energy calculator: teaching tool pushed full-screen from
      // contextual entry points (Phase 8, Part 3). Banks nothing.
      _route(appRoutes.energyCalculator, const EnergyCalculatorScreen()),

      // The two energy teaching surfaces promoted out of the
      // methodology page (decision E8): the ranked list of where energy
      // goes, and the higher-or-lower quiz over the same rows.
      _route(appRoutes.energyExplore, const EnergyExploreScreen()),
      _route(appRoutes.quiz, const HigherOrLowerScreen()),

      // Legal documents - canonical paths, accessible unauthenticated so
      // the register screen can link to them before sign-up.
      _route(appRoutes.privacy, const PrivacyPolicyScreen()),
      _route(appRoutes.terms, const TermsOfServiceScreen()),
    ],

    // Redirect logic based on auth state
    redirect: (_, state) {
      final authState = ref.read(authStateChangesProvider);
      return authState.when(
        data: (user) {
          final currentPath = state.matchedLocation;
          final isOnAuthPage =
              currentPath == appRoutes.login ||
              currentPath == appRoutes.register;
          final isOnSplash = currentPath == appRoutes.splash;
          final isOnVerification = currentPath == appRoutes.emailVerification;
          final isOnPublicLegal =
              currentPath == appRoutes.privacy ||
              currentPath == appRoutes.terms;

          // Not logged in - allow auth pages and public legal docs only
          if (user == null) {
            return (isOnAuthPage || isOnPublicLegal) ? null : appRoutes.login;
          }

          // Logged in but email not verified (email/password users only)
          final isEmailPasswordUser = user.providerData.any(
            (p) => p.providerId == 'password',
          );
          if (!user.emailVerified && isEmailPasswordUser) {
            if (isOnVerification || isOnPublicLegal) return null;
            return appRoutes.emailVerification;
          }

          // Logged in and verified - bounce away from auth/splash pages
          if (isOnAuthPage || isOnSplash || isOnVerification) {
            return appRoutes.home;
          }

          return null;
        },
        loading: () {
          // Show splash while loading
          final isOnSplash = state.matchedLocation == appRoutes.splash;
          return isOnSplash ? null : appRoutes.splash;
        },
        error: (_, _) {
          // On error, redirect to login
          final isOnAuthPage =
              state.matchedLocation == appRoutes.login ||
              state.matchedLocation == appRoutes.register;
          return isOnAuthPage ? null : appRoutes.login;
        },
      );
    },

    // Error handling
    errorBuilder: (context, state) {
      appLogger.warning('No route for ${state.uri}');
      return Scaffold(
        body: Center(child: Text(AppLocalizations.of(context).routeNotFound)),
      );
    },
  );

  // Router first: GoRouter detaches from refreshStream in its dispose,
  // which must happen while the ChangeNotifier is still usable.
  ref.onDispose(() {
    router.dispose();
    refreshStream.dispose();
  });

  return router;
}

/// Splash screen shown while determining auth state.
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Helper class that notifies GoRouter when auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
