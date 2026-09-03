import 'dart:math';

import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';

/// What-if sheet for one row of the explore screen (decision E8).
///
/// A slider over the behavior's own unit, with the figure it produces
/// stated as a multiple of the chosen baseline (rule 26: the multiple
/// leads, the grams follow smaller with their basis named) and drawn as
/// a wall of baseline icons.
///
/// Gas rows carry the same energy multiple as everything else, plus
/// the note explaining why their grams do not follow the ranking
/// (owner call 2026-09-02).
class EnergyExploreSheet extends StatefulWidget {
  const EnergyExploreSheet({
    required this.behavior,
    required this.anchorBehavior,
    required this.anchorIcon,
    required this.anchorUnitPhrase,
    required this.factors,
    super.key,
  });

  final EnergyBehavior behavior;

  /// The baseline row. Null drops to grams-only, the same degrade the
  /// ranked table makes when the anchor is not in its list.
  final EnergyBehavior? anchorBehavior;

  final IconData anchorIcon;

  /// Resolved by the caller so the sheet stays free of anchor id logic.
  final String anchorUnitPhrase;

  final CarrierFactors factors;

  /// Shows the sheet. Same shape as [UsageEditorSheet.show].
  static Future<void> show(
    BuildContext context, {
    required EnergyBehavior behavior,
    required EnergyBehavior? anchorBehavior,
    required IconData anchorIcon,
    required String anchorUnitPhrase,
    required CarrierFactors factors,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    // A wall of a few thousand icons is taller than the screen, and a
    // full-height sheet leaves no barrier to tap and no way back.
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * _maxSheetHeightFraction,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
    ),
    builder: (_) => EnergyExploreSheet(
      behavior: behavior,
      anchorBehavior: anchorBehavior,
      anchorIcon: anchorIcon,
      anchorUnitPhrase: anchorUnitPhrase,
      factors: factors,
    ),
  );

  @override
  State<EnergyExploreSheet> createState() => _EnergyExploreSheetState();
}

/// Slider bounds per unit: a plausible span of one sitting, in whole
/// units, rather than the open-ended field the routine editor needs.
const _sliderRanges = <EnergyUnit, (int, int)>{
  EnergyUnit.minute: (1, 60),
  EnergyUnit.hour: (1, 12),
  EnergyUnit.use: (1, 10),
  EnergyUnit.day: (1, 7),
};

/// Icons per row at each anchor count: ten fill one row, a hundred
/// fill about eight, five hundred about twenty.
///
/// The size follows from these rather than the other way round -- the
/// icons are whatever size fills the width at that many per row -- so
/// the wall always spans the width and grows downward. Interpolated in
/// between on a log scale, which keeps it monotone: more icons never
/// means bigger icons. Past the last anchor the icons sit on their
/// floor and the wall simply gets taller.
const _wallRowWidths = <(int, int)>[(1, 1), (10, 10), (100, 13), (500, 25)];

/// One glyph is one em wide, so a row of [perRow] icons spans
/// `perRow * size * _wallGapFactor` exactly -- the extra is the
/// letter spacing that keeps the icons from touching.
const _wallGapFactor = 1.08;

/// Shaves the computed size so the intended number of icons really
/// does fit on the row.
const _wallFitSafety = 0.99;

/// Big enough to be worth looking at, small enough to stay legible.
const _wallIconMaxSize = 40.0;
const _wallIconMinSize = 12.0;

/// A single sub-baseline icon shrinks to its own fraction, but never
/// below this: an eighth of a kettle is 0.13, and 3pt of glyph is a
/// speck rather than a smaller icon. The headline carries the exact
/// figure either way.
const _wallMinFractionSize = 8.0;

/// The most of the screen the sheet may take, so a strip of barrier
/// stays tappable above it however long the wall gets.
const _maxSheetHeightFraction = 0.9;

/// Key for the wall itself, whose glyph count is the whole point.
const wallKey = Key('energyExploreWall');

class _EnergyExploreSheetState extends State<EnergyExploreSheet> {
  late double _units;

  (int, int) get _range => _sliderRanges[widget.behavior.unit] ?? (1, 10);

  @override
  void initState() {
    super.initState();
    final (min, max) = _range;
    final preset = widget.behavior.defaultPreset?.units ?? min;
    _units = preset.round().clamp(min, max).toDouble();
  }

  /// The multiple is an ENERGY ratio, so it holds for gas rows too:
  /// what changes with the carrier is the gram figure under it, and the
  /// gas note explains that.
  bool get _showsMultiple => widget.anchorBehavior != null;

  double get _anchorKwh {
    final anchor = widget.anchorBehavior;
    return anchor == null ? 0 : EnergyCalculator.defaultPresetKwh(anchor);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final (min, max) = _range;
    final kwh = widget.behavior.kwhPerUnit * _units;
    final isGas = widget.behavior.carrier == EnergyCarrier.gas;
    final grams = kwh * (isGas ? widget.factors.gas : widget.factors.grid);
    final multiple = _showsMultiple && _anchorKwh > 0 ? kwh / _anchorKwh : null;
    final noteStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    // The category colour as it is, matching the ranked bars and the
    // wall: the headline, the slider and the icons are one colour
    // (owner call 2026-09-02). It reads 1.6:1 on this surface, which is
    // under the text bar -- the kWh line above and the gram line below
    // carry the same figure in ordinary ink.
    final accent = ActionCategory.energy.color;
    // What reads on a solid fill of that colour, for the slider's
    // value bubble.
    final onAccent =
        ThemeData.estimateBrightnessForColor(accent) == Brightness.light
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onPrimary;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: spacingSm),
              child: IconButton(
                icon: const Icon(Icons.close),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                spacingXxl,
                spacingSm,
                spacingXxl,
                spacingXxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.behavior.name(locale),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: spacingXs),
                  Text(
                    energyBehaviorFactorLabel(l10n, widget.behavior),
                    textAlign: TextAlign.center,
                    style: noteStyle,
                  ),
                  const SizedBox(height: spacingLg),
                  Text(
                    energyUsageDetailLabel(l10n, widget.behavior, _units),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  SliderTheme(
                    // Track, thumb and the value bubble are UI graphics: the
                    // 3:1 tone, since the raw amber is 1.6:1 on this surface.
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: accent,
                      thumbColor: accent,
                      overlayColor: accent.withValues(alpha: opacityFaint),
                      activeTickMarkColor: accent,
                      valueIndicatorColor: accent,
                      valueIndicatorTextStyle: theme.textTheme.labelMedium
                          ?.copyWith(color: onAccent),
                    ),
                    child: Slider(
                      value: _units,
                      min: min.toDouble(),
                      max: max.toDouble(),
                      divisions: max - min,
                      label: energyUsageDetailLabel(
                        l10n,
                        widget.behavior,
                        _units,
                      ),
                      onChanged: (value) =>
                          setState(() => _units = value.roundToDouble()),
                    ),
                  ),
                  const SizedBox(height: spacingSm),
                  if (multiple != null)
                    Text(
                      l10n.energyExploreSheetMultiple(
                        formatEnergyMultiple(locale, multiple),
                        widget.anchorUnitPhrase,
                      ),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: accent,
                      ),
                    ),
                  Text(
                    formatCO2Compact(grams.round()),
                    textAlign: TextAlign.center,
                    style: multiple == null
                        ? theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          )
                        : theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                  ),
                  if (multiple != null) ...[
                    const SizedBox(height: spacingLg),
                    _wall(context, l10n, multiple, noteStyle),
                  ],
                  const SizedBox(height: spacingLg),
                  Text(
                    isGas
                        ? l10n.energyRankedGasNote
                        : multiple != null
                        ? l10n.energyGridBasisNoteRatio(
                            widget.factors.grid.round(),
                          )
                        : l10n.energyGridBasisNote(widget.factors.grid.round()),
                    style: noteStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A wall of baseline icons that fills as the slider moves: one icon
  /// per baseline, the whole count, so ten baths really do draw ten
  /// times the icons of one.
  ///
  /// Thousands of glyphs, so it is one Text in the icon font rather than
  /// thousands of Icon widgets -- the text engine shapes and wraps a
  /// 6,700-glyph run in one layout, where 6,700 widgets would not hold a
  /// frame. The size is set by the fullest wall this slider can reach,
  /// so icons do not resize under the user's thumb mid-drag.
  Widget _wall(
    BuildContext context,
    AppLocalizations l10n,
    double multiple,
    TextStyle? noteStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => TweenAnimationBuilder<double>(
            tween: Tween(end: multiple),
            duration: durationNormal,
            builder: (context, filled, _) {
              final size = _wallIconSizeFor(filled, constraints.maxWidth);
              return Text(
                // Under one baseline there is one icon, drawn at that
                // fraction of its size: half a phone charge is half an
                // icon, not a rounded-away zero or a whole one.
                _glyphs(filled < 1 ? (filled > 0 ? 1 : 0) : filled.round()),
                key: wallKey,
                style: TextStyle(
                  fontFamily: widget.anchorIcon.fontFamily,
                  package: widget.anchorIcon.fontPackage,
                  fontSize: filled > 0 && filled < 1
                      ? (size * filled).clamp(_wallMinFractionSize, size)
                      : size,
                  // A glyph is one em wide, so this spacing is exactly
                  // the gap the row width was solved for.
                  letterSpacing: size * (_wallGapFactor - 1),
                  height: 1.3,
                  // The same raw colour the ranked bars use. These
                  // are the one graphic on the sheet that repeats a
                  // figure already stated in words above it, so they
                  // can carry the category colour as it is rather than
                  // a darkened version of it (owner call 2026-09-02).
                  color: ActionCategory.energy.color,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: spacingSm),
        Text(
          l10n.energyExploreWallCaptionOne(widget.anchorUnitPhrase),
          style: noteStyle,
        ),
      ],
    );
  }

  String _glyphs(int count) =>
      String.fromCharCode(widget.anchorIcon.codePoint) * count;

  /// The size that fills [width] with this many icons in the rows the
  /// ladder asks for.
  ///
  /// Sized off the icons on screen right now, not off the slider's
  /// maximum: sizing off the maximum drew every state of a row the
  /// same, so a TV row topping out at 112 icons looked identical at 9,
  /// 56 and 112.
  double _wallIconSizeFor(double count, double width) {
    final icons = count.ceil();
    if (icons <= 0 || width <= 0) return _wallIconMaxSize;
    final mostPerRow = max(
      1,
      (width / (_wallIconMinSize * _wallGapFactor)).floor(),
    );
    final perRow = _perRowFor(icons).clamp(1, mostPerRow);
    // A hair under the exact fit: at exactly width/perRow the last icon
    // of a row wraps on a rounding error and the row looks short.
    final size = width / (perRow * _wallGapFactor) * _wallFitSafety;
    return size.clamp(_wallIconMinSize, _wallIconMaxSize);
  }

  /// Icons per row for [icons], interpolated between the anchors on a
  /// log scale so the size eases down instead of jumping at a step.
  int _perRowFor(int icons) {
    final last = _wallRowWidths.last;
    if (icons >= last.$1) return last.$2 * 2;
    for (var i = 0; i < _wallRowWidths.length - 1; i++) {
      final (fromCount, fromPerRow) = _wallRowWidths[i];
      final (toCount, toPerRow) = _wallRowWidths[i + 1];
      if (icons > toCount) continue;
      final t = (log(icons) - log(fromCount)) / (log(toCount) - log(fromCount));
      return (fromPerRow + t * (toPerRow - fromPerRow)).round();
    }
    return _wallRowWidths.first.$2;
  }
}
