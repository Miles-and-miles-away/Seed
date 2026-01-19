import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import feature screens as you create them
// import '../features/auth/presentation/screens/login_screen.dart';
// import '../features/actions/presentation/screens/home_screen.dart';
// import '../features/mascot/presentation/screens/mascot_screen.dart';
// import '../features/profile/presentation/screens/profile_screen.dart';
// import '../features/settings/presentation/screens/settings_screen.dart';

part 'router.g.dart';

/// Route paths as constants to avoid typos
abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const mascot = '/mascot';
  static const profile = '/profile';
  static const settings = '/settings';
  static const actionLog = '/log-action';
  static const actionHistory = '/history';
}

@riverpod
GoRouter router(Ref ref) {
  // TODO: Watch auth state to redirect unauthenticated users
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash / Loading screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _PlaceholderScreen(title: 'Seed'),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const _PlaceholderScreen(title: 'Login'),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Register'),
      ),

      // Main app routes (use ShellRoute for bottom nav later)
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
      ),
      GoRoute(
        path: AppRoutes.mascot,
        builder: (context, state) => const _PlaceholderScreen(title: 'Mascot'),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Settings'),
      ),
      GoRoute(
        path: AppRoutes.actionLog,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Log Action'),
      ),
      GoRoute(
        path: AppRoutes.actionHistory,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Action History'),
      ),
    ],

    // Redirect logic
    redirect: (context, state) {
      // TODO: Implement auth redirect
      // final isLoggedIn = authState.isLoggedIn;
      // final isLoggingIn = state.matchedLocation == AppRoutes.login;
      //
      // if (!isLoggedIn && !isLoggingIn) {
      //   return AppRoutes.login;
      // }
      // if (isLoggedIn && isLoggingIn) {
      //   return AppRoutes.home;
      // }
      return null;
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
