import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';
import 'package:seed_app/features/fact_games/domain/fact_pairs_board.dart';
import 'package:seed_app/features/fact_games/presentation/providers/fact_games_providers.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/fact_card_tile.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/fact_games_locked_view.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Fact pairs: a memory game matching each unlocked eco-fact's title to
/// its key figure. Each match opens the fact in a sheet.
///
/// Nothing is awarded, logged or persisted, and there is no best score:
/// boards differ in size, so a best would mislead.
class FactPairsScreen extends ConsumerStatefulWidget {
  const FactPairsScreen({this.random, super.key});

  /// Fixed seed for deterministic deals in tests; the route passes
  /// nothing.
  final Random? random;

  @override
  ConsumerState<FactPairsScreen> createState() => _FactPairsScreenState();
}

class _FactPairsScreenState extends ConsumerState<FactPairsScreen> {
  late final Random _random = widget.random ?? Random();

  /// Widget state rather than a provider: its strings belong to the
  /// locale it was dealt in.
  FactPairsBoard? _board;
  String? _boardLocale;
  Timer? _missTimer;
  final _finishKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logFactPairsOpened();
  }

  @override
  void dispose() {
    _missTimer?.cancel();
    super.dispose();
  }

  void _deal(List<EcoFact> pool, String locale) {
    _missTimer?.cancel();
    _boardLocale = locale;
    _board = distinctFigureCount(pool) < factGamesMinFacts
        ? null
        : FactPairsBoard.deal(pool, locale, _random);
  }

  void _announce(String message) => SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    Directionality.of(context),
  );

  void _flip(FactPairsBoard board, int index) {
    final result = board.flip(index);
    if (result == FlipResult.ignored) return;
    setState(() {});
    final l10n = AppLocalizations.of(context);
    final card = board.cards[index];
    // One message per flip, so the verdict cannot cut off the card.
    _announce(switch (result) {
      FlipResult.match when board.finished =>
        '${card.text}\n${l10n.factPairsMatch}\n'
            '${l10n.factPairsFinished(board.moves)}',
      FlipResult.match => '${card.text}\n${l10n.factPairsMatch}',
      FlipResult.miss => '${card.text}\n${l10n.factPairsMiss}',
      _ => card.text,
    });
    switch (result) {
      case FlipResult.match:
        if (board.finished) {
          ref
              .read(analyticsServiceProvider)
              .logFactPairsFinished(pairs: board.pairCount, moves: board.moves);
          // Scrolled behind the sheet, so the panel is waiting when it closes.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final panel = _finishKey.currentContext;
            if (panel != null && panel.mounted) {
              Scrollable.ensureVisible(
                panel,
                alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
              );
            }
          });
        }
        final locale = _boardLocale!;
        InfoSheet.show(
          context,
          title: card.fact.name(locale),
          body: card.fact.fact(locale),
        );
      case FlipResult.miss:
        _missTimer = Timer(durationCelebration, () {
          if (mounted) setState(board.hideMiss);
        });
      case FlipResult.first:
      case FlipResult.ignored:
        break;
    }
  }

  /// The button goes with the panel, so the new board is announced.
  void _playAgain(List<EcoFact> pool, String locale) {
    setState(() => _deal(pool, locale));
    final board = _board;
    if (board != null) {
      _announce(
        AppLocalizations.of(context).factPairsFound(0, board.pairCount),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final poolAsync = ref.watch(factGamesPoolProvider);
    final pool = poolAsync.value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.factPairsTitle)),
      body: switch (pool) {
        null when poolAsync.hasError => const Center(child: ErrorDisplay()),
        null => const Center(child: CircularProgressIndicator()),
        final pool => _buildBody(context, l10n, pool),
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    List<EcoFact> pool,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    // Only a new locale or a newly playable pool deals; a reload does not.
    if (_boardLocale != locale || _board == null) _deal(pool, locale);
    final board = _board;
    if (board == null) {
      return FactGamesLockedView(count: distinctFigureCount(pool));
    }

    final theme = Theme.of(context);
    final noteStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final wide = MediaQuery.textScalerOf(context).scale(14) > 14;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(spacingXxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhraseText(
            l10n.factPairsRules,
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
                l10n.factPairsFound(board.matchedPairs, board.pairCount),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(l10n.factPairsMoves(board.moves), style: noteStyle),
            ],
          ),
          const SizedBox(height: spacingMd),
          GridView.count(
            crossAxisCount: wide ? factCardWideColumns : factCardColumns,
            mainAxisSpacing: spacingSm,
            crossAxisSpacing: spacingSm,
            childAspectRatio: wide ? factCardWideAspect : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final (i, card) in board.cards.indexed)
                FactCardTile(
                  card: card,
                  index: i,
                  total: board.cards.length,
                  state: board.matched.contains(i)
                      ? FactCardState.matched
                      : board.faceUp.contains(i)
                      ? FactCardState.faceUp
                      : FactCardState.faceDown,
                  onTap: board.matched.contains(i) || board.faceUp.contains(i)
                      ? null
                      : () => _flip(board, i),
                ),
            ],
          ),
          if (board.finished)
            Column(
              key: _finishKey,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: spacingLg),
                Text(
                  l10n.factPairsFinished(board.moves),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: spacingMd),
                FilledButton(
                  onPressed: () => _playAgain(pool, locale),
                  child: Text(l10n.factGamesPlayAgain),
                ),
              ],
            ),
          const SizedBox(height: spacingXxl),
          Text(l10n.quizNoPointsNote, style: noteStyle),
        ],
      ),
    );
  }
}
