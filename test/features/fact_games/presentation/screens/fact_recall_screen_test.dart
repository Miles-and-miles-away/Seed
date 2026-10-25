import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/fact_games.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/recall_answer_button.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/recall_question_card.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';

import '../../../../helpers/test_helpers.dart';
import '../../fact_games_fixtures.dart';

class _RecordingAnalytics extends Fake implements AnalyticsService {
  final events = <String>[];

  @override
  Future<void> logFactRecallOpened() async => events.add('opened');

  @override
  Future<void> logFactRecallFinished({
    required int questions,
    required int correct,
  }) async => events.add('finished:$questions:$correct');
}

const _seed = 7;

Finder _answerAt(int index) => find.byType(RecallAnswerButton).at(index);

final _next = find.byType(FilledButton);

Finder get _body => find
    .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
    .first;

String _blank(String locale) => lookupAppLocalizations(
  Locale(locale),
).factRecallBlank.characters.join(wordJoiner);

FactRecallRound _firstDeal(
  List<EcoFact> pool, {
  List<EcoFact>? allPlayable,
  String locale = 'en',
  Random? random,
  Set<int> avoidDays = const {},
}) => FactRecallRound.deal(
  pool: pool,
  allPlayable: allPlayable ?? pool,
  locale: locale,
  blank: _blank(locale),
  random: random ?? Random(_seed),
  avoidDays: avoidDays,
);

String _cardTitle(WidgetTester tester) => tester
    .widget<RecallQuestionCard>(find.byType(RecallQuestionCard))
    .question
    .title;

Future<void> _tapAnswer(WidgetTester tester, int index) async {
  await tester.tap(_answerAt(index));
  await tester.pumpAndSettle();
}

Future<void> _tapNext(WidgetTester tester) async {
  await tester.tap(_next);
  await tester.pumpAndSettle();
}

/// The playable facts with the longest texts in [locale], each figure
/// once.
List<EcoFact> _longestPool(List<EcoFact> facts, String locale) {
  final byText = [...facts]
    ..sort((a, b) => b.fact(locale).length - a.fact(locale).length);
  final figures = <String>{};
  return [
    for (final fact in byText)
      if (figures.add(fact.keyFigureEn)) fact,
  ].take(3).toList();
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
    List<EcoFact>? allPlayable,
    Locale locale = const Locale('en'),
    ThemeData? theme,
    _RecordingAnalytics? analytics,
  }) {
    final facts = pool ?? playableFacts(6);
    return createTestWidget(
      locale: locale,
      theme: theme,
      overrides: [
        factGamesPoolProvider.overrideWith((_) async => facts),
        factGamesAllPlayableProvider.overrideWith(
          (_) async => allPlayable ?? facts,
        ),
        analyticsServiceProvider.overrideWithValue(
          analytics ?? _RecordingAnalytics(),
        ),
      ],
      child: FactRecallScreen(random: Random(_seed)),
    );
  }

  group('locked', () {
    for (final count in [0, 2]) {
      testWidgets('with $count ready facts', (tester) async {
        sizeViewport(tester);
        await tester.pumpWidget(buildScreen(pool: playableFacts(count)));
        await tester.pumpAndSettle();

        expect(find.byType(FactGamesLockedView), findsOneWidget);
        expect(
          find.text('$count of 3 eco-facts with a number'),
          findsOneWidget,
        );
        expect(find.byType(RecallAnswerButton), findsNothing);
      });
    }
  });

  group('a round', () {
    testWidgets('right and wrong answers, the finish and Play again', (
      tester,
    ) async {
      sizeViewport(tester);
      final analytics = _RecordingAnalytics();
      final pool = playableFacts(6);
      final random = Random(_seed);
      final round = _firstDeal(pool, random: random);
      final next = _firstDeal(pool, random: random, avoidDays: round.askedDays);
      await tester.pumpWidget(buildScreen(pool: pool, analytics: analytics));
      await tester.pumpAndSettle();
      expect(analytics.events, ['opened']);
      expect(round.questions, hasLength(5));

      for (final (i, q) in round.questions.indexed) {
        expect(find.text('Question ${i + 1} of 5'), findsOneWidget);
        expect(find.text('Score: ${max(0, i - 1)}'), findsOneWidget);
        expect(find.text(q.title), findsOneWidget);
        expect(find.text(q.blanked), findsOneWidget);
        expect([
          for (final b in tester.widgetList<RecallAnswerButton>(
            find.byType(RecallAnswerButton),
          ))
            b.figure,
        ], q.options);

        // The first answer is wrong, the rest right.
        final wrong = (q.answerIndex + 1) % 3;
        await _tapAnswer(tester, i == 0 ? wrong : q.answerIndex);
        expect(
          find.text(i == 0 ? "Not this time. It's ${q.answer}." : 'Right!'),
          findsOneWidget,
        );
        final revealed = tester
            .widgetList<RichText>(
              find.descendant(
                of: find.byType(RecallQuestionCard),
                matching: find.byType(RichText),
              ),
            )
            .last
            .text;
        final spans = <TextSpan>[];
        revealed.visitChildren((span) {
          if (span is TextSpan) spans.add(span);
          return true;
        });
        final figure = spans.singleWhere((s) => s.text == q.answer);
        expect(figure.style?.fontWeight, FontWeight.bold);
        expect(revealed.toPlainText(), q.revealed);
        expect(find.text(q.blanked), findsNothing);
        expect(
          find.text(i == 4 ? 'See score' : 'Next question'),
          findsOneWidget,
        );
        if (i == 4) expect(analytics.events, ['opened', 'finished:5:4']);
        await _tapNext(tester);
      }

      expect(find.text('4 of 5 correct'), findsOneWidget);
      expect(find.byType(RecallAnswerButton), findsNothing);
      expect(find.byType(FilledButton), findsOneWidget);
      expect(analytics.events, ['opened', 'finished:5:4']);

      await tester.tap(find.text('Play again'));
      await tester.pumpAndSettle();
      expect(find.text('Question 1 of 5'), findsOneWidget);
      expect(find.text('Score: 0'), findsOneWidget);
      expect(_cardTitle(tester), next.questions.first.title);
      // The one fact the first round left out comes first.
      expect(
        round.askedDays,
        isNot(contains(next.questions.first.fact.dayOfYear)),
      );
      expect(analytics.events, ['opened', 'finished:5:4']);
    });

    testWidgets('Next is disabled until the question is answered', (
      tester,
    ) async {
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(_next).onPressed, isNull);
      await _tapAnswer(tester, 0);
      expect(tester.widget<FilledButton>(_next).onPressed, isNotNull);
    });

    testWidgets('answered buttons keep their state colours while disabled', (
      tester,
    ) async {
      sizeViewport(tester);
      final round = _firstDeal(playableFacts(6));
      final q = round.question;
      final wrong = (q.answerIndex + 1) % 3;
      final other = 3 - q.answerIndex - wrong;
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      await _tapAnswer(tester, wrong);

      final scheme = Theme.of(
        tester.element(find.byType(FactRecallScreen)),
      ).colorScheme;
      Color? fill(int index) => tester
          .widget<Material>(
            find
                .descendant(
                  of: _answerAt(index),
                  matching: find.byType(Material),
                )
                .first,
          )
          .color;
      for (final i in [0, 1, 2]) {
        expect(
          tester
              .widget<OutlinedButton>(
                find.descendant(
                  of: _answerAt(i),
                  matching: find.byType(OutlinedButton),
                ),
              )
              .onPressed,
          isNull,
        );
      }
      expect(fill(q.answerIndex), scheme.tertiaryContainer);
      expect(fill(wrong), scheme.errorContainer);
      expect(
        fill(other),
        isNot(anyOf(scheme.tertiaryContainer, scheme.errorContainer)),
      );
      expect(
        find.descendant(
          of: _answerAt(q.answerIndex),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: _answerAt(wrong),
          matching: find.byIcon(Icons.close),
        ),
        findsOneWidget,
      );

      // A second tap changes nothing.
      await tester.tap(_answerAt(q.answerIndex), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Score: 0'), findsOneWidget);
    });
  });

  group('fit', () {
    for (final size in [const Size(320, 568), const Size(360, 640)]) {
      for (final scale in [1.0, 2.0]) {
        for (final language in ['en', 'ja', 'es']) {
          testWidgets(
            'the result, answers and Next stay on screen, $language at '
            '${size.width.round()}x${size.height.round()}, text scale $scale',
            (tester) async {
              sizeViewport(tester, size: size);
              tester.platformDispatcher.textScaleFactorTestValue = scale;
              addTearDown(
                tester.platformDispatcher.clearTextScaleFactorTestValue,
              );
              final pool = _longestPool(realPlayable, language);
              await tester.pumpWidget(
                buildScreen(
                  pool: pool,
                  allPlayable: realPlayable,
                  locale: Locale(language),
                  theme: language == 'ja'
                      ? ThemeData(fontFamily: 'FlutterTest')
                      : null,
                ),
              );
              await tester.pumpAndSettle();

              final screen = Offset.zero & size;
              final l10n = lookupAppLocalizations(Locale(language));
              for (var i = 0; i < pool.length; i++) {
                final q = tester
                    .widget<RecallQuestionCard>(find.byType(RecallQuestionCard))
                    .question;
                await _tapAnswer(tester, 0);
                final result = find.text(
                  q.answerIndex == 0
                      ? l10n.quizCorrect
                      : l10n.factRecallWrong(q.answer),
                );
                for (final finder in [
                  result,
                  for (var a = 0; a < 3; a++) _answerAt(a),
                  _next,
                ]) {
                  expect(finder.hitTestable(), findsOneWidget);
                  final rect = tester.getRect(finder);
                  expect(
                    screen.contains(rect.topLeft) &&
                        screen.contains(rect.bottomRight - const Offset(1, 1)),
                    isTrue,
                    reason: '$rect',
                  );
                }
                expect(tester.takeException(), isNull);
                // Measured: 268dp at 1.0, as designed; at 2.0, 288dp, or
                // 328dp when the result line wraps.
                final panel = find.ancestor(
                  of: _next,
                  matching: find.byType(SafeArea),
                );
                expect(
                  tester.getSize(panel.first).height,
                  scale == 1 ? 268 : anyOf(288, 328),
                );

                await tester.drag(_body, const Offset(0, -400));
                await tester.pumpAndSettle();
                await _tapNext(tester);
                if (i < pool.length - 1) {
                  expect(
                    tester.state<ScrollableState>(_body).position.pixels,
                    0,
                  );
                }
              }
            },
          );
        }
      }
    }
  });

  group('accessibility', () {
    testWidgets('the card is one label, the blank spoken', (tester) async {
      final semantics = tester.ensureSemantics();
      sizeViewport(tester);
      final q = _firstDeal(playableFacts(6)).question;
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      final spoken = q.revealed.replaceAll(q.answer, 'blank');
      expect(find.bySemanticsLabel('${q.title}\n$spoken'), findsOneWidget);
      await _tapAnswer(tester, q.answerIndex);
      expect(
        find.bySemanticsLabel('${q.title}\n${q.revealed}'),
        findsOneWidget,
      );
      semantics.dispose();
    });

    testWidgets('answers are labelled with their figure and verdict', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      sizeViewport(tester);
      final q = _firstDeal(playableFacts(6)).question;
      final wrong = (q.answerIndex + 1) % 3;
      final other = 3 - q.answerIndex - wrong;
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(_answerAt(0)),
        isSemantics(
          label: q.options[0],
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await _tapAnswer(tester, wrong);
      expect(
        tester.getSemantics(_answerAt(q.answerIndex)).label,
        '${q.answer}, Right!',
      );
      expect(
        tester.getSemantics(_answerAt(wrong)).label,
        '${q.options[wrong]}, your answer, wrong',
      );
      expect(tester.getSemantics(_answerAt(other)).label, q.options[other]);
      semantics.dispose();
    });

    testWidgets('announces the answer, the next question and the score', (
      tester,
    ) async {
      sizeViewport(tester);
      final round = _firstDeal(playableFacts(3));
      await tester.pumpWidget(buildScreen(pool: playableFacts(3)));
      await tester.pumpAndSettle();
      tester.takeAnnouncements();
      List<String> said() => [
        for (final a in tester.takeAnnouncements()) a.message,
      ];

      final first = round.questions[0];
      await _tapAnswer(tester, (first.answerIndex + 1) % 3);
      expect(said(), ["Not this time. It's ${first.answer}."]);
      await _tapNext(tester);
      expect(said(), ['Question 2 of 3\n${round.questions[1].title}']);

      await _tapAnswer(tester, round.questions[1].answerIndex);
      expect(said(), ['Right!']);
      await _tapNext(tester);
      expect(said(), ['Question 3 of 3\n${round.questions[2].title}']);

      await _tapAnswer(tester, round.questions[2].answerIndex);
      expect(said(), ['Right!']);
      await _tapNext(tester);
      expect(said(), ['2 of 3 correct']);

      await tester.tap(find.text('Play again'));
      await tester.pumpAndSettle();
      expect(said(), [startsWith('Question 1 of 3\n')]);
    });

    testWidgets('Japanese progress counts questions, not a fraction', (
      tester,
    ) async {
      sizeViewport(tester);
      await tester.pumpWidget(buildScreen(locale: const Locale('ja')));
      await tester.pumpAndSettle();
      expect(find.text('第1問（全5問）'), findsOneWidget);
      expect(find.text('正解 0'), findsOneWidget);
    });

    testWidgets('answers meet the tap target guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      sizeViewport(tester, size: const Size(320, 568));
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  });

  group('layout', () {
    testWidgets('the status row wraps at text scale 2', (tester) async {
      sizeViewport(tester, size: const Size(320 * robotoToSfWidthFactor, 640));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(buildScreen(locale: const Locale('es')));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Aciertos: 0')).dy,
        greaterThan(tester.getTopLeft(find.text('Pregunta 1 de 5')).dy),
      );
    });

    stressWidthLayoutTests(
      (locale, theme) => buildScreen(
        pool: _longestPool(realPlayable, locale.languageCode),
        allPlayable: realPlayable,
        locale: locale,
        theme: theme,
      ),
      widths: testPhoneWidths,
      act: (tester, locale) async {
        await _tapAnswer(tester, 0);
        await _tapNext(tester);
      },
    );
  });

  group('reload and locale', () {
    testWidgets('a pool reload mid-round keeps the question', (tester) async {
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
          child: FactRecallScreen(random: Random(_seed)),
        ),
      );
      users.add(user(6));
      await tester.pumpAndSettle();
      await _tapAnswer(tester, 0);
      await _tapNext(tester);
      final title = _cardTitle(tester);

      users.add(user(9));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.pumpAndSettle();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(FactRecallScreen)),
      );
      expect(container.read(factGamesPoolProvider).value, hasLength(9));
      expect(find.text('Question 2 of 5'), findsOneWidget);
      expect(_cardTitle(tester), title);
    });

    testWidgets('a locale change restarts the round at the top', (
      tester,
    ) async {
      sizeViewport(tester, size: const Size(320, 568));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final pool = playableFacts(8);
      final random = Random(_seed);
      _firstDeal(pool, random: random);
      final japanese = _firstDeal(pool, locale: 'ja', random: random);
      final locale = ValueNotifier(const Locale('en'));
      addTearDown(locale.dispose);
      final analytics = _RecordingAnalytics();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            languageStoreOverride(),
            factGamesPoolProvider.overrideWith((_) async => pool),
            factGamesAllPlayableProvider.overrideWith((_) async => pool),
            analyticsServiceProvider.overrideWithValue(analytics),
          ],
          child: ValueListenableBuilder(
            valueListenable: locale,
            builder: (_, value, _) => MaterialApp(
              locale: value,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: FactRecallScreen(random: Random(_seed)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _tapAnswer(tester, 0);
      await _tapNext(tester);
      await tester.drag(_body, const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(tester.state<ScrollableState>(_body).position.pixels, 200);

      locale.value = const Locale('ja');
      await tester.pumpAndSettle();
      expect(tester.state<ScrollableState>(_body).position.pixels, 0);
      expect(find.text('第1問（全5問）'), findsOneWidget);
      expect(find.text('正解 0'), findsOneWidget);
      expect(_cardTitle(tester), japanese.questions.first.title);
      expect(analytics.events, ['opened']);
    });
  });
}
