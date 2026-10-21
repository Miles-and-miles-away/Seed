import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:seed_app/features/settings/settings.dart';

import '../../../../helpers/test_helpers.dart';

const _settingsStub = 'settings-stub';

void main() {
  group('ProfileScreen', () {
    testWidgets('the settings gear is labelled and pushes Settings', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: appRoutes.profile,
        routes: [
          GoRoute(
            path: appRoutes.profile,
            builder: (_, _) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (_, _) => const Text(_settingsStub),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [languageStoreOverride(), userOverride(null)],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SettingsIconButton), findsOneWidget);
      expect(find.byTooltip('Settings'), findsOneWidget);

      await tester.tap(find.byType(SettingsIconButton));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(_settingsStub), findsOneWidget);
    });
  });
}
