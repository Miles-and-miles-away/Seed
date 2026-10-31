import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/text_styles.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/fact_games/presentation/fact_source.dart';
import 'package:seed_app/features/fact_games/presentation/providers/fact_games_providers.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/fact_games_locked_view.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/recall_answer_button.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/recall_question_card.dart';
import 'package:seed_app/features/mascot/presentation/widgets/game_win_celebration.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Share of the screen height the answers may take before they scroll,
/// a guard for iOS accessibility text sizes.
const _answersMaxHeightFactor = 0.45;

/// Fact recall: each question blanks the key figure of a fact or a
/// calculator comparison and offers it with two decoys. It opens once the
/// user has discovered [factRecallMinEcoDex] Eco-Dex entries.
///
/// Nothing is awarded, logged or persisted, and there is no best score.
class FactRecallScreen extends ConsumerStatefulWidget {
  const FactRecallScreen({this.random, super.key});

  /// Fixed seed for deterministic deals in tests; the route passes
  /// nothing.
  final Random? random;

  @override
  ConsumerState<FactRecallScreen> createState() => _FactRecallScreenState();
}

class _FactRecallScreenState extends ConsumerState<FactRecallScreen> {
  late final Random _random = widget.random ?? Random();

  /// Widget state rather than a provider: its strings and decoys belong
  /// to the locale it was dealt in.
  FactRecallRound? _round;
  String? _roundLocale;

  final _scroll = ScrollController(keepScrollOffset: false);

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logFactRecallOpened();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _deal(
    List<GameFact> pool,
    List<GameFact> calculator,
    List<GameFact> allPlayable,
    String locale, {
    Set<String> avoidIds = const {},
  }) {
    _roundLocale = locale;
    final dealable = [...pool, ...calculator];
    if (distinctFigureCount(dealable) < factGamesMinFacts) {
      _round = null;
      return;
    }
    final round = FactRecallRound.deal(
      pool: dealable,
      allPlayable: allPlayable,
      // Joined so a Japanese line never splits the blank.
      blank: AppLocalizations.of(
        context,
      ).factRecallBlank.characters.join(wordJoiner),
      random: _random,
      avoidIds: avoidIds,
    );
    // Data that breaks the decoy rule deals nothing: locked, not a crash.
    _round = round.questions.isEmpty ? null : round;
  }

  void _announce(String message) => SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    Directionality.of(context),
  );

  String _questionAnnouncement(AppLocalizations l10n, FactRecallRound round) =>
      '${l10n.factRecallProgress(round.index + 1, round.questions.length)}\n'
      '${round.question.title}';

  void _answer(FactRecallRound round, int option) {
    final right = round.answer(option);
    if (right == null) return;
    setState(() {});
    if (round.isLast) {
      ref
          .read(analyticsServiceProvider)
          .logFactRecallFinished(
            questions: round.questions.length,
            correct: round.correct,
          );
    }
    final l10n = AppLocalizations.of(context);
    _announce(
      right ? l10n.quizCorrect : l10n.factRecallWrong(round.question.answer),
    );
  }

  void _next(FactRecallRound round) {
    setState(round.next);
    final l10n = AppLocalizations.of(context);
    if (round.finished) {
      // The panel and its focused button go, so the result is spoken.
      _announce(l10n.factRecallFinished(round.correct, round.questions.length));
      return;
    }
    if (_scroll.hasClients) _scroll.jumpTo(0);
    _announce(_questionAnnouncement(l10n, round));
  }

  void _playAgain(
    FactRecallRound last,
    List<GameFact> pool,
    List<GameFact> calculator,
    List<GameFact> allPlayable,
    String locale,
  ) {
    setState(
      () =>
          _deal(pool, calculator, allPlayable, locale, avoidIds: last.askedIds),
    );
    final round = _round;
    if (round != null) {
      _announce(_questionAnnouncement(AppLocalizations.of(context), round));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final poolAsync = ref.watch(factGamesPoolProvider(locale));
    final allAsync = ref.watch(factGamesAllPlayableProvider(locale));
    final calculatorAsync = ref.watch(factGamesCalculatorFactsProvider(locale));
    final pool = poolAsync.value;
    final allPlayable = allAsync.value;
    final calculator = calculatorAsync.value;
    final discovered = ref.watch(ecoDexDiscoveredCountProvider);
    Widget body;
    Widget? panel;
    if (pool == null || allPlayable == null || calculator == null) {
      body = poolAsync.hasError || allAsync.hasError || calculatorAsync.hasError
          ? const Center(child: ErrorDisplay())
          : const Center(child: CircularProgressIndicator());
    } else {
      // Only a new locale or a newly playable pool deals; a reload does not.
      if (discovered >= factRecallMinEcoDex &&
          (_roundLocale != locale || _round == null)) {
        _deal(pool, calculator, allPlayable, locale);
      }
      final round = _round;
      if (discovered < factRecallMinEcoDex) {
        body = FactGamesLockedView(
          count: discovered,
          needed: factRecallMinEcoDex,
        );
      } else if (round == null) {
        // Open to everyone, so a pool too small to deal means its data
        // failed.
        body = const Center(child: ErrorDisplay());
      } else if (round.finished) {
        body = _FinishPanel(
          round: round,
          onPlayAgain: () =>
              _playAgain(round, pool, calculator, allPlayable, locale),
        );
        if (round.correct == round.questions.length) {
          body = Stack(
            children: [
              body,
              Positioned.fill(child: GameWinCelebration(key: ObjectKey(round))),
            ],
          );
        }
      } else {
        body = _questionBody(context, l10n, round);
        panel = _AnswerPanel(
          round: round,
          onAnswer: (option) => _answer(round, option),
          onNext: () => _next(round),
          onExplore: () => openFactSource(context, round.question.fact),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.factRecallTitle)),
      body: body,
      bottomNavigationBar: panel,
    );
  }

  Widget _questionBody(
    BuildContext context,
    AppLocalizations l10n,
    FactRecallRound round,
  ) {
    final theme = Theme.of(context);
    final noteStyle = theme.caption;
    return ListView(
      // A new round, after a locale change too, opens at the top.
      key: ObjectKey(round),
      controller: _scroll,
      padding: const EdgeInsets.all(spacingXxl),
      children: [
        PhraseText(
          l10n.factRecallRules,
          minLineWidth: phraseNarrowestScreenWidth - 2 * spacingXxl,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: spacingLg),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: spacingXs,
          children: [
            Text(
              l10n.factRecallProgress(round.index + 1, round.questions.length),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(l10n.factRecallScore(round.correct), style: noteStyle),
          ],
        ),
        const SizedBox(height: spacingMd),
        RecallQuestionCard(
          question: round.question,
          answered: round.chosen != null,
        ),
        const SizedBox(height: spacingXxl),
        Text(l10n.quizNoPointsNote, style: noteStyle),
      ],
    );
  }
}

/// Pinned under the question so the result, the answers and Next never
/// scroll away behind a long fact.
class _AnswerPanel extends StatelessWidget {
  const _AnswerPanel({
    required this.round,
    required this.onAnswer,
    required this.onNext,
    required this.onExplore,
  });

  final FactRecallRound round;
  final ValueChanged<int> onAnswer;
  final VoidCallback onNext;

  /// Opens where the current fact lives; offered after a wrong answer.
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final question = round.question;
    final chosen = round.chosen;
    final answered = chosen != null;
    final right = chosen == question.answerIndex;
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            spacingXxl,
            spacingSm,
            spacingXxl,
            spacingLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // On top, so the panel grows upwards and nothing moves under
              // the finger.
              if (answered) ...[
                PhraseText(
                  right
                      ? l10n.quizCorrect
                      : l10n.factRecallWrong(
                          jaFigureWrap(
                            question.answer,
                            locale: Localizations.localeOf(context),
                          ),
                        ),
                  minLineWidth: phraseNarrowestScreenWidth - 2 * spacingXxl,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: right
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                ),
                if (!right)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: onExplore,
                      icon: const Icon(Icons.explore_outlined),
                      label: Text(l10n.factRecallExploreFact),
                    ),
                  ),
                const SizedBox(height: spacingSm),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      _answersMaxHeightFactor *
                      MediaQuery.sizeOf(context).height,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (i, option) in question.options.indexed) ...[
                        if (i > 0) const SizedBox(height: spacingSm),
                        RecallAnswerButton(
                          figure: option,
                          state: !answered
                              ? RecallAnswerState.idle
                              : i == question.answerIndex
                              ? RecallAnswerState.right
                              : i == chosen
                              ? RecallAnswerState.wrong
                              : RecallAnswerState.other,
                          onPressed: answered ? null : () => onAnswer(i),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: spacingSm),
              FilledButton(
                onPressed: answered ? onNext : null,
                child: Text(
                  round.isLast ? l10n.factRecallSeeScore : l10n.factRecallNext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Replaces the question when the round is over; the panel goes with it.
class _FinishPanel extends StatelessWidget {
  const _FinishPanel({required this.round, required this.onPlayAgain});

  final FactRecallRound round;
  final VoidCallback onPlayAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(spacingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.factRecallFinished(round.correct, round.questions.length),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: spacingLg),
            FilledButton(
              onPressed: onPlayAgain,
              child: Text(l10n.factGamesPlayAgain),
            ),
          ],
        ),
      ),
    );
  }
}
