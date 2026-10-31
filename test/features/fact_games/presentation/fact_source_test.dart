import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_science_bottom_sheet.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_sheet.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/fact_games/presentation/fact_source.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/shared/widgets/info_sheet.dart';

import '../../../helpers/test_helpers.dart';
import '../fact_games_fixtures.dart';

const _goal = SdgGoal(
  number: 2,
  titleEn: 'End hunger',
  shortTitleEn: 'Zero Hunger',
  descriptionEn:
      'End hunger. An estimated 645 million people faced hunger in 2025. '
      'Farming matters.',
  color: Color(0xFF000000),
  keyFigureEn: '645 million',
  keyFigureJa: '645 million',
  keyFigureEs: '645 million',
);

const _action = ActionModel(
  id: 'cycle',
  nameEn: 'Cycle',
  nameJa: '自転車',
  category: 'transport',
  points: 1,
  co2Grams: 1100,
  descriptionLongEn: 'Cycling saves about **1.1 kg** of CO2. More here.',
);

const _entry = EcoDexEntry(
  id: 'climate_01',
  category: 'climate',
  nameEn: 'The Greenhouse Effect',
  nameJa: '温室効果',
  nameEs: 'El efecto invernadero',
  factEn: 'CO2 is 50% above its old level.',
  iconName: 'climate_01',
  condition: EcoDexCondition.totalActions(count: 1),
  hintEn: 'Log an action',
  keyFigureEn: '50%',
  keyFigureJa: '50%',
  keyFigureEs: '50%',
);

/// A button that runs [onTap] with a context, on a flat router whose
/// other pages name their location.
Widget _harness(void Function(BuildContext context) onTap) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => onTap(context),
              child: const Text('go'),
            ),
          ),
        ),
      ),
    ],
  );
  addTearDown(router.dispose);
  return _app(router);
}

Widget _app(GoRouter router) => ProviderScope(
  overrides: [languageStoreOverride(), userOverride(null)],
  child: MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  ),
);

Widget _page(GoRouterState state) => Scaffold(body: Text('at ${state.uri}'));

/// The app's nesting: Home and Explore branches in a shell, with Fact
/// recall and the calculators at the root. Fact recall shows [question]
/// and an Explore button that opens [fact].
GoRouter _nestedRouter(GameFact fact, String question) => GoRouter(
  initialLocation: '/explore',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => shell,
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, state) => _page(state),
              routes: [
                GoRoute(
                  path: 'sdg/:goalNumber',
                  builder: (_, state) => _page(state),
                ),
                GoRoute(
                  path: 'daily-fact',
                  builder: (_, state) => _page(state),
                  routes: [
                    GoRoute(
                      path: ':dateKey',
                      builder: (_, state) => _page(state),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, _) => Scaffold(
                body: TextButton(
                  onPressed: () => context.push('/fact-recall'),
                  child: const Text('play'),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/fact-recall',
      builder: (context, _) => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text(question),
            TextButton(
              onPressed: () => openFactSource(context, fact),
              child: const Text('explore'),
            ),
          ],
        ),
      ),
    ),
    for (final path in [
      '/log-action',
      '/food-calculator',
      '/transport-calculator',
      '/energy-calculator',
    ])
      GoRoute(path: path, builder: (_, state) => _page(state)),
  ],
);

void main() {
  group('openFactSource from Fact recall', () {
    const question = 'question on screen';

    Future<void> explore(WidgetTester tester, GameFact fact) async {
      final router = _nestedRouter(fact, question);
      addTearDown(router.dispose);
      await tester.pumpWidget(_app(router));
      await tester.pumpAndSettle();
      await tester.tap(find.text('play'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('explore'));
      await tester.pumpAndSettle();
    }

    Future<void> expectBackAtQuestion(WidgetTester tester) async {
      expect(tester.takeException(), isNull);
      expect(find.text(question).hitTestable(), findsOneWidget);
      expect(find.text('explore').hitTestable(), findsOneWidget);
    }

    Future<void> closeSheet(WidgetTester tester) async {
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();
    }

    for (final (name, fact, sheet) in [
      (
        'an eco-fact shows its text and source',
        ecoGameFacts([playableFact(4)], 'en').single,
        InfoSheet,
      ),
      (
        'an SDG fact shows its goal',
        sdgGameFacts([_goal], 'en').single,
        InfoSheet,
      ),
      (
        "an action fact shows the action's info sheet",
        actionGameFacts([_action], 'en').single,
        ActionScienceBottomSheet,
      ),
      (
        'an Eco-Dex fact shows its entry',
        ecoDexGameFacts([_entry], 'en').single,
        EcoDexEntrySheet,
      ),
    ]) {
      testWidgets('$name over the round, then back to it', (tester) async {
        await explore(tester, fact);
        expect(tester.takeException(), isNull);
        expect(find.byType(sheet), findsOneWidget);
        expect(find.textContaining('at /'), findsNothing);

        await closeSheet(tester);
        expect(find.byType(sheet), findsNothing);
        await expectBackAtQuestion(tester);
      });
    }

    for (final (kind, location) in [
      (GameFactKind.food, '/food-calculator'),
      (GameFactKind.transport, '/transport-calculator'),
      (GameFactKind.energy, '/energy-calculator'),
    ]) {
      testWidgets('a ${kind.name} comparison opens its calculator, and Back '
          'returns to the round', (tester) async {
        await explore(
          tester,
          kindFact('${kind.name}:a', kind, recallOnly: true),
        );
        expect(find.text('at $location'), findsOneWidget);

        final context = tester.element(find.text('at $location'));
        GoRouter.of(context).pop();
        await tester.pumpAndSettle();
        await expectBackAtQuestion(tester);
      });
    }
  });

  group('showFactSheet', () {
    Future<void> show(WidgetTester tester, GameFact fact) async {
      await tester.pumpWidget(
        _harness((context) => showFactSheet(context, fact)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('go'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('an SDG fact shows the whole goal description', (tester) async {
      await show(tester, sdgGameFacts([_goal], 'en').single);
      expect(find.byType(InfoSheet), findsOneWidget);
      expect(find.text(_goal.descriptionEn), findsOneWidget);
    });

    testWidgets("an action fact shows the action's info sheet", (tester) async {
      await show(tester, actionGameFacts([_action], 'en').single);
      expect(find.byType(ActionScienceBottomSheet), findsOneWidget);
    });

    testWidgets('an eco-fact shows its text and source', (tester) async {
      final fact = ecoGameFacts([playableFact(4)], 'en').single;
      await show(tester, fact);
      expect(find.byType(InfoSheet), findsOneWidget);
      expect(find.text('${fact.text}\n\nSource: Source'), findsOneWidget);
    });

    testWidgets('an Eco-Dex fact shows its entry sheet', (tester) async {
      await show(tester, ecoDexGameFacts([_entry], 'es').single);
      expect(find.byType(EcoDexEntrySheet), findsOneWidget);
      expect(find.text('El efecto invernadero'), findsOneWidget);
    });

    testWidgets('a fact with no source shows its text', (tester) async {
      final fact = kindFact('food:a', GameFactKind.food, recallOnly: true);
      await show(tester, fact);
      expect(find.byType(InfoSheet), findsOneWidget);
      expect(find.text(fact.text), findsOneWidget);
    });
  });
}
