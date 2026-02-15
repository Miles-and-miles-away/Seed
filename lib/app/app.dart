import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
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
      ..listenManual(
        analyticsEnabledProvider,
        (_, on) {
          AnalyticsService.instance
              .setEnabled(enabled: on);
          FirebaseAnalytics.instance
              .setAnalyticsCollectionEnabled(on);
          FirebaseCrashlytics.instance
              .setCrashlyticsCollectionEnabled(on);
        },
        fireImmediately: true,
      )
      // Sync Crashlytics user ID only on auth change
      ..listenManual(
        authStateChangesProvider,
        (_, next) {
          next.whenData((user) {
            FirebaseCrashlytics.instance
                .setUserIdentifier(user?.uid ?? '');
          });
        },
        fireImmediately: true,
      );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final appLocale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'Seed',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // Routing
      routerConfig: router,

      // Localization - use user's preferred locale
      locale: appLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('ja'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
