import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/fact_games/domain/fact_pairs_board.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/fact_games/fact_games.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/fact_card_tile.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

import '../../../../helpers/test_helpers.dart';
import '../../fact_games_fixtures.dart';

class _RecordingAnalytics extends Fake implements AnalyticsService {
  final events = <String>[];

  @override
  Future<void> logFactPairsOpened() async => events.add('opened');

  @override
  Future<void> logFactPairsFinished({
    required int pairs,
    required int moves,
  }) async => events.add('finished:$pairs:$moves');
}

const _seed = 7;

Finder _cardAt(int index) => find.byType(FactCardTile).at(index);

FactCardState _stateOf(WidgetTester tester, int index) =>
    tester.widget<FactCardTile>(_cardAt(index)).state;

List<String> _cardTexts(WidgetTester tester) => [
  for (final tile in tester.widgetList<FactCardTile>(find.byType(FactCardTile)))
    tile.card.text,
];

/// Both card indices of each pair on [board], in deal order.
List<(int, int)> _pairs(FactPairsBoard board) {
  final byDay = <String, List<int>>{};
  for (final (i, card) in board.cards.indexed) {
    byDay.putIfAbsent(card.factId, () => []).add(i);
  }
  return [for (final pair in byDay.values) (pair.first, pair.last)];
}

/// Two face-down cards that do not pair.
(int, int) _miss(FactPairsBoard board) {
  final other = board.cards.indexed
      .firstWhere((e) => e.$2.factId != board.cards.first.factId)
      .$1;
  return (0, other);
}

Future<void> _tapCard(WidgetTester tester, int index) async {
  await tester.ensureVisible(_cardAt(index));
  await tester.pumpAndSettle();
  await tester.tap(_cardAt(index));
  await tester.pumpAndSettle();
}

Future<void> _closeSheet(WidgetTester tester) async {
  await tester.tapAt(const Offset(4, 4));
  await tester.pumpAndSettle();
}

Future<void> _matchAll(WidgetTester tester, FactPairsBoard board) async {
  for (final (a, b) in _pairs(board)) {
    await _tapCard(tester, a);
    await _tapCard(tester, b);
    await _closeSheet(tester);
  }
}

/// The playable facts with the longest titles and the longest figures in
/// [locale], each figure once.
List<EcoFact> _longestPool(List<EcoFact> facts, String locale) {
  final byTitle = [...facts]
    ..sort((a, b) => b.name(locale).length - a.name(locale).length);
  final byFigure = [...facts]
    ..sort((a, b) => b.keyFigure(locale)!.length - a.keyFigure(locale)!.length);
  final pool = <EcoFact>[];
  final figures = <String>{};
  void take(List<EcoFact> from) {
    var taken = 0;
    for (final fact in from) {
      if (taken == factPairsMaxPairs ~/ 2) return;
      if (!pool.contains(fact) && figures.add(fact.keyFigureEn)) {
        pool.add(fact);
        taken++;
      }
    }
  }

  take(byTitle);
  take(byFigure);
  return pool;
}

void main() {
  late List<EcoFact> realPlayable;

  setUpAll(() async {
    await loadTestFonts();
    final json =
        jsonDecode(File('data/app/eco_facts.json').readAsStringSync())
            as List<dynamic>;
    realPlayable = [
      for (final e in json)
        if (EcoFact.fromJson(e as Map<String, dynamic>) case final fact
            when fact.isPlayable)
          fact,
    ];
  });

  Widget buildScreen({
    List<EcoFact>? pool,
    Locale locale = const Locale('en'),
    ThemeData? theme,
    _RecordingAnalytics? analytics,
  }) => createTestWidget(
    locale: locale,
    theme: theme,
    overrides: [
      factGamesPoolProvider.overrideWith(
        (_, locale) async => ecoGameFacts(pool ?? playableFacts(6), locale),
      ),
      analyticsServiceProvider.overrideWithValue(
        analytics ?? _RecordingAnalytics(),
      ),
    ],
    child: FactPairsScreen(random: Random(_seed)),
  );

  FactPairsBoard firstDeal(List<EcoFact> pool, [String locale = 'en']) =>
      FactPairsBoard.deal(ecoGameFacts(pool, locale), Random(_seed));

  group('locked', () {
    for (final count in [0, 1, 2]) {
      testWidgets('with $count ready facts', (tester) async {
        sizeViewport(tester);
        await tester.pumpWidget(buildScreen(pool: playableFacts(count)));
        await tester.pumpAndSettle();

        expect(find.byType(FactGamesLockedView), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.text('Unlock eco-facts to play'), findsOneWidget);
        expect(
          find.text(
            'Complete daily challenges to unlock eco-facts. Most have a '
            'key number; the games start when 3 of those are ready.',
          ),
          findsOneWidget,
        );
        expect(
          find.text('$count of 3 eco-facts with a number'),
          findsOneWidget,
        );
        expect(find.byType(FactCardTile), findsNothing);
      });
    }

    testWidgets('counts facts with distinct figures', (tester) async {
      sizeViewport(tester);
      await tester.pumpWidget(
        buildScreen(
          pool: [
            for (var day = 1; day <= 4; day++) playableFact(day, figure: '1%'),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('1 of 3 eco-facts with a number'), findsOneWidget);
    });

    testWidgets("the button goes to Home, where today's challenge is", (
      tester,
    ) async {
      sizeViewport(tester);
      final router = GoRouter(
        initialLocation: appRoutes.factPairs,
        routes: [
          GoRoute(
            path: appRoutes.home,
            builder: (_, _) => const Scaffold(body: Text('home stub')),
          ),
          GoRoute(
            path: appRoutes.factPairs,
            builder: (_, _) => const FactPairsScreen(),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            languageStoreOverride(),
            factGamesPoolProvider.overrideWith(
              (_, locale) async => ecoGameFacts(playableFacts(1), locale),
            ),
            analyticsServiceProvider.overrideWithValue(_RecordingAnalytics()),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text("Today's challenge"));
      await tester.pumpAndSettle();
      expect(find.text('home stub'), findsOneWidget);
    });
  });

  group('a game', () {
    testWidgets('a match opens the fact on screen at 360x640', (tester) async {
      sizeViewport(tester, size: const Size(360, 640));
      final pool = playableFacts(6);
      final board = firstDeal(pool);
      await tester.pumpWidget(buildScreen(pool: pool));
      await tester.pumpAndSettle();

      final (a, b) = _pairs(board).first;
      await _tapCard(tester, a);
      await _tapCard(tester, b);

      final fact = board.cards[a].fact;
      for (final text in [fact.title, fact.text]) {
        final finder = find.descendant(
          of: find.byType(InfoSheet),
          matching: find.text(text),
        );
        expect(finder.hitTestable(), findsOneWidget, reason: text);
        final rect = tester.getRect(finder);
        expect(rect.top, greaterThanOrEqualTo(0));
        expect(rect.bottom, lessThanOrEqualTo(640));
      }
      await _closeSheet(tester);
      expect(_stateOf(tester, a), FactCardState.matched);
      expect(_stateOf(tester, b), FactCardState.matched);
      expect(find.text('Pairs: 1 of 6'), findsOneWidget);
      expect(find.text('Moves: 1'), findsOneWidget);
    });

    testWidgets('a miss turns back after 1200ms', (tester) async {
      sizeViewport(tester);
      final pool = playableFacts(6);
      final board = firstDeal(pool);
      await tester.pumpWidget(buildScreen(pool: pool));
      await tester.pumpAndSettle();

      final (a, b) = _miss(board);
      await tester.tap(_cardAt(a));
      await tester.pump();
      await tester.tap(_cardAt(b));
      await tester.pump();
      expect(_stateOf(tester, a), FactCardState.faceUp);
      expect(_stateOf(tester, b), FactCardState.faceUp);
      expect(find.byType(InfoSheet), findsNothing);

      // Taps during the hold are ignored.
      final third = List.generate(
        12,
        (i) => i,
      ).firstWhere((i) => i != a && i != b);
      await tester.tap(_cardAt(third));
      await tester.pump(durationCelebration - const Duration(milliseconds: 1));
      expect(_stateOf(tester, a), FactCardState.faceUp);
      expect(_stateOf(tester, third), FactCardState.faceDown);

      await tester.pump(const Duration(milliseconds: 1));
      expect(_stateOf(tester, a), FactCardState.faceDown);
      expect(_stateOf(tester, b), FactCardState.faceDown);
      expect(find.text('Moves: 1'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('a finished board shows the moves and deals again', (
      tester,
    ) async {
      sizeViewport(tester);
      final analytics = _RecordingAnalytics();
      final pool = playableFacts(8);
      final random = Random(_seed);
      final board = FactPairsBoard.deal(ecoGameFacts(pool, 'en'), random);
      final next = FactPairsBoard.deal(ecoGameFacts(pool, 'en'), random);
      await tester.pumpWidget(buildScreen(pool: pool, analytics: analytics));
      await tester.pumpAndSettle();
      expect(analytics.events, ['opened']);

      final (missA, missB) = _miss(board);
      await _tapCard(tester, missA);
      await _tapCard(tester, missB);
      await tester.pump(durationCelebration);
      await tester.pumpAndSettle();
      await _matchAll(tester, board);

      expect(find.text('Pairs: 6 of 6'), findsOneWidget);
      expect(find.text('All pairs found in 7 moves'), findsOneWidget);
      expect(analytics.events, ['opened', 'finished:6:7']);

      await tester.tap(find.text('Play again'));
      await tester.pumpAndSettle();
      expect(find.text('Pairs: 0 of 6'), findsOneWidget);
      expect(find.text('Moves: 0'), findsOneWidget);
      expect(find.text('Play again'), findsNothing);
      expect(_cardTexts(tester), [for (final c in next.cards) c.text]);
      expect(analytics.events, ['opened', 'finished:6:7']);
    });

    testWidgets('a finished board brings its panel into view and says so', (
      tester,
    ) async {
      sizeViewport(tester, size: const Size(360, 640));
      final pool = playableFacts(6);
      final board = firstDeal(pool);
      await tester.pumpWidget(buildScreen(pool: pool));
      await tester.pumpAndSettle();
      tester.takeAnnouncements();

      final pairs = _pairs(board);
      for (final (a, b) in pairs.take(pairs.length - 1)) {
        await _tapCard(tester, a);
        await _tapCard(tester, b);
        await _closeSheet(tester);
      }
      final (a, b) = pairs.last;
      await _tapCard(tester, a);
      await _tapCard(tester, b);
      expect(
        tester.takeAnnouncements().last.message,
        '${board.cards[b].text}\nPair found\nAll pairs found in 6 moves',
      );
      await _closeSheet(tester);

      final button = find.widgetWithText(FilledButton, 'Play again');
      expect(button.hitTestable(), findsOneWidget);
      expect(tester.getRect(button).bottom, lessThanOrEqualTo(640));
      expect(
        tester.getRect(find.text('All pairs found in 6 moves')).top,
        greaterThanOrEqualTo(0),
      );

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(tester.takeAnnouncements().last.message, 'Pairs: 0 of 6');
    });

    testWidgets('a small pool deals three pairs in two rows', (tester) async {
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen(pool: playableFacts(4)));
      await tester.pumpAndSettle();
      expect(find.byType(FactCardTile), findsNWidgets(6));
      expect(find.text('Pairs: 0 of 3'), findsOneWidget);
    });
  });

  group('accessibility', () {
    testWidgets('labels cards face down, face up and matched', (tester) async {
      final semantics = tester.ensureSemantics();
      sizeViewport(tester);
      final pool = playableFacts(6);
      final board = firstDeal(pool);
      await tester.pumpWidget(buildScreen(pool: pool));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(_cardAt(0)),
        matchesSemantics(
          label: 'Card 1 of 12, face down',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      final (a, b) = _pairs(board).first;
      await _tapCard(tester, a);
      expect(tester.getSemantics(_cardAt(a)).label, board.cards[a].text);
      await _tapCard(tester, b);
      await _closeSheet(tester);
      expect(
        tester.getSemantics(_cardAt(a)),
        matchesSemantics(
          label: '${board.cards[a].text}, matched',
          isButton: true,
          hasEnabledState: true,
        ),
      );
      semantics.dispose();
    });

    testWidgets('Japanese face-down labels count cards, not a fraction', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen(locale: const Locale('ja')));
      await tester.pumpAndSettle();
      expect(tester.getSemantics(_cardAt(0)).label, '12枚中1枚目、裏向き');
      semantics.dispose();
    });

    testWidgets('announces each flip, then the match or the miss', (
      tester,
    ) async {
      sizeViewport(tester);
      final pool = playableFacts(6);
      final board = firstDeal(pool);
      await tester.pumpWidget(buildScreen(pool: pool));
      await tester.pumpAndSettle();
      tester.takeAnnouncements();

      List<String> said() => [
        for (final a in tester.takeAnnouncements()) a.message,
      ];

      final (missA, missB) = _miss(board);
      await _tapCard(tester, missA);
      expect(said(), [board.cards[missA].text]);
      await _tapCard(tester, missB);
      expect(said(), ['${board.cards[missB].text}\nNot a pair']);
      await tester.pump(durationCelebration);
      await tester.pumpAndSettle();

      final (a, b) = _pairs(board).first;
      await _tapCard(tester, a);
      expect(said(), [board.cards[a].text]);
      await _tapCard(tester, b);
      expect(said(), ['${board.cards[b].text}\nPair found']);
      await _closeSheet(tester);
    });

    testWidgets('cards meet the tap target guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      sizeViewport(tester, size: const Size(320, 568));
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });

    testWidgets('the flip has no transition when animations are off', (
      tester,
    ) async {
      sizeViewport(tester);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedSwitcher), findsNothing);
      await tester.tap(_cardAt(0));
      await tester.pump();
      expect(_stateOf(tester, 0), FactCardState.faceUp);
      expect(find.byType(AnimatedSwitcher), findsNothing);
    });

    testWidgets('the flip turns the card when animations are on', (
      tester,
    ) async {
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedSwitcher), findsNWidgets(12));
      await tester.tap(_cardAt(0));
      await tester.pump(durationNormal ~/ 2);
      // Mid-flip both faces are in the tree.
      expect(
        find.descendant(of: _cardAt(0), matching: find.byType(Card)),
        findsNWidgets(2),
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: _cardAt(0), matching: find.byType(Card)),
        findsOneWidget,
      );
    });
  });

  group('layout', () {
    for (final (scale, columns) in [(1.0, 3), (1.3, 2), (2.0, 2)]) {
      testWidgets('$columns columns at text scale $scale', (tester) async {
        sizeViewport(tester);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        final grid = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, columns);
      });
    }

    for (final language in ['en', 'ja', 'es']) {
      for (final scale in [1.0, 1.3, 2.0]) {
        testWidgets('every face shows its whole text, $language at $scale', (
          tester,
        ) async {
          sizeViewport(tester, size: const Size(320, 2400));
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final pool = _longestPool(realPlayable, language);
          final board = firstDeal(pool, language);
          expect(board.cards, hasLength(12));
          await tester.pumpWidget(
            buildScreen(
              pool: pool,
              locale: Locale(language),
              theme: language == 'ja'
                  ? ThemeData(fontFamily: 'FlutterTest')
                  : null,
            ),
          );
          await tester.pumpAndSettle();
          await _matchAll(tester, board);

          for (final card in board.cards) {
            expect(
              find.descendant(
                of: find.byType(FactCardTile),
                matching: find.text(card.text),
              ),
              findsOneWidget,
              reason: card.text,
            );
          }
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('the status row wraps at text scale 2', (tester) async {
      sizeViewport(tester, size: const Size(320 * robotoToSfWidthFactor, 640));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(buildScreen(locale: const Locale('es')));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Movimientos: 0')).dy,
        greaterThan(tester.getTopLeft(find.text('Parejas: 0 de 6')).dy),
      );
    });

    stressWidthLayoutTests(
      (locale, theme) => buildScreen(
        pool: _longestPool(realPlayable, locale.languageCode),
        locale: locale,
        theme: theme,
      ),
      widths: testPhoneWidths,
      act: (tester, locale) async {
        final pool = _longestPool(realPlayable, locale.languageCode);
        await _matchAll(tester, firstDeal(pool, locale.languageCode));
        await tester.scrollUntilVisible(
          find.byType(FilledButton),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
      },
    );

    testWidgets('the locked view lays out at 320pt, text scale 2', (
      tester,
    ) async {
      sizeViewport(tester, size: const Size(320 * robotoToSfWidthFactor, 568));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        buildScreen(pool: const [], locale: const Locale('es')),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('reload and locale', () {
    testWidgets('a pool reload mid-board keeps the board', (tester) async {
      sizeViewport(tester);
      final users = StreamController<AppUserModel?>();
      addTearDown(users.close);
      final facts = playableFacts(10);
      AppUserModel user(int days) => AppUserModel(
        uid: 'u',
        email: 'e',
        unlockedFactDates: [
          for (var day = 1; day <= days; day++)
            '2026-01-${day.toString().padLeft(2, '0')}',
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            currentUserProvider.overrideWith((_) => users.stream),
            ecoFactsProvider.overrideWith((_) async => facts),
            analyticsServiceProvider.overrideWithValue(_RecordingAnalytics()),
          ],
          child: FactPairsScreen(random: Random(_seed)),
        ),
      );
      users.add(user(6));
      await tester.pumpAndSettle();
      final before = _cardTexts(tester);
      expect(before, hasLength(12));
      await _tapCard(tester, 0);

      users.add(user(9));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.pumpAndSettle();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(FactPairsScreen)),
      );
      expect(container.read(factGamesPoolProvider('en')).value, hasLength(9));
      expect(_cardTexts(tester), before);
      expect(_stateOf(tester, 0), FactCardState.faceUp);
    });

    testWidgets('a locale change deals a new board', (tester) async {
      sizeViewport(tester);
      final pool = playableFacts(8);
      final random = Random(_seed);
      FactPairsBoard.deal(ecoGameFacts(pool, 'en'), random);
      final japanese = FactPairsBoard.deal(ecoGameFacts(pool, 'ja'), random);
      final locale = ValueNotifier(const Locale('en'));
      addTearDown(locale.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            languageStoreOverride(),
            factGamesPoolProvider.overrideWith(
              (_, locale) async => ecoGameFacts(pool, locale),
            ),
            analyticsServiceProvider.overrideWithValue(_RecordingAnalytics()),
          ],
          child: ValueListenableBuilder(
            valueListenable: locale,
            builder: (_, value, _) => MaterialApp(
              locale: value,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: FactPairsScreen(random: Random(_seed)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _tapCard(tester, 0);

      locale.value = const Locale('ja');
      await tester.pumpAndSettle();
      expect(_cardTexts(tester), [for (final c in japanese.cards) c.text]);
      expect(_stateOf(tester, 0), FactCardState.faceDown);
      expect(find.text('手数 0'), findsOneWidget);
    });
  });
}
