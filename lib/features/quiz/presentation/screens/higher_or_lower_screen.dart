import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_ranked_table.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/quiz/presentation/providers/quiz_providers.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
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

/// A domain a round can be drawn from.
///
/// Every round stays inside one of these. A food-versus-electricity pair
/// would set a cradle-to-retail lifecycle figure against an operational
/// one, which is a scope error rather than a hard question, and a
/// food-to-electricity ratio also inherits grid variance linearly where
/// a within-domain one does not (PDR_ENERGY_CALCULATOR decision E8, and
/// the never-sum warning in all three dataset metadata blocks). Mixing
/// which domain a round comes from is fine; mixing a pair is not.
enum QuizDomain {
  energy,
  food,
  transport;

  ActionCategory get category => switch (this) {
    QuizDomain.energy => ActionCategory.energy,
    QuizDomain.food => ActionCategory.food,
    QuizDomain.transport => ActionCategory.transport,
  };

  /// The fill behind a token.
  Color get color => category.color;

  /// The same colour darkened enough to carry text: the raw category
  /// colours are fills, and amber reads 1.6:1 on white.
  Color ink(Brightness brightness, {bool large = false}) =>
      category.textColorOn(brightness, large: large);

  /// What one card of this domain measures, stated above the tokens so
  /// the user knows what they are comparing.
  String basis(AppLocalizations l10n) => switch (this) {
    QuizDomain.energy => l10n.quizBasisEnergy,
    QuizDomain.food => l10n.quizBasisFood,
    QuizDomain.transport => l10n.quizBasisTransport,
  };
}

/// "Higher or lower?" across all three datasets (decision E8).
///
/// Its own feature rather than part of energy: it draws on the energy,
/// food and transport datasets equally, and shipped inside `energy`
/// only because energy was the first deck it had.
///
/// Two cards, names only: drag the one you think has the bigger
/// footprint to the top. Figures stay hidden until the answer is in --
/// showing one card's figure up front handed over most of the answer.
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

  /// Shared by the decks and the domain draw, so a seeded Random makes
  /// a whole run reproducible.
  late final Random _random = widget.random ?? Random();

  /// Measured off the laid-out tokens: the wheel's vertical radius is
  /// half a token plus a gap, so a committed quarter turn stacks them
  /// clear of each other however tall the reveal makes them.
  final _rowKey = GlobalKey();
  double _tokenHeight = _tokenHeightFallback;

  double get _verticalRadius => (_tokenHeight + spacingMd) / 2;

  void _measureTokens() {
    final height = _rowKey.currentContext?.size?.height;
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

    return Scaffold(
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
    _decks[QuizDomain.energy] = QuizDeck(
      cards: [
        for (final behavior in behaviors)
          // Gas never deals: its ordering against electricity is a fact
          // about the user's grid (rule 28).
          if (behavior.carrier != EnergyCarrier.gas)
            _energyCard(
              l10n,
              locale,
              behavior,
              anchorKwh: anchorKwh,
              anchorPhrase: anchorPhrase,
              gridFactor: factors.grid,
            ),
      ],
      minGapPercent: EnergyCalculator.verdictMinPercent,
      random: _random,
    );
    _decks[QuizDomain.food] = QuizDeck(
      cards: [
        for (final item in items)
          // Tier 1 only, so every pair is within one source tier and the
          // ordinary bar applies rather than the cross-tier one.
          if (item.sourceTier == 1 && item.defaultServing != null)
            _foodCard(locale, item),
      ],
      minGapPercent: FoodCalculator.verdictMinPercent,
      random: _random,
    );
    _decks[QuizDomain.transport] = QuizDeck(
      cards: [
        for (final mode in modes)
          // Per-vehicle modes state a vehicle-km, so they cannot be
          // ranked against per-passenger rows without an occupancy the
          // quiz has no way to ask for.
          if (!mode.perVehicle) _transportCard(l10n, locale, mode),
      ],
      minGapPercent: _transportMinGapPercent,
      random: _random,
    );
  }

  QuizCard _energyCard(
    AppLocalizations l10n,
    String locale,
    EnergyBehavior behavior, {
    required double anchorKwh,
    required String anchorPhrase,
    required double gridFactor,
  }) {
    final kwh = EnergyCalculator.defaultPresetKwh(behavior);
    final grams = formatCO2Compact((kwh * gridFactor).round());
    return QuizCard(
      id: 'energy:${behavior.id}',
      title: behavior.name(locale),
      subtitle: behavior.defaultPreset?.name(locale) ?? '',
      magnitude: kwh,
      revealText: _hasAnchor
          ? l10n.energyExploreSheetMultiple(
              formatEnergyMultiple(locale, kwh / anchorKwh),
              anchorPhrase,
            )
          : grams,
      revealDetail: _hasAnchor ? grams : '',
    );
  }

  /// Grams CO2e of one default serving: `kg CO2e per kg x serving
  /// grams`, the same arithmetic the food calculator uses.
  QuizCard _foodCard(String locale, FoodItem item) {
    final serving = item.defaultServing!;
    final grams = item.kgCo2ePerKg * serving.grams;
    return QuizCard(
      id: 'food:${item.id}',
      title: item.name(locale),
      subtitle: serving.name(locale),
      magnitude: grams,
      revealText: formatCO2Compact(grams.round()),
    );
  }

  QuizCard _transportCard(
    AppLocalizations l10n,
    String locale,
    TransportMode mode,
  ) => QuizCard(
    id: 'transport:${mode.id}',
    title: mode.name(locale),
    subtitle: '',
    magnitude: mode.gCo2ePerKm,
    revealText: l10n.quizPerKm(formatCO2Compact(mode.gCo2ePerKm.round())),
  );

  /// Deals a pair from a randomly chosen domain, or empties the pair
  /// when no domain can produce one.
  void _deal() {
    final domains = _decks.keys.toList()..shuffle(_random);
    for (final domain in domains) {
      final deck = _decks[domain]!;
      final first = deck.drawNext();
      final second = deck.drawNext();
      if (first != null && second != null) {
        _domain = domain;
        _pair[0] = first;
        _pair[1] = second;
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
    if (first == null || second == null) return;
    final actual = first.magnitude > second.magnitude ? 0 : 1;
    final correct = higherIndex == actual;
    if (correct) {
      ref.read(quizBestStreakProvider.notifier).record(_streak + 1);
    } else {
      ref.read(analyticsServiceProvider).logQuizStreakEnded(streak: _streak);
    }
    HapticFeedback.mediumImpact();
    setState(() {
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
  }

  void _advance() => setState(() {
    _deal();
    _revealed = false;
    _higherIndex = null;
  });

  /// Deals a fresh deck. Also the way out of the exhausted state, where
  /// no remaining card clears the gap against the current one.
  void _restart() => setState(() {
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
          // Which dataset this round came from, and what one card of it
          // measures: the user is comparing servings, or uses, or
          // passenger-kilometres, and never two of those at once.
          Center(
            child: Text(
              domain.basis(l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: domain.ink(theme.brightness),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: spacingLg),
          Center(child: Text(l10n.quizHigher.toUpperCase(), style: zoneStyle)),
          // The swing is a paint-time transform, so the play area
          // reserves the room it needs.
          Padding(
            padding: EdgeInsets.symmetric(vertical: _verticalRadius),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Two tokens at opposite ends of one diameter: the
                // radius is half the gap between their centres.
                final radius = (constraints.maxWidth + spacingMd) / 4;
                // Stretch inside IntrinsicHeight so both tokens are the
                // same size whatever their names do -- a two-line title
                // used to leave one token visibly taller.
                return IntrinsicHeight(
                  child: Row(
                    key: _rowKey,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _token(context, 0, first, domain, radius),
                      ),
                      const SizedBox(width: spacingMd),
                      Expanded(
                        child: _token(context, 1, second, domain, radius),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Center(child: Text(l10n.quizLower.toUpperCase(), style: zoneStyle)),
          const SizedBox(height: spacingLg),
          if (!_revealed)
            Text(
              l10n.quizQuestion,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            )
          else ...[
            Text(
              _wasCorrect ? l10n.quizCorrect : l10n.quizWrong,
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
                    child: Text(card.title, style: theme.textTheme.bodyMedium),
                  ),
                  const SizedBox(width: spacingLg),
                  Text(card.revealText, style: noteStyle),
                ],
              ),
            ),
        ],
        const SizedBox(height: spacingXxl),
        Text(switch (domain) {
          QuizDomain.energy =>
            _hasAnchor
                ? l10n.energyGridBasisNoteRatio(factors.grid.round())
                : l10n.energyGridBasisNote(factors.grid.round()),
          QuizDomain.food => l10n.quizNoteFood,
          QuizDomain.transport => l10n.quizNoteTransport,
        }, style: noteStyle),
        const SizedBox(height: spacingSm),
        Text(l10n.quizNoPointsNote, style: noteStyle),
      ],
    );
  }

  /// One token on the wheel. Names only until the answer is in, then
  /// the multiple leads and the grams follow smaller (rule 26).
  ///
  /// Tinted by the domain it belongs to. The deck today is all energy,
  /// so the colour is this screen's to supply -- a food deck brings its
  /// own, and the deck model stays free of presentation.
  Widget _token(
    BuildContext context,
    int index,
    QuizCard card,
    QuizDomain domain,
    double radius,
  ) {
    final theme = Theme.of(context);
    final dragging = _dragIndex == index && !_revealed;
    // Left token rides the near end of the diameter, right the far end,
    // so the same turn moves them oppositely and both swing inward.
    final sign = index == 0 ? 1.0 : -1.0;
    final turn = _turn;
    return GestureDetector(
      onVerticalDragUpdate: (details) => _onDragUpdate(index, details),
      onVerticalDragEnd: (_) => _onDragEnd(),
      child: AnimatedContainer(
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
        child: Card(
          elevation: dragging ? 8 : null,
          color: domain.color.withValues(alpha: opacityLight),
          child: Padding(
            padding: const EdgeInsets.all(spacingLg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (card.subtitle.isNotEmpty)
                  Text(
                    card.subtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (_revealed) ...[
                  const SizedBox(height: spacingSm),
                  Text(
                    card.revealText,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: domain.ink(theme.brightness, large: true),
                    ),
                  ),
                  if (card.revealDetail.isNotEmpty)
                    Text(
                      card.revealDetail,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
