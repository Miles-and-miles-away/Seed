import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/app_constants.dart';
import '../features/actions/presentation/screens/action_history_screen.dart';
import '../features/actions/presentation/screens/action_log_screen.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/email_verification_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/challenge/presentation/screens/challenges_screen.dart';
import '../features/eco_fact/eco_fact.dart';
import '../features/home/home.dart';
import '../features/mascot/mascot.dart';
import '../features/profile/profile.dart';
import '../features/progress/progress.dart';
import '../features/sdg/sdg.dart';
import '../features/settings/presentation/screens/about_screen.dart';
import '../features/settings/presentation/screens/account_settings_screen.dart';
import '../features/settings/presentation/screens/language_settings_screen.dart';
import '../features/settings/presentation/screens/notification_settings_screen.dart';
import '../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/settings/presentation/screens/terms_of_service_screen.dart';
import '../shared/services/analytics_service.dart';
import 'main_shell.dart';

part 'router.g.dart';

int _parseSdgGoalNumber(String? value) {
  final parsed = int.tryParse(value ?? '') ?? AppConstants.sdgMinGoal;
  return parsed.clamp(
    AppConstants.sdgMinGoal,
    AppConstants.sdgMaxGoal,
  );
}

// ignore: avoid_classes_with_only_static_members
/// Full-path route constants for use at navigation call sites.
///
/// Nested `GoRoute` declarations in this file still use relative path
/// literals (go_router requires this for child routes), but every
/// `context.push` / `context.go` should reference these constants so the
/// app has a single source of truth for navigation paths.
abstract class AppRoutes {
  // Top-level (accessible while unauthenticated)
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const privacy = '/privacy';
  static const terms = '/terms';

  // Top-level (require authentication)
  static const emailVerification = '/verify-email';
  static const mascotSelection = '/mascot-selection';
  static const actionLog = '/log-action';

  // Main shell tabs
  static const home = '/home';
  static const progress = '/progress';
  static const mascot = '/mascot';
  static const profile = '/profile';

  // Nested under home
  static const dailyFact = '/home/daily-fact';
  static const challenges = '/home/challenges';
  static String sdgDetail(int goalNumber) => '/home/sdg/$goalNumber';
  static String dailyFactDetail(String dateKey) => '/home/daily-fact/$dateKey';

  // Nested under progress
  static const actionHistory = '/progress/history';

  // Nested under profile
  static const settings = '/profile/settings';
  static const settingsNotifications = '/profile/settings/notifications';
  static const settingsLanguage = '/profile/settings/language';
  static const settingsAccount = '/profile/settings/account';
  static const settingsAbout = '/profile/settings/about';
}

@riverpod
GoRouter router(Ref ref) {
  // Watch auth state to redirect unauthenticated users
  final authState = ref.watch(authStateChangesProvider);

  final analyticsObserver = AnalyticsService.instance.observer;

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    observers: [
      if (analyticsObserver != null) analyticsObserver,
    ],

    // Refresh router when auth state changes
    refreshListenable: GoRouterRefreshStream(
      ref.watch(firebaseAuthProvider).authStateChanges(),
    ),

    routes: [
      // Splash / Loading screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.emailVerification,
        builder: (context, state) => const EmailVerificationScreen(),
      ),

      // Mascot selection (shown after signup if user has no mascot)
      GoRoute(
        path: AppRoutes.mascotSelection,
        builder: (context, state) => const MascotSelectionScreen(),
      ),

      // Main app routes with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Home tab (index 0)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  // SDG detail is nested under home
                  GoRoute(
                    path: 'sdg/:goalNumber',
                    builder: (context, state) {
                      final goalNumber = _parseSdgGoalNumber(
                        state.pathParameters['goalNumber'],
                      );
                      return SdgDetailScreen(goalNumber: goalNumber);
                    },
                  ),
                  // Daily eco-fact inbox nested under home
                  GoRoute(
                    path: 'daily-fact',
                    builder: (context, state) => const EcoFactScreen(),
                    routes: [
                      GoRoute(
                        path: ':dateKey',
                        builder: (context, state) {
                          final dateKey = state.pathParameters['dateKey'] ?? '';
                          return EcoFactDetailScreen(dateKey: dateKey);
                        },
                      ),
                    ],
                  ),
                  // Multi-day challenges screen
                  GoRoute(
                    path: 'challenges',
                    builder: (context, state) => const ChallengesScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Progress tab (index 1)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                builder: (context, state) => const ProgressScreen(),
                routes: [
                  // Action history nested under progress
                  GoRoute(
                    path: 'history',
                    builder: (context, state) => const ActionHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Mascot tab (index 2)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mascot,
                builder: (context, state) => const MascotScreen(),
              ),
            ],
          ),

          // Profile tab (index 3)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                    routes: [
                      GoRoute(
                        path: 'notifications',
                        builder: (context, state) =>
                            const NotificationSettingsScreen(),
                      ),
                      GoRoute(
                        path: 'language',
                        builder: (context, state) =>
                            const LanguageSettingsScreen(),
                      ),
                      GoRoute(
                        path: 'account',
                        builder: (context, state) =>
                            const AccountSettingsScreen(),
                      ),
                      GoRoute(
                        path: 'about',
                        builder: (context, state) => const AboutScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Action log (modal/push route, not in bottom nav)
      GoRoute(
        path: AppRoutes.actionLog,
        builder: (context, state) => const ActionLogScreen(),
      ),

      // Legal documents - canonical paths, accessible unauthenticated so
      // the register screen can link to them before sign-up.
      GoRoute(
        path: AppRoutes.privacy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.terms,
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
    ],

    // Redirect logic based on auth state
    redirect: (context, state) {
      return authState.when(
        data: (user) {
          final currentPath = state.matchedLocation;
          final isOnAuthPage = currentPath == AppRoutes.login ||
              currentPath == AppRoutes.register;
          final isOnSplash = currentPath == AppRoutes.splash;
          final isOnVerification = currentPath == AppRoutes.emailVerification;
          final isOnPublicLegal = currentPath == AppRoutes.privacy ||
              currentPath == AppRoutes.terms;

          // Not logged in - allow auth pages and public legal docs only
          if (user == null) {
            return (isOnAuthPage || isOnPublicLegal) ? null : AppRoutes.login;
          }

          // Logged in but email not verified (email/password users only)
          final isEmailPasswordUser =
              user.providerData.any((p) => p.providerId == 'password');
          if (!user.emailVerified && isEmailPasswordUser) {
            if (isOnVerification || isOnPublicLegal) return null;
            return AppRoutes.emailVerification;
          }

          // Logged in and verified - bounce away from auth/splash pages
          if (isOnAuthPage || isOnSplash || isOnVerification) {
            return AppRoutes.home;
          }

          return null;
        },
        loading: () {
          // Show splash while loading
          final isOnSplash = state.matchedLocation == AppRoutes.splash;
          return isOnSplash ? null : AppRoutes.splash;
        },
        error: (_, __) {
          // On error, redirect to login
          final isOnAuthPage = state.matchedLocation == AppRoutes.login ||
              state.matchedLocation == AppRoutes.register;
          return isOnAuthPage ? null : AppRoutes.login;
        },
      );
    },

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
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
            Icon(
              Icons.eco,
              size: 80,
              color: theme.colorScheme.primary,
            ),
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
