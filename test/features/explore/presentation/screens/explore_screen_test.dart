import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/app_bottom_nav.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/explore/explore.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/fact_games/fact_games.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../fact_games/fact_games_fixtures.dart';
import '../../../walkthrough/walkthrough_test_support.dart';

const _titles = [
  'Transport',
  'Food',
  'Home energy',
  'Where your energy goes',
  'Higher or lower?',
  'Fact pairs',
  'Fact recall',
];

const _factGames = {
  'Fact pairs': 'Match each eco-fact to its number',
  'Fact recall': 'Fill in the number in each eco-fact',
};

/// The fact games' pool, unlocked unless given.
Override _pool([List<EcoFact>? pool]) => factGamesPoolProvider.overrideWith(
  (_, locale) async => ecoGameFacts(pool ?? playableFacts(3), locale),
);

void main() {
  // Roboto for every case, so a run of one group lays out like the file.
  setUpAll(loadTestFonts);

  Widget buildScreen({
    Locale locale = const Locale('en'),
    ThemeData? theme,
    TextScaler textScaler = TextScaler.noScaling,
    List<EcoFact>? pool,
  }) => createTestWidget(
    locale: locale,
    theme: theme,
    overrides: [_pool(pool)],
    child: MediaQuery(
      data: MediaQueryData(textScaler: textScaler),
      child: const ExploreScreen(),
    ),
  );

  /// Whether each break in [lines] falls between two of [phrases].
  bool breaksBetweenPhrases(List<String> lines, List<String> phrases) {
    String bare(String text) => text.replaceAll(' ', '');
    final boundaries = {0};
    var offset = 0;
    for (final phrase in phrases) {
      boundaries.add(offset += bare(phrase).length);
    }
    offset = 0;
    return lines.every(
      (line) => boundaries.contains(offset += bare(line).length),
    );
  }

  group('ExploreScreen', () {
    testWidgets('lists seven tiles in two sections, in order', (tester) async {
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(ExploreTile), findsNWidgets(_titles.length));
      final order = [
        'Calculators',
        ..._titles.take(3),
        'Learn and play',
        ..._titles.skip(3),
      ];
      final tops = [for (final t in order) tester.getTopLeft(find.text(t)).dy];
      expect(tops, [...tops]..sort());
      expect(find.text('Two routes, any mix of modes'), findsOneWidget);
      expect(find.text('Which produces more carbon?'), findsOneWidget);
      for (final subtitle in _factGames.values) {
        expect(find.text(subtitle), findsOneWidget);
      }
    });

    testWidgets('both fact games lock with progress and a lock', (
      tester,
    ) async {
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen(pool: playableFacts(2)));
      await tester.pumpAndSettle();

      for (final title in _factGames.keys) {
        final tile = find.widgetWithText(ExploreTile, title);
        expect(
          find.descendant(
            of: tile,
            matching: find.text('2 of 3 eco-facts with a number'),
          ),
          findsOneWidget,
          reason: title,
        );
        expect(
          find.descendant(of: tile, matching: find.byIcon(Icons.lock_outline)),
          findsOneWidget,
          reason: title,
        );
        expect(
          find.descendant(of: tile, matching: find.byIcon(Icons.chevron_right)),
          findsNothing,
          reason: title,
        );
      }
    });

    testWidgets('both fact games unlock together when the user doc changes', (
      tester,
    ) async {
      sizeViewport(tester);
      final users = StreamController<AppUserModel?>();
      addTearDown(users.close);
      AppUserModel user(int days) => AppUserModel(
        uid: 'u',
        email: 'e',
        unlockedFactDates: [
          for (var day = 1; day <= days; day++) '2026-01-0$day',
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            currentUserProvider.overrideWith((_) => users.stream),
            ecoFactsProvider.overrideWith((_) async => playableFacts(5)),
          ],
          child: const ExploreScreen(),
        ),
      );
      users.add(user(2));
      await tester.pumpAndSettle();
      expect(find.text('2 of 3 eco-facts with a number'), findsNWidgets(2));

      users.add(user(3));
      await tester.pumpAndSettle();
      for (final MapEntry(key: title, value: subtitle) in _factGames.entries) {
        final tile = find.widgetWithText(ExploreTile, title);
        expect(
          find.descendant(of: tile, matching: find.text(subtitle)),
          findsOneWidget,
          reason: title,
        );
        expect(
          find.descendant(of: tile, matching: find.byIcon(Icons.lock_outline)),
          findsNothing,
          reason: title,
        );
      }
    });

    testWidgets('unlocked fact games show their subtitles and chevrons', (
      tester,
    ) async {
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      for (final MapEntry(key: title, value: subtitle) in _factGames.entries) {
        final tile = find.widgetWithText(ExploreTile, title);
        expect(
          find.descendant(of: tile, matching: find.text(subtitle)),
          findsOneWidget,
          reason: title,
        );
        expect(
          find.descendant(of: tile, matching: find.byIcon(Icons.chevron_right)),
          findsOneWidget,
          reason: title,
        );
        expect(
          find.descendant(of: tile, matching: find.byIcon(Icons.lock_outline)),
          findsNothing,
          reason: title,
        );
      }
    });

    testWidgets('each tile wears its own category colour', (tester) async {
      // All three used to be the same primaryContainer blue, which said
      // nothing about which domain each one leads to.
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      Color avatarColour(String label) => tester
          .widget<CircleAvatar>(
            find.descendant(
              of: find.widgetWithText(ExploreTile, label),
              matching: find.byType(CircleAvatar),
            ),
          )
          .backgroundColor!;

      for (final (label, category) in const [
        ('Transport', ActionCategory.transport),
        ('Food', ActionCategory.food),
        ('Home energy', ActionCategory.energy),
      ]) {
        expect(
          avatarColour(label),
          category.color.withValues(alpha: opacityLight),
          reason: '$label tile should carry its category colour',
        );
      }
      // ...and three distinct colours, not one repeated.
      expect({
        for (final l in const ['Transport', 'Food', 'Home energy'])
          avatarColour(l),
      }, hasLength(3));
    });

    for (final brightness in Brightness.values) {
      testWidgets('icons take the readable tone, ${brightness.name}', (
        tester,
      ) async {
        sizeViewport(tester);
        final theme = appTheme(brightness);
        await tester.pumpWidget(buildScreen(theme: theme));
        await tester.pumpAndSettle();

        final expected = {
          'Transport': AppColors.categoryTransport,
          'Food': AppColors.categoryFood,
          'Home energy': AppColors.categoryEnergy,
          'Where your energy goes': AppColors.categoryEnergy,
          'Higher or lower?': theme.colorScheme.primary,
          'Fact pairs': AppColors.categoryLearning,
          'Fact recall': AppColors.categoryConsumption,
        };
        for (final MapEntry(key: title, value: colour) in expected.entries) {
          final icon = tester.widget<Icon>(
            find.descendant(
              of: find.descendant(
                of: find.widgetWithText(ExploreTile, title),
                matching: find.byType(CircleAvatar),
              ),
              matching: find.byType(Icon),
            ),
          );
          expect(
            icon.color,
            readableTextColor(colour, brightness),
            reason: title,
          );
        }
      });
    }

    testWidgets('each tile pushes its route', (tester) async {
      sizeViewport(tester);
      final routes = {
        'Transport': appRoutes.transportCalculator,
        'Food': appRoutes.foodCalculator,
        'Home energy': appRoutes.energyCalculator,
        'Where your energy goes': appRoutes.energyExplore,
        'Higher or lower?': appRoutes.quiz,
        'Fact pairs': appRoutes.factPairs,
        'Fact recall': appRoutes.factRecall,
      };
      final router = GoRouter(
        initialLocation: appRoutes.explore,
        routes: [
          GoRoute(
            path: appRoutes.explore,
            builder: (_, _) => const ExploreScreen(),
          ),
          for (final path in routes.values)
            GoRoute(
              path: path,
              builder: (_, _) => Scaffold(body: Text('stub $path')),
            ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [languageStoreOverride(), _pool()],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final MapEntry(key: title, value: path) in routes.entries) {
        await tester.tap(find.text(title));
        await tester.pumpAndSettle();
        expect(find.text('stub $path'), findsOneWidget, reason: title);
        router.pop();
        await tester.pumpAndSettle();
        expect(find.byType(ExploreScreen), findsOneWidget);
      }
    });

    testWidgets('tiles meet the tap target guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });

    testWidgets('the quiz border follows the tile corners, reduced motion', (
      tester,
    ) async {
      sizeViewport(tester);
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            ...walkthroughOverrides(
              settings: Stream.value(
                settingsWith(
                  WalkthroughItem.values.where(
                    (i) => i != WalkthroughItem.quiz,
                  ),
                ),
              ),
            ),
            _pool(),
          ],
          child: const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: ExploreScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final border = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(WalkthroughShimmer),
          matching: find.byWidgetPredicate(
            (w) =>
                w is DecoratedBox &&
                w.position == DecorationPosition.foreground,
          ),
        ),
      );
      expect((border.decoration as BoxDecoration).borderRadius, borderRadiusLg);
    });

    group('fits', () {
      final japanese = ThemeData(fontFamily: 'FlutterTest');

      for (final width in testPhoneWidths) {
        for (final scale in [1.0, 2.0]) {
          testWidgets('Japanese at ${width}pt, text scale $scale', (
            tester,
          ) async {
            sizeViewport(tester, size: Size(width, 800));
            await tester.pumpWidget(
              buildScreen(
                locale: const Locale('ja'),
                theme: japanese,
                textScaler: TextScaler.linear(scale),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          });

          testWidgets('Spanish at ${width}pt, text scale $scale', (
            tester,
          ) async {
            sizeViewport(
              tester,
              size: Size(width * robotoToSfWidthFactor, 800),
            );
            await tester.pumpWidget(
              buildScreen(
                locale: const Locale('es'),
                textScaler: TextScaler.linear(scale),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          });
        }
      }

      for (final scale in [1.3, 2.0]) {
        testWidgets('Japanese titles wrap between phrases at 320pt, $scale', (
          tester,
        ) async {
          sizeViewport(tester, size: const Size(320, 2400));
          await tester.pumpWidget(
            buildScreen(
              locale: const Locale('ja'),
              theme: japanese,
              textScaler: TextScaler.linear(scale),
            ),
          );
          await tester.pumpAndSettle();

          final l10n = lookupAppLocalizations(const Locale('ja'));
          for (final entry in [
            ...calculatorEntries,
            energyRankedEntry,
            quizEntry,
            factPairsEntry,
            factRecallEntry,
          ]) {
            final title = entry.title(l10n);
            final lines = renderedLines(
              tester,
              find.descendant(
                of: find.byType(ExploreTile),
                matching: find.text(title),
              ),
            );
            for (final line in lines.skip(1)) {
              expect(
                jaNoLineStart,
                isNot(contains(line.characters.first)),
                reason: '$lines',
              );
            }
            // At 2.0 a line holds four glyphs, shorter than エネルギー.
            if (scale < 2) {
              expect(
                breaksBetweenPhrases(lines, jaPhrases(title)),
                isTrue,
                reason: '$lines',
              );
            }
          }
        });
      }
    });
  });

  group('calculators walkthrough', () {
    const statusBar = 24.0;

    Widget buildPending(
      Iterable<WalkthroughItem> found, {
      TextScaler textScaler = TextScaler.noScaling,
    }) => createTestWidget(
      locale: const Locale('en'),
      overrides: [
        ...walkthroughOverrides(settings: Stream.value(settingsWith(found))),
        _pool(),
      ],
      child: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: const ExploreScreen(),
      ),
    );

    /// Explore under a status bar and above the nav, scaled app-wide.
    Future<void> pumpInShell(WidgetTester tester, Size size, double scale) {
      sizeViewport(tester, size: size);
      tester.view.padding = const FakeViewPadding(top: statusBar);
      tester.view.viewPadding = const FakeViewPadding(top: statusBar);
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(() {
        tester.view.resetPadding();
        tester.view.resetViewPadding();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });
      return tester.pumpWidget(
        createTestWidget(
          locale: const Locale('en'),
          overrides: [
            ...walkthroughOverrides(
              settings: Stream.value(settingsWith([WalkthroughItem.intro])),
            ),
            _pool(),
          ],
          child: Scaffold(
            body: const ExploreScreen(),
            bottomNavigationBar: AppBottomNav(
              currentIndex: 2,
              onTabSelected: (_) {},
              onActionPressed: () {},
            ),
          ),
        ),
      );
    }

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 3; i++) {
        await tester.pump(durationSlow);
      }
    }

    Future<void> openOverlay(WidgetTester tester) async {
      await pumpUntilFound(tester, find.byType(WalkthroughOverlay));
      // The first page's callback, then the bubble's and button's entrance,
      // whose controllers start a frame late.
      await settle(tester);
    }

    // No scrolling first: the button must be reachable where it lands.
    Future<void> next(WidgetTester tester, String label) async {
      await tester.tap(
        find.widgetWithText(CelebrationButton, label).hitTestable(),
      );
      await settle(tester);
    }

    Rect? clearRect(WidgetTester tester) => tester
        .widget<CelebrationOverlay>(find.byType(CelebrationOverlay))
        .clearRect;

    Rect bubbleText(WidgetTester tester) => tester.getRect(
      find.descendant(
        of: find.byType(WalkthroughOverlay),
        matching: find.byType(SingleChildScrollView),
      ),
    );

    Rect bubble(WidgetTester tester) => bubbleText(
      tester,
    ).expandToInclude(tester.getRect(find.byType(CelebrationButton)));

    /// Wholly on screen, tappable, and in the text's band beside the tile.
    void expectButtonReachable(WidgetTester tester, {double top = 0}) {
      final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
      final button = tester.getRect(find.byType(CelebrationButton));
      expect(button.top, greaterThanOrEqualTo(top));
      expect(button.bottom, lessThanOrEqualTo(screen.height));
      expect(button.left, greaterThanOrEqualTo(0));
      expect(button.right, lessThanOrEqualTo(screen.width));
      expect(find.byType(CelebrationButton).hitTestable(), findsOneWidget);
      final clear = clearRect(tester);
      if (clear == null) return;
      expect(button.overlaps(clear), isFalse);
      expect(bubbleText(tester).overlaps(clear), isFalse);
      expect(bubbleText(tester).top < clear.top, button.top < clear.top);
    }

    List<double> tileOpacities(WidgetTester tester) => [
      for (final tile in tester.widgetList<AnimatedOpacity>(
        find.descendant(
          of: find.byType(ExploreTile),
          matching: find.byType(AnimatedOpacity),
        ),
      ))
        tile.opacity,
    ];

    testWidgets('lights each explained tile in turn', (tester) async {
      sizeViewport(tester);
      await tester.pumpWidget(buildPending([WalkthroughItem.intro]));
      await openOverlay(tester);

      final card = find.descendant(
        of: find.byType(WalkthroughOverlay),
        matching: find.byType(Card),
      );
      for (var page = 0; page < 4; page++) {
        if (page > 0) await next(tester, 'Next');
        final tile = tester.getRect(find.byType(ExploreTile).at(page));
        expect(clearRect(tester), tile, reason: 'page $page');
        expect(tester.getRect(card).overlaps(tile), isFalse);
        expectButtonReachable(tester);
        expect(tileOpacities(tester), [
          for (var i = 0; i < _titles.length; i++)
            if (i == page) 1 else opacityMuted,
        ], reason: 'page $page');
      }

      await next(tester, 'Got it');
      await tester.pump();
      expect(find.byType(WalkthroughOverlay), findsNothing);
      expect(tileOpacities(tester), List.filled(_titles.length, 1));
      await flushOverlayTimers(tester);
    });

    testWidgets('the bubble takes the taller band beside the tile', (
      tester,
    ) async {
      sizeViewport(tester, size: const Size(393, 852));
      await tester.pumpWidget(buildPending([WalkthroughItem.intro]));
      await openOverlay(tester);

      // The transport tile sits high, so the bubble goes below it...
      expect(
        bubble(tester).top,
        greaterThanOrEqualTo(clearRect(tester)!.bottom),
      );
      expectButtonReachable(tester);
      for (var page = 1; page < 4; page++) {
        await next(tester, 'Next');
        expect(clearRect(tester), isNotNull, reason: 'page $page');
        expectButtonReachable(tester);
      }
      // ...and the ranking tile sits low, so the bubble goes above it.
      final ranked = clearRect(tester)!;
      expect(ranked.center.dy, greaterThan(852 / 2));
      expect(bubble(tester).bottom, lessThanOrEqualTo(ranked.top));
      await flushOverlayTimers(tester);
    });

    for (final (size, scale) in [
      (const Size(360, 640), 1.0),
      (const Size(320, 480), 2.0),
    ]) {
      testWidgets('the button stays reachable in the shell at '
          '${size.width.toInt()}x${size.height.toInt()}, text scale $scale', (
        tester,
      ) async {
        await pumpInShell(tester, size, scale);
        await openOverlay(tester);

        for (var page = 0; page < 4; page++) {
          expectButtonReachable(tester, top: statusBar);
          await next(tester, page < 3 ? 'Next' : 'Got it');
        }
        await tester.pump();
        expect(find.byType(WalkthroughOverlay), findsNothing);
        await flushOverlayTimers(tester);
      });
    }

    testWidgets('a band too short for the bubble gets the full scrim', (
      tester,
    ) async {
      await pumpInShell(tester, const Size(320, 480), 2);
      await openOverlay(tester);

      final transport = tester.getRect(find.byType(ExploreTile).first);
      final nav = tester.getRect(find.byType(AppBottomNav));
      expect(transport.bottom, lessThan(nav.top), reason: 'transport fits');
      expect(clearRect(tester), isNull);
      expect(bubble(tester).center.dy, closeTo((statusBar + 480) / 2, 1));
      await flushOverlayTimers(tester);
    });

    testWidgets('a tile cut off by the viewport gets the full scrim', (
      tester,
    ) async {
      sizeViewport(tester, size: const Size(360, 500));
      await tester.pumpWidget(buildPending([WalkthroughItem.intro]));
      await openOverlay(tester);

      for (var page = 1; page < 4; page++) {
        await next(tester, 'Next');
      }
      final ranked = tester.getRect(find.byType(ExploreTile).at(3));
      expect(ranked.top, lessThan(500));
      expect(ranked.bottom, greaterThan(500));
      expect(clearRect(tester), isNull);
      expect(bubble(tester).center.dy, closeTo(500 / 2, 1));
      await flushOverlayTimers(tester);
    });

    testWidgets('the completion page has no spotlight', (tester) async {
      sizeViewport(tester);
      await tester.pumpWidget(
        buildPending(
          WalkthroughItem.values.where((i) => i != WalkthroughItem.calculators),
        ),
      );
      await openOverlay(tester);

      for (var page = 1; page < 5; page++) {
        await next(tester, 'Next');
      }
      expect(find.text('Got it'), findsOneWidget);
      expect(clearRect(tester), isNull);
      await flushOverlayTimers(tester);
    });
  });
}
