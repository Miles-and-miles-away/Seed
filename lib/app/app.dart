import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
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

    // Sync the collection toggle only on change. While settings load the
    // provider reports its default, so hold the SDKs' persisted state
    // rather than switching an opted-out user back on for a moment.
    // The custom keys are crash triage context; they ride the toggle and
    // never hold per-user values, which would trip Crashlytics throttling.
    ref
      ..listenManual(analyticsEnabledProvider, (_, on) {
        if (ref.read(userSettingsProvider).isLoading) return;
        final collect = on && !kDebugMode;
        AnalyticsService.instance.setEnabled(enabled: on);
        FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(on);
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(collect);
        FirebasePerformance.instance.setPerformanceCollectionEnabled(collect);
      }, fireImmediately: true)
      ..listenManual(appLocaleProvider, (_, locale) {
        FirebaseCrashlytics.instance.setCustomKey(
          'locale',
          locale.toLanguageTag(),
        );
      }, fireImmediately: true)
      ..listenManual(activeSpeciesProvider, (_, species) {
        FirebaseCrashlytics.instance.setCustomKey(
          'species',
          species?.id ?? 'none',
        );
      }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final appLocale = ref.watch(appLocaleProvider);
    final themeSeed = ref.watch(activeSpeciesThemeSeedProvider);
    final themeMode = ref.watch(themeModeProvider);

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
      themeMode: themeMode,

      // Routing
      routerConfig: router,

      // Localization - use user's preferred locale
      locale: appLocale,
      supportedLocales: const [Locale('en'), Locale('es'), Locale('ja')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
