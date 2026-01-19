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

// Example providers to be implemented:
//
// export 'connectivity_provider.dart';
// export 'theme_provider.dart';
// export 'locale_provider.dart';
