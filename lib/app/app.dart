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

class SeedApp extends ConsumerWidget {
  const SeedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appLocale = ref.watch(appLocaleProvider);

    // Sync analytics opt-out when setting loads from Firestore
    final analyticsOn = ref.watch(analyticsEnabledProvider);
    AnalyticsService.instance.setEnabled(enabled: analyticsOn);
    FirebaseAnalytics.instance
        .setAnalyticsCollectionEnabled(analyticsOn);
    FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(analyticsOn);

    // Sync Crashlytics user identifier with auth state
    ref.watch(authStateChangesProvider).whenData((user) {
      FirebaseCrashlytics.instance
          .setUserIdentifier(user?.uid ?? '');
    });

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
