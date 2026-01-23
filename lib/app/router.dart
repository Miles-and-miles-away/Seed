import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/actions/presentation/screens/action_history_screen.dart';
import '../features/actions/presentation/screens/action_log_screen.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/email_verification_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/mascot/mascot.dart';
import '../features/profile/profile.dart';
import '../features/progress/progress.dart';
import '../features/sdg/sdg.dart';
import 'main_shell.dart';

part 'router.g.dart';

/// Route paths as constants to avoid typos
abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const emailVerification = '/verify-email';
  static const home = '/home';
  static const progress = '/progress';
  static const mascot = '/mascot';
  static const profile = '/profile';
  static const settings = '/settings';
  static const actionLog = '/log-action';
  static const actionHistory = '/history';
  static const sdgDetail = '/sdg/:goalNumber';
  static const mascotSelection = '/mascot-selection';
}

@riverpod
GoRouter router(Ref ref) {
  // Watch auth state to redirect unauthenticated users
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

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
                      final goalNumber =
                          int.tryParse(state.pathParameters['goalNumber'] ?? '1') ?? 1;
                      return SdgDetailScreen(goalNumber: goalNumber);
                    },
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
                    builder: (context, state) =>
                        const _PlaceholderScreen(title: 'Settings'),
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

      // Standalone SDG route (for deep links)
      GoRoute(
        path: '/sdg/:goalNumber',
        builder: (context, state) {
          final goalNumber =
              int.tryParse(state.pathParameters['goalNumber'] ?? '1') ?? 1;
          return SdgDetailScreen(goalNumber: goalNumber);
        },
      ),

      // Standalone action history (for deep links)
      GoRoute(
        path: AppRoutes.actionHistory,
        builder: (context, state) => const ActionHistoryScreen(),
      ),

      // Standalone settings (for deep links)
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Settings'),
      ),
    ],

    // Redirect logic based on auth state
    redirect: (context, state) {
      // Pattern match on auth state
      return authState.when(
        data: (user) {
          final currentPath = state.matchedLocation;
          final isOnAuthPage = currentPath == AppRoutes.login ||
              currentPath == AppRoutes.register;
          final isOnSplash = currentPath == AppRoutes.splash;
          final isOnVerification = currentPath == AppRoutes.emailVerification;

          // Not logged in - redirect to login
          if (user == null) {
            return isOnAuthPage ? null : AppRoutes.login;
          }

          // Logged in but email not verified (for email/password users only)
          final isEmailPasswordUser =
              user.providerData.any((p) => p.providerId == 'password');
          if (!user.emailVerified && isEmailPasswordUser) {
            return isOnVerification ? null : AppRoutes.emailVerification;
          }

          // Logged in and verified - redirect away from auth pages
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

/// Temporary placeholder screen for development
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('Placeholder - implement this screen'),
          ],
        ),
      ),
    );
  }
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
