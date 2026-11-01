import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:seed_app/features/settings/settings.dart';

import '../../../../helpers/test_helpers.dart';

const _settingsStub = 'settings-stub';
const _mascotStub = 'mascot-stub';
const _user = AppUserModel(uid: 'u', email: 'u@example.com');
const _mascot = MascotModel(id: 'm', speciesId: 'seed', name: 'Pip');

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

    group('Your mascot row', () {
      Future<void> pumpProfile(
        WidgetTester tester, {
        required bool hasMascot,
        Locale? locale,
        ThemeData? theme,
      }) async {
        final router = GoRouter(
          initialLocation: appRoutes.profile,
          routes: [
            GoRoute(
              path: appRoutes.profile,
              builder: (_, _) => const ProfileScreen(),
            ),
            GoRoute(
              path: appRoutes.home,
              builder: (_, _) => const SizedBox.shrink(),
              routes: [
                GoRoute(
                  path: 'mascot',
                  builder: (_, _) => const Text(_mascotStub),
                ),
              ],
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              languageStoreOverride(),
              userOverride(_user),
              hasMascotProvider.overrideWithValue(hasMascot),
              activeMascotProvider.overrideWith(
                (_) => Stream.value(hasMascot ? _mascot : null),
              ),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              locale: locale,
              theme: theme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await tester.pump();
        await tester.pump();
      }

      testWidgets('names the mascot and pushes the Mascot screen', (
        tester,
      ) async {
        sizeViewport(tester);
        await pumpProfile(tester, hasMascot: true);

        final row = find.widgetWithText(ListTile, 'Your mascot');
        expect(row, findsOneWidget);
        expect(
          find.descendant(of: row, matching: find.text(_mascot.name)),
          findsOneWidget,
        );

        await tester.tap(row);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text(_mascotStub), findsOneWidget);
      });

      testWidgets('is hidden without a mascot', (tester) async {
        sizeViewport(tester);
        await pumpProfile(tester, hasMascot: false);

        expect(find.text('STATISTICS'), findsOneWidget);
        expect(find.text('Your mascot'), findsNothing);
      });

      group('fits at 320pt', () {
        setUpAll(loadTestFonts);

        for (final (locale, width, theme) in [
          (const Locale('ja'), 320.0, ThemeData(fontFamily: 'FlutterTest')),
          (const Locale('es'), 320 * robotoToSfWidthFactor, null),
        ]) {
          testWidgets(locale.languageCode, (tester) async {
            sizeViewport(tester, size: Size(width, 2400));
            await pumpProfile(
              tester,
              hasMascot: true,
              locale: locale,
              theme: theme,
            );

            expect(tester.takeException(), isNull);
            expect(find.byIcon(Icons.pets), findsOneWidget);
          });
        }

        testWidgets('Japanese title breaks between phrases at 1.3', (
          tester,
        ) async {
          sizeViewport(tester, size: const Size(320, 2400));
          tester.platformDispatcher.textScaleFactorTestValue = 1.3;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await pumpProfile(
            tester,
            hasMascot: true,
            locale: const Locale('ja'),
            theme: ThemeData(fontFamily: 'FlutterTest'),
          );

          final title = lookupAppLocalizations(
            const Locale('ja'),
          ).mascotLinkTitle;
          expect(renderedLines(tester, find.text(title)), jaPhrases(title));
        });
      });
    });
  });
}
