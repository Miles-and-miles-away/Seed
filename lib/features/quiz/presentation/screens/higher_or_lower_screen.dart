import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_ranked_table.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_science_sheet.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/food/presentation/widgets/food_science_sheet.dart';
import 'package:seed_app/features/quiz/presentation/providers/quiz_providers.dart';
import 'package:seed_app/features/quiz/presentation/quiz_cards.dart';
import 'package:seed_app/features/quiz/presentation/widgets/quiz_item_sheet.dart';
import 'package:seed_app/features/quiz/presentation/widgets/quiz_token_card.dart';
import 'package:seed_app/features/quiz/presentation/widgets/quiz_token_pair.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_science_sheet.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/domain/quiz_deck.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// The two tokens ride opposite ends of one diameter, so lifting either
/// spins the other down and both swing inward as the wheel turns.
///
/// A quarter turn is the whole travel: at 90 degrees both tokens sit on
/// the vertical centre line, one directly above the other. Angles in
/// radians.
const _wheelQuarterTurn = pi / 2;
const _wheelCommitThreshold = 0.3;

/// Radians per pixel of finger travel: slow enough that the wheel feels
/// weighted rather than skittish.
const _dragToTurn = 0.01;

/// Height assumed until the tokens have been laid out once.
const _tokenHeightFallback = 140.0;

/// The transport calculator states no verdict bar of its own, so the
/// transport deck uses the one energy and food share.
const _transportMinGapPercent = EnergyCalculator.verdictMinPercent;

/// Opening rounds of every run deal an obvious pair while the gesture is new.
const _warmUpRounds = 3;
const _warmUpMinRatio = 3.0;

const _hintIconSize = 24.0;
const _hintBobHeight = 6.0;
const _hintBobs = 3;

/// The page's text width on a [phraseNarrowestScreenWidth] phone.
const _pageMinLineWidth = phraseNarrowestScreenWidth - 2 * spacingXxl;

/// The hint row and the gap under it, inside the swing room.
const _hintHeight = _hintIconSize + spacingXs;

/// "Higher or lower?" across all three datasets (decision E8).
///
/// Its own feature rather than part of energy: it draws on the energy,
/// food and transport datasets equally, and shipped inside `energy`
/// only because energy was the first deck it had.
///
/// Two cards, names only: tap or drag up the one you think produces
/// more carbon. Figures stay hidden until the answer is in -- showing
/// one card's figure up front handed over most of the answer.
///
/// Rounds rotate between home energy, food and transport at random, and
/// each round is drawn wholly from one domain ([QuizDomain]).
///
/// Every deck drops the rows it cannot rank honestly: gas behaviors,
/// whose ordering against electricity flips with the user's grid (rule
/// 28); the food dataset's tier-2 rows, measured to a narrower boundary
/// than the rest; and per-vehicle transport modes, whose figure is per
/// vehicle-km rather than per passenger-km. Pairs inside each
/// calculator's own honesty bar are skipped for the same reason.
///
/// Decoration only: no points, nothing logged, nothing persisted beyond
/// the session (decision 8.18).
class HigherOrLowerScreen extends ConsumerStatefulWidget {
  const HigherOrLowerScreen({this.random, super.key});

  /// Fixed seed for deterministic deals in tests; the route passes
  /// nothing.
  final Random? random;

  @override
  ConsumerState<HigherOrLowerScreen> createState() =>
      _HigherOrLowerScreenState();
}

class _HigherOrLowerScreenState extends ConsumerState<HigherOrLowerScreen> {
  final _decks = <QuizDomain, QuizDeck>{};

  /// Locale the decks' strings were resolved in; a change rebuilds them.
  String? _decksLocale;
  QuizDomain? _domain;
  final _pair = <QuizCard?>[null, null];
  int _streak = 0;
  bool _revealed = false;
  bool _wasCorrect = false;
  List<QuizCard> _ladder = const [];

  /// Index of the token being dragged, and how far it has turned the
  /// wheel. Positive means the right-hand token has come up.
  int? _dragIndex;
  double _dragTurn = 0;

  /// The card the user claims is the bigger user, once they commit.
  int? _higherIndex;

  /// False when the dataset handed to this screen has no LED row: an
  /// energy reveal then states grams alone, as the ranked table does.
  bool _hasAnchor = true;

  /// Each card's science sheet, by card id.
  final _science = <String, void Function(BuildContext)>{};

  /// Up arrows over the tokens until the first drag or answer of a visit.
  bool _hintVisible = true;

  /// Shared by the decks and the domain draw, so a seeded Random makes
  /// a whole run reproducible.
  late final Random _random = widget.random ?? Random();

  /// Measured off the laid-out tokens: the wheel's vertical radius is
  /// half a token plus a gap, so a committed quarter turn stacks them
  /// clear of each other however tall the reveal makes them.
  final _tokenKey = GlobalKey();
  double _tokenHeight = _tokenHeightFallback;

  double get _verticalRadius => (_tokenHeight + spacingMd) / 2;

  void _measureTokens() {
    final height = _tokenKey.currentContext?.size?.height;
    if (height == null || (height - _tokenHeight).abs() < 0.5) return;
    setState(() => _tokenHeight = height);
  }

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logQuizOpened();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final behaviorsAsync = ref.watch(energyBehaviorsProvider);
    final factorsAsync = ref.watch(energyCarrierFactorsProvider);
    final itemsAsync = ref.watch(foodItemsProvider);
    final modesAsync = ref.watch(transportModesProvider);

    return WalkthroughTrigger(
      item: WalkthroughItem.quiz,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.quizTitle)),
        body: switch ((behaviorsAsync, factorsAsync, itemsAsync, modesAsync)) {
          (
            AsyncData(value: final behaviors),
            AsyncData(value: final factors),
            AsyncData(value: final items),
            AsyncData(value: final modes),
          ) =>
            _buildBody(context, l10n, behaviors, factors, items, modes),
          (AsyncError(), _, _, _) ||
          (_, AsyncError(), _, _) ||
          (_, _, AsyncError(), _) ||
          (_, _, _, AsyncError()) => const Center(child: ErrorDisplay()),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }

  /// Built once per run rather than in a provider: the cards hold
  /// locale-resolved strings, so a keepAlive deck would go stale on a
  /// language change.
  void _buildDecks(
    AppLocalizations l10n,
    String locale,
    List<EnergyBehavior> behaviors,
    CarrierFactors factors,
    List<FoodItem> items,
    List<TransportMode> modes,
  ) {
    final anchor = behaviors
        .where((b) => b.id == EnergyRankedTable.defaultAnchorId)
        .firstOrNull;
    final anchorKwh = anchor == null
        ? 0.0
        : EnergyCalculator.defaultPresetKwh(anchor);
    _hasAnchor = anchorKwh > 0;
    final anchorPhrase = energyAnchorUnitPhrase(
      l10n,
      EnergyRankedTable.defaultAnchorId,
    );
    _science.clear();
    QuizCard withScience(
      QuizCard card,
      void Function(BuildContext context) show,
    ) {
      _science[card.id] = show;
      return card;
    }

    _decks[QuizDomain.energy] = QuizDeck(
      cards: [
        for (final behavior in behaviors)
          if (isQuizEnergy(behavior))
            withScience(
              energyQuizCard(
                l10n,
                locale,
                behavior,
                anchorKwh: anchorKwh,
                anchorPhrase: anchorPhrase,
                gridFactor: factors.grid,
              ),
              (context) => showEnergyScienceSheet(
                context,
                behavior: behavior,
                languageCode: locale,
              ),
            ),
      ],
      minGapPercent: EnergyCalculator.verdictMinPercent,
      random: _random,
    );
    _decks[QuizDomain.food] = QuizDeck(
      cards: [
        for (final item in items)
          if (isQuizFood(item))
            withScience(
              foodQuizCard(l10n, locale, item),
              (context) => showFoodScienceSheet(
                context,
                item: item,
                languageCode: locale,
              ),
            ),
      ],
      minGapPercent: FoodCalculator.verdictMinPercent,
      random: _random,
    );
    _decks[QuizDomain.transport] = QuizDeck(
      cards: [
        for (final mode in modes)
          if (isQuizTransport(mode))
            withScience(
              transportQuizCard(l10n, locale, mode),
              (context) => showTransportScienceSheet(
                context,
                mode: mode,
                languageCode: locale,
              ),
            ),
      ],
      minGapPercent: _transportMinGapPercent,
      random: _random,
    );
  }

  /// Deals a pair from a randomly chosen domain, or empties the pair
  /// when no domain can produce one.
  void _deal() {
    final domains = _decks.keys.toList()..shuffle(_random);
    for (final domain in domains) {
      final deck = _decks[domain]!;
      final first = deck.drawNext();
      // A warm-up draw that finds nothing far enough falls back to the
      // deck's own bar rather than ending the run.
      final second = first == null
          ? null
          : (_streak < _warmUpRounds
                    ? deck.drawNext(minRatio: _warmUpMinRatio)
                    : null) ??
                deck.drawNext();
      if (first != null && second != null) {
        _domain = domain;
        // Random sides, or the second card's place hints at the answer.
        final swap = _random.nextBool();
        _pair[0] = swap ? second : first;
        _pair[1] = swap ? first : second;
        return;
      }
    }
    _pair[0] = null;
    _pair[1] = null;
  }

  /// Dragging either token turns the one wheel: up on the right and
  /// down on the left are the same motion.
  void _onDragUpdate(int index, DragUpdateDetails details) {
    if (_revealed) return;
    setState(() {
      _dragIndex = index;
      final push = details.delta.dy * _dragToTurn * (index == 0 ? 1 : -1);
      _dragTurn = (_dragTurn + push).clamp(
        -_wheelQuarterTurn,
        _wheelQuarterTurn,
      );
    });
  }

  void _onDragEnd() {
    if (_revealed) return;
    if (_dragTurn.abs() < _wheelCommitThreshold) {
      setState(() {
        _dragIndex = null;
        _dragTurn = 0;
      });
      return;
    }
    // Whichever token the turn has lifted is the claim.
    _answer(_dragTurn > 0 ? 1 : 0);
  }

  void _answer(int higherIndex) {
    final first = _pair[0];
    final second = _pair[1];
    if (_revealed || first == null || second == null) return;
    final actual = first.magnitude > second.magnitude ? 0 : 1;
    final correct = higherIndex == actual;
    if (correct) {
      ref.read(quizBestStreakProvider.notifier).record(_streak + 1);
    } else {
      ref.read(analyticsServiceProvider).logQuizStreakEnded(streak: _streak);
    }
    HapticFeedback.mediumImpact();
    setState(() {
      _hintVisible = false;
      _higherIndex = higherIndex;
      _dragIndex = null;
      _dragTurn = 0;
      _revealed = true;
      _wasCorrect = correct;
      if (correct) {
        _streak += 1;
        _ladder = [_pair[higherIndex]!, _pair[1 - higherIndex]!, ..._ladder];
      } else {
        _streak = 0;
        _ladder = const [];
      }
    });
    // The token keeps focus and its label changes, which is not re-read.
    final l10n = AppLocalizations.of(context);
    SemanticsService.sendAnnouncement(
      View.of(context),
      correct ? l10n.quizAnnounceRight(_streak) : l10n.quizAnnounceWrong,
      Directionality.of(context),
    );
  }

  void _advance() => setState(() {
    _deal();
    _revealed = false;
    _higherIndex = null;
  });

  /// Deals a fresh deck. Also the way out of the exhausted state, where
  /// no remaining card clears the gap against the current one.
  void _restart() => setState(() {
    _hintVisible = false;
    _decks.clear();
    _revealed = false;
    _higherIndex = null;
    _streak = 0;
    _ladder = const [];
  });

  /// The wheel's current turn: the committed answer once it is in,
  /// otherwise wherever the finger has left it.
  double get _turn {
    final higher = _higherIndex;
    if (higher == null) return _dragTurn;
    return higher == 1 ? _wheelQuarterTurn : -_wheelQuarterTurn;
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    List<EnergyBehavior> behaviors,
    CarrierFactors factors,
    List<FoodItem> items,
    List<TransportMode> modes,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    if (_decks.isEmpty || _decksLocale != locale) {
      _decksLocale = locale;
      _buildDecks(l10n, locale, behaviors, factors, items, modes);
      _deal();
      _revealed = false;
      _higherIndex = null;
    }
    final theme = Theme.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measureTokens();
    });
    final best = ref.watch(quizBestStreakProvider);
    final walkthroughOpen = ref.watch(
      walkthroughPendingProvider(WalkthroughItem.quiz),
    );
    final first = _pair[0];
    final second = _pair[1];
    final domain = _domain ?? QuizDomain.energy;
    final noteStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final zoneStyle = theme.textTheme.labelLarge?.copyWith(
      color: theme.colorScheme.outline,
      letterSpacing: 1.2,
    );

    return ListView(
      padding: const EdgeInsets.all(spacingXxl),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.quizStreakLabel(_streak),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(l10n.quizBestLabel(best), style: noteStyle),
          ],
        ),
        if (first == null || second == null)
          Padding(
            padding: const EdgeInsets.only(top: spacingXxl),
            child: FilledButton(
              onPressed: _restart,
              child: Text(l10n.quizNewRun),
            ),
          )
        else ...[
          const SizedBox(height: spacingLg),
          PhraseText(
            l10n.quizSubtitle,
            minLineWidth: _pageMinLineWidth,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: spacingSm),
          // Which dataset this round came from, and what one card of it
          // measures: the user is comparing servings, or uses, or
          // passenger-kilometres, and never two of those at once.
          PhraseText(
            domain.basis(l10n),
            minLineWidth: _pageMinLineWidth,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: domain.ink(theme.brightness),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingSm),
          // Above the tokens, so a small phone shows it without a scroll.
          PhraseText(
            l10n.quizQuestion,
            minLineWidth: _pageMinLineWidth,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: spacingLg),
          Center(child: Text(l10n.quizHigher.toUpperCase(), style: zoneStyle)),
          LayoutBuilder(
            builder: (context, constraints) {
              // Two tokens at opposite ends of one diameter: the radius
              // is half the gap between their centres.
              final radius = (constraints.maxWidth + spacingMd) / 4;
              final width = (constraints.maxWidth - spacingMd) / 2;
              // Both at the taller one's height, whatever their names do.
              final row = QuizTokenPair(
                gap: spacingMd,
                left: _token(
                  l10n,
                  0,
                  first,
                  domain,
                  factors,
                  radius: radius,
                  width: width,
                ),
                right: _token(
                  l10n,
                  1,
                  second,
                  domain,
                  factors,
                  radius: radius,
                  width: width,
                ),
              );
              // The hint sits in the swing room, so nothing moves when it
              // goes, and the row keeps its place so a drag survives it.
              return Stack(
                children: [
                  row,
                  if (_hintVisible)
                    Positioned(
                      top: max(0, _verticalRadius - _hintHeight),
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        // Keyed so the bob starts once the walkthrough goes.
                        child: _SwipeHint(
                          key: ValueKey(walkthroughOpen),
                          color: domain.ink(theme.brightness),
                          still: walkthroughOpen,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Center(child: Text(l10n.quizLower.toUpperCase(), style: zoneStyle)),
          if (_revealed) ...[
            const SizedBox(height: spacingLg),
            PhraseText(
              _wasCorrect ? l10n.quizCorrect : l10n.quizWrong,
              minLineWidth: _pageMinLineWidth,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _wasCorrect
                    ? domain.ink(theme.brightness)
                    : theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: spacingMd),
            FilledButton(onPressed: _advance, child: Text(l10n.quizContinue)),
          ],
        ],
        if (_ladder.isNotEmpty) ...[
          const SizedBox(height: spacingXxl),
          Text(
            l10n.quizLadderHeading,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingSm),
          for (final card in _ladder)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: spacingXs),
              child: Row(
                children: [
                  Expanded(
                    child: PhraseText(
                      card.title,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: spacingLg),
                  Text(card.revealText, style: noteStyle),
                ],
              ),
            ),
        ],
        const SizedBox(height: spacingXxl),
        PhraseText(
          _note(l10n, domain, factors),
          minLineWidth: _pageMinLineWidth,
          style: noteStyle,
        ),
        const SizedBox(height: spacingSm),
        PhraseText(
          l10n.quizNoPointsNote,
          minLineWidth: _pageMinLineWidth,
          style: noteStyle,
        ),
      ],
    );
  }

  String _note(
    AppLocalizations l10n,
    QuizDomain domain,
    CarrierFactors factors,
  ) => domain.note(l10n, gridFactor: factors.grid, hasAnchor: _hasAnchor);

  /// One token on the wheel: a tap answers as a committed drag does, and
  /// a screen reader sees one button with no scroll actions to misfire.
  Widget _token(
    AppLocalizations l10n,
    int index,
    QuizCard card,
    QuizDomain domain,
    CarrierFactors factors, {
    required double radius,
    required double width,
  }) {
    final dragging = _dragIndex == index && !_revealed;
    // Left token rides the near end of the diameter, right the far end,
    // so the same turn moves them oppositely and both swing inward.
    final sign = index == 0 ? 1.0 : -1.0;
    final turn = _turn;
    final choose = _revealed ? null : () => _answer(index);
    // Outermost, so the token takes taps wherever the swing carries it.
    return AnimatedContainer(
      duration: dragging ? Duration.zero : durationEmphasis,
      curve: Curves.elasticOut,
      // Horizontal radius from the layout, vertical from the token
      // height: a true circle would end the quarter turn with the two
      // tokens overlapping, since each is far taller than the gap
      // between their centres. The tokens never rotate -- they hang
      // upright like the cabins of a wheel, so their text stays level.
      transform: Matrix4.translationValues(
        sign * radius * (1 - cos(turn)),
        sign * _verticalRadius * sin(turn),
        0,
      ),
      transformAlignment: Alignment.center,
      // The swing room, inside the row so the row takes taps there.
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: _verticalRadius),
        child: Semantics(
          key: index == 0 ? _tokenKey : null,
          container: true,
          button: !_revealed,
          label: _tokenLabel(l10n, card),
          hint: _revealed ? null : l10n.quizChooseHint,
          onTap: choose,
          child: GestureDetector(
            excludeFromSemantics: true,
            onTap: choose,
            // None once revealed, so a drag on a token scrolls the page.
            onVerticalDragStart: _revealed
                ? null
                : (_) {
                    if (_hintVisible) setState(() => _hintVisible = false);
                  },
            onVerticalDragUpdate: _revealed
                ? null
                : (details) => _onDragUpdate(index, details),
            onVerticalDragEnd: _revealed ? null : (_) => _onDragEnd(),
            child: QuizTokenCard(
              card: card,
              domain: domain,
              revealed: _revealed,
              width: width,
              lifted: dragging,
              onInfo: () => QuizItemSheet.show(
                context,
                card: card,
                domain: domain,
                revealed: _revealed,
                note: _note(l10n, domain, factors),
                onScience: () => _science[card.id]?.call(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Read in place of the token's own texts, so the item is read once.
  String _tokenLabel(AppLocalizations l10n, QuizCard card) {
    if (_revealed) {
      final revealed = l10n.quizItemRevealedLabel(card.title, card.revealText);
      return card.revealDetail.isEmpty
          ? revealed
          : l10n.quizItemLabel(revealed, card.revealDetail);
    }
    return card.subtitle.isEmpty
        ? card.title
        : l10n.quizItemLabel(card.title, card.subtitle);
  }
}

/// Up arrows that bob a few times, or not at all under reduced motion.
class _SwipeHint extends StatelessWidget {
  const _SwipeHint({required this.color, required this.still, super.key});

  final Color color;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final still =
        this.still ||
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.reduceMotionOf(context);
    final icon = Icon(
      Icons.keyboard_double_arrow_up,
      size: _hintIconSize,
      color: color,
    );
    Widget arrow() => still
        ? icon
        : icon.animate().custom(
            duration: durationSlower * _hintBobs,
            builder: (_, value, child) => Transform.translate(
              offset: Offset(
                0,
                -_hintBobHeight * sin(_hintBobs * pi * value).abs(),
              ),
              child: child,
            ),
          );
    return ExcludeSemantics(
      child: SizedBox(
        height: _hintIconSize,
        child: Row(
          children: [
            Expanded(child: Center(child: arrow())),
            const SizedBox(width: spacingMd),
            Expanded(child: Center(child: arrow())),
          ],
        ),
      ),
    );
  }
}
