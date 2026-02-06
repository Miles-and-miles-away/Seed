/// Barrel file for global providers
/// Export shared providers here as you create them
library;

// Re-export auth providers for app-wide access
export '../../features/auth/presentation/providers/auth_providers.dart'
    show
        authProvider,
        authRepositoryProvider,
        authStateChangesProvider,
        currentUserProvider,
        firebaseAuthProvider;

// Analytics provider
export 'analytics_provider.dart';

// Notification providers
export 'notification_providers.dart';
