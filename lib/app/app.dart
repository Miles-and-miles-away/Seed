import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';
// import '../core/l10n/generated/app_localizations.dart';

class SeedApp extends ConsumerWidget {
  const SeedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Seed',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // Routing
      routerConfig: router,

      // Localization
      supportedLocales: const [
        Locale('en'),
        Locale('ja'),
      ],
      localizationsDelegates: const [
        // TODO: Uncomment after generating localizations
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
