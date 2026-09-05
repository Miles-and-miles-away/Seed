import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/mascot/presentation/providers/mascot_providers.dart';
import '../features/settings/settings.dart';
import '../shared/services/analytics_service.dart';
import 'router.dart';

class SeedApp extends ConsumerStatefulWidget {
  const SeedApp({super.key});

  @override
  ConsumerState<SeedApp> createState() => _SeedAppState();
}

class _SeedAppState extends ConsumerState<SeedApp> {
  @override
  void initState() {
    super.initState();

    // Sync analytics toggle only on change
    ref
      ..listenManual(analyticsEnabledProvider, (_, on) {
        AnalyticsService.instance.setEnabled(enabled: on);
        FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(on);
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(on);
      }, fireImmediately: true)
      // Sync Crashlytics user ID only on auth change
      ..listenManual(authStateChangesProvider, (_, next) {
        next.whenData((user) {
          FirebaseCrashlytics.instance.setUserIdentifier(user?.uid ?? '');
        });
      }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final appLocale = ref.watch(appLocaleProvider);
    final themeSeed = ref.watch(activeSpeciesThemeSeedProvider);

    return MaterialApp.router(
      title: 'Seed',
      debugShowCheckedModeBanner: false,

      // Disable Android 12+ stretch overscroll app-wide
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        overscroll: false,
      ),

      // Theme, seeded by the active mascot species
      theme: appTheme(Brightness.light, seedColor: themeSeed),
      darkTheme: appTheme(Brightness.dark, seedColor: themeSeed),

      // Routing
      routerConfig: router,

      // Localization - use user's preferred locale
      locale: appLocale,
      supportedLocales: const [Locale('en'), Locale('es'), Locale('ja')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
