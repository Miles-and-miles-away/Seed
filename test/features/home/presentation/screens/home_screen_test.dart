import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/mail_icon_button.dart';
import 'package:seed_app/features/home/presentation/providers/home_providers.dart';
import 'package:seed_app/features/home/presentation/screens/home_screen.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_carousel.dart';
import 'package:seed_app/features/settings/settings.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

import '../../../../helpers/test_helpers.dart';

/// Stubs the router-backed visit signal so the home screen can be pumped in
/// isolation without initializing Firebase (the real provider reads the
/// router, which requires a Firebase app).
const _mascotStub = 'mascot-stub';

class _StubHomeVisitSignal extends HomeVisitSignal {
  @override
  int build() => 0;
}

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('HomeScreen', () {
    // Helper to pump widget and wait for initial frame
    // Note: We use pump() instead of pumpAndSettle() because the SDG carousel
    // and MascotAvatar contain infinite animations that never settle.
    Future<void> pumpHomeScreen(
      WidgetTester tester, {
      Locale? locale,
      TextScaler textScaler = TextScaler.noScaling,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Mock hasMascotProvider to return false (show mascot selection prompt)
            hasMascotProvider.overrideWithValue(false),
            homeVisitSignalProvider.overrideWith(_StubHomeVisitSignal.new),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            theme: appTheme(Brightness.light),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            ),
            home: const HomeScreen(),
          ),
        ),
      );
      // Allow time for the initial frame to render
      await tester.pump();
    }

    // Dispose the widget tree and flush pending timers
    // flutter_animate creates zero-duration timers that need to be processed
    Future<void> disposeAndFlush(WidgetTester tester) async {
      // Replace widget tree to trigger dispose
      await tester.pumpWidget(const SizedBox.shrink());
      // Pump to process any zero-duration timers from flutter_animate
      // The animations schedule callbacks that need time to complete
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('anchors the walkthrough intro and three shimmers', (
      tester,
    ) async {
      // Tall enough for the SDG carousel sliver to build.
      sizeViewport(tester);
      await pumpHomeScreen(tester);

      final trigger = tester.widget<WalkthroughTrigger>(
        find.byType(WalkthroughTrigger),
      );
      expect(trigger.item, WalkthroughItem.intro);
      final shimmers = tester
          .widgetList<WalkthroughShimmer>(find.byType(WalkthroughShimmer))
          .map((s) => s.item)
          .toSet();
      expect(shimmers, {
        WalkthroughItem.ecoFact,
        WalkthroughItem.dailyChallenge,
        WalkthroughItem.sdg,
      });
      expect(
        find.ancestor(
          of: find.byType(SettingsIconButton),
          matching: find.byType(WalkthroughShimmer),
        ),
        findsNothing,
      );

      await disposeAndFlush(tester);
    });

    testWidgets('renders app title and logo', (tester) async {
      await pumpHomeScreen(tester);

      // Verify app bar elements - 'Seed' is the app title from l10n
      expect(find.text('Seed'), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsAtLeast(1));

      await disposeAndFlush(tester);
    });

    testWidgets('displays mascot selection prompt when no mascot', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      // Verify mascot selection prompt is shown (uses localized strings)
      // The button has a pets icon
      expect(find.byIcon(Icons.pets), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('the mascot opens as a labelled button', (tester) async {
      final semantics = tester.ensureSemantics();
      final router = GoRouter(
        initialLocation: appRoutes.home,
        routes: [
          GoRoute(
            path: appRoutes.home,
            builder: (_, _) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'mascot',
                builder: (_, _) => const Scaffold(body: Text(_mascotStub)),
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
            homeVisitSignalProvider.overrideWith(_StubHomeVisitSignal.new),
            hasMascotProvider.overrideWithValue(true),
            activeMascotProvider.overrideWith(
              (_) => Stream.value(
                const MascotModel(id: 'm', speciesId: 'seed', name: 'Pip'),
              ),
            ),
            userOverride(const AppUserModel(uid: 'u', email: 'e')),
            // An SVG keeps MascotDisplay off Rive.
            activeMascotAssetPathProvider.overrideWith(
              (_) => 'assets/images/mascot/seed_stage1.svg',
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: appTheme(Brightness.light),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      final button = find.bySemanticsLabel('Your mascot');
      expect(button, findsOneWidget);
      expect(tester.getSemantics(button).flagsCollection.isButton, isTrue);

      await tester.tap(find.byType(MascotDisplay));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text(_mascotStub), findsOneWidget);

      semantics.dispose();
      await disposeAndFlush(tester);
    });

    testWidgets('displays SDG section header', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SDG section
      expect(find.text('Discover the SDGs'), findsOneWidget);
      expect(
        find.text('Tap to learn about the UN Sustainable Development Goals'),
        findsOneWidget,
      );

      await disposeAndFlush(tester);
    });

    testWidgets('displays my goal prompt card when no goal set', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      expect(find.text('My Goal'), findsOneWidget);
      expect(find.text('Tap to set your sustainability goal'), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('displays SDG carousel', (tester) async {
      // Tall viewport: the carousel sits below the fold of a phone frame.
      sizeViewport(tester);
      await pumpHomeScreen(tester);

      // The SDG carousel should be present (contains SDG items)
      // Looking for SDG goal indicators - there should be 17 goals
      // At least some should be visible in the carousel
      expect(find.byType(SdgCarousel), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('mascot selection has proper styling', (tester) async {
      await pumpHomeScreen(tester);

      // Find the mascot selection container (has gradient decoration)
      final mascotContainer = find.ancestor(
        of: find.byIcon(Icons.pets),
        matching: find.byType(Container),
      );
      expect(mascotContainer, findsAtLeast(1));

      await disposeAndFlush(tester);
    });

    testWidgets('app bar is floating', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SliverAppBar exists
      expect(find.byType(SliverAppBar), findsOneWidget);

      // Verify it's configured as floating
      final sliverAppBar = tester.widget<SliverAppBar>(
        find.byType(SliverAppBar),
      );
      expect(sliverAppBar.floating, isTrue);

      await disposeAndFlush(tester);
    });

    testWidgets('scrolls content properly', (tester) async {
      await pumpHomeScreen(tester);

      // Verify CustomScrollView is present and can scroll
      expect(find.byType(CustomScrollView), findsOneWidget);

      // Perform a scroll gesture
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      // Use pump instead of pumpAndSettle to avoid infinite animation timeout
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Content should still be visible after scrolling
      expect(find.text('Discover the SDGs'), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('uses SafeArea for proper padding', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SafeArea is used (may be multiple in widget tree)
      expect(find.byType(SafeArea), findsAtLeast(1));

      await disposeAndFlush(tester);
    });

    testWidgets('app bar title is centered', (tester) async {
      await pumpHomeScreen(tester);

      final sliverAppBar = tester.widget<SliverAppBar>(
        find.byType(SliverAppBar),
      );
      expect(sliverAppBar.centerTitle, isTrue);

      await disposeAndFlush(tester);
    });

    testWidgets('app bar shows the settings gear after the mail icon', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      final actions = tester
          .widget<SliverAppBar>(find.byType(SliverAppBar))
          .actions!;
      expect(actions.map((a) => a.runtimeType), [
        MailIconButton,
        SettingsIconButton,
      ]);
      expect(find.byTooltip('Settings'), findsOneWidget);
      expect(
        tester.getCenter(find.byType(SettingsIconButton)).dx,
        greaterThan(tester.getCenter(find.byType(MailIconButton)).dx),
      );

      await disposeAndFlush(tester);
    });

    testWidgets('app bar actions meet the tap target guidelines', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpHomeScreen(tester);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // The guideline skips controls on the screen edge, so measure the gear.
      expect(
        tester.getSize(find.byType(SettingsIconButton)),
        const Size.square(kMinInteractiveDimension),
      );

      semantics.dispose();
      await disposeAndFlush(tester);
    });

    group('app bar title with two actions', () {
      setUpAll(loadTestFonts);

      const locales = [Locale('ja'), Locale('es')];
      const textScales = [1.0, 2.0];

      for (final width in testPhoneWidths) {
        for (final locale in locales) {
          for (final scale in textScales) {
            testWidgets('stays whole and centred at ${width}pt, '
                '${locale.languageCode}, text scale $scale', (tester) async {
              sizeViewport(tester, size: Size(width, 800));
              await pumpHomeScreen(
                tester,
                locale: locale,
                textScaler: TextScaler.linear(scale),
              );

              expect(tester.takeException(), isNull);
              final appBar = find.byType(SliverAppBar);
              final titleText = find.descendant(
                of: appBar,
                matching: find.text('Seed'),
              );
              final title = tester.renderObject<RenderParagraph>(titleText);
              expect(title.didExceedMaxLines, isFalse);
              expect(
                title.size.width,
                greaterThanOrEqualTo(
                  title.getMaxIntrinsicWidth(double.infinity) - 0.01,
                ),
              );
              final left = tester
                  .getRect(
                    find.descendant(
                      of: appBar,
                      matching: find.byIcon(Icons.eco),
                    ),
                  )
                  .left;
              final right = tester.getRect(titleText).right;
              expect((left + right) / 2, closeTo(width / 2, 0.5));

              await disposeAndFlush(tester);
            });
          }
        }
      }
    });
  });
}
