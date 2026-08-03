import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/transport/data/models/city_model.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/flight_band.dart';
import 'package:seed_app/features/transport/domain/services/journey_distance.dart';
import 'package:seed_app/features/transport/domain/services/transport_calculator.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/features/transport/presentation/widgets/city_pair_fields.dart';
import 'package:seed_app/features/transport/presentation/widgets/occupancy_stepper.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';

/// Keeps the distance input to digits with at most one decimal
/// separator; ',' is allowed because locale keypads emit it (the
/// anchored pattern keeps the longest valid prefix).
final _distanceInputFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d*[.,]?\d*'),
);

/// Full-precision seed for the editable distance field. The display
/// formatter (formatKmCompact) rounds to one decimal, which would
/// silently truncate the value on an edit round-trip.
String _distanceSeedText(double km) {
  final text = km.toString();
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

/// A leg, the option column it belongs to, and where it ends.
///
/// [toCity] lets the screen chain the next leg's origin to this leg's
/// destination, which is what makes a multi-stop journey (Tokyo ->
/// Osaka -> Kobe) natural to enter one leg at a time.
class LegPlacement {
  const LegPlacement(this.leg, this.option, {this.toCity});

  final JourneyLeg leg;
  final int option;
  final City? toCity;
}

/// Bottom sheet for entering a leg's endpoints, distance and occupancy.
///
/// The mode is already chosen (dragged or tapped from the pool), so
/// this sheet is the numbers plus an optional per-leg city pair. That
/// pair is what supports a staged journey: Tokyo -> Osaka by
/// shinkansen, then Osaka -> Kobe by local train, each leg estimated
/// from its own endpoints rather than the whole trip's.
///
/// When [fixedOption] is null it ends in "Add to A" / "Add to B"
/// buttons -- the tap path's equivalent of choosing a drop target, and
/// the route that works without dragging.
class LegEditorSheet extends ConsumerStatefulWidget {
  const LegEditorSheet({
    required this.mode,
    this.initialLeg,
    this.defaultFrom,
    this.defaultTo,
    this.fixedOption,
    super.key,
  });

  /// The mode this leg uses.
  final TransportMode mode;

  /// Leg being edited, or null when adding a new one.
  final JourneyLeg? initialLeg;

  /// Origin to start from: the previous leg's destination, falling
  /// back to the journey's origin.
  final City? defaultFrom;

  /// Destination to start from: the journey's destination.
  final City? defaultTo;

  /// The column this leg is bound to, or null to ask.
  final int? fixedOption;

  static Future<LegPlacement?> show(
    BuildContext context, {
    required TransportMode mode,
    JourneyLeg? initialLeg,
    City? defaultFrom,
    City? defaultTo,
    int? fixedOption,
  }) {
    return showModalBottomSheet<LegPlacement>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) => LegEditorSheet(
        mode: mode,
        initialLeg: initialLeg,
        defaultFrom: defaultFrom,
        defaultTo: defaultTo,
        fixedOption: fixedOption,
      ),
    );
  }

  @override
  ConsumerState<LegEditorSheet> createState() => _LegEditorSheetState();
}

class _LegEditorSheetState extends ConsumerState<LegEditorSheet> {
  final _distanceController = TextEditingController();
  final _distanceFocus = FocusNode();
  int _occupants = 1;
  City? _from;
  City? _to;
  bool _distanceIsEstimate = false;
  bool _distanceInvalid = false;

  @override
  void initState() {
    super.initState();
    _from = widget.defaultFrom;
    _to = widget.defaultTo;
    // The "Unknown" placeholder is focus-dependent, so the field has
    // to rebuild when focus moves.
    _distanceFocus.addListener(() => setState(() {}));
    final leg = widget.initialLeg;
    if (leg != null) {
      _distanceController.text = _distanceSeedText(leg.distanceKm);
      _occupants = leg.occupants.clamp(1, max(1, widget.mode.maxOccupants));
    }
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _distanceFocus.dispose();
    super.dispose();
  }

  /// The mode this leg is actually priced with.
  ///
  /// For flights the honest band follows the leg's own endpoints: a
  /// Tokyo-Osaka hop must never carry a long-haul factor just because
  /// the user picked "Long-haul flight" from the list. This check used
  /// to live in the picker, filtering the list against a journey-level
  /// city pair; the pair is now per leg, so the correction belongs
  /// here, where both the mode and the endpoints are known.
  TransportMode get _effectiveMode {
    final base = widget.mode;
    if (base.group != 'air') return base;
    final from = _from;
    final to = _to;
    if (from == null || to == null) return base;
    final bandId = flightBandModeId(
      straightLineKm: haversineKm(from.lat, from.lon, to.lat, to.lon),
      fromCc: from.cc,
      toCc: to.cc,
    );
    if (bandId == base.id) return base;
    return ref.watch(transportModesByIdProvider).value?[bandId] ?? base;
  }

  /// This leg's estimate from its own endpoints, or null without a
  /// usable pair. Always via citySuggestionsProvider, which threads
  /// the water-blocked pair set (review requirement).
  double? get _suggestedKm {
    final from = _from;
    final to = _to;
    if (from == null || to == null) return null;
    final suggestions = ref.watch(citySuggestionsProvider(from, to)).value;
    return suggestions == null
        ? null
        : prefillKmForMode(_effectiveMode, suggestions);
  }

  /// Fills the distance from the current pair, unless the user typed
  /// their own value -- an unedited estimate is fair game to replace.
  void _applyEstimate(double? km) {
    final canPrefill =
        _distanceController.text.trim().isEmpty || _distanceIsEstimate;
    if (km == null || !canPrefill) return;
    final text = km.round().toString();
    if (_distanceController.text == text) return;
    _distanceController.text = text;
    _distanceIsEstimate = true;
  }

  /// The typed distance, or null when it is not a usable number.
  ///
  /// Locale keypads emit ',' as the decimal separator, so normalize
  /// before parsing ("12,5" reads as 12.5). tryParse also accepts
  /// "NaN" and "Infinity"; reject those and negatives too.
  double? get _parsedKm {
    final km = double.tryParse(
      _distanceController.text.trim().replaceAll(',', '.'),
    );
    return (km == null || km.isNaN || km.isInfinite || km < 0) ? null : km;
  }

  /// The leg as currently entered, for the live preview and the save.
  JourneyLeg? get _draftLeg {
    final km = _parsedKm;
    final mode = _effectiveMode;
    return km == null
        ? null
        : JourneyLeg(
            modeId: mode.id,
            distanceKm: km,
            occupants: mode.perVehicle ? _occupants : 1,
          );
  }

  void _save(int option) {
    final leg = _draftLeg;
    if (leg == null) {
      setState(() => _distanceInvalid = true);
      return;
    }
    Navigator.pop(context, LegPlacement(leg, option, toCity: _to));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final mode = _effectiveMode;
    final bandSwitched = mode.id != widget.mode.id;
    final suggested = _suggestedKm;
    _applyEstimate(suggested);
    // A complete pair the model has no honest estimate for (water-
    // blocked like Helsinki-Tallinn, or out of a mode's range) used to
    // look identical to no pair at all: a silently blank field. Say so
    // instead, and get out of the way the moment the user taps in.
    final showUnknown =
        _from != null &&
        _to != null &&
        suggested == null &&
        !_distanceFocus.hasFocus &&
        _distanceController.text.trim().isEmpty;
    final draft = _draftLeg;
    final fixed = widget.fixedOption;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            spacingLg,
            0,
            spacingLg,
            spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(transportGroupIcon(mode.group)),
                title: Text(
                  mode.name(locale),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(transportModeFactorLabel(l10n, mode)),
              ),
              if (bandSwitched)
                Padding(
                  padding: const EdgeInsets.only(bottom: spacingSm),
                  child: Text(
                    l10n.transportFlightBandNote(mode.name(locale)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              CityPairFields(
                from: _from,
                to: _to,
                onChanged: (from, to) => setState(() {
                  _from = from;
                  _to = to;
                  // A new pair supersedes the old estimate, never a
                  // distance the user typed themselves.
                  if (_distanceIsEstimate) _distanceController.clear();
                }),
              ),
              const SizedBox(height: spacingSm),
              TextField(
                controller: _distanceController,
                focusNode: _distanceFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [_distanceInputFormatter],
                decoration: InputDecoration(
                  labelText: l10n.transportDistanceLabel,
                  border: const OutlineInputBorder(),
                  // A hint sits behind the resting label, so it only
                  // renders once the label is floated out of the way.
                  hintText: showUnknown ? l10n.transportDistanceUnknown : null,
                  floatingLabelBehavior: showUnknown
                      ? FloatingLabelBehavior.always
                      : FloatingLabelBehavior.auto,
                  errorText: _distanceInvalid
                      ? l10n.transportDistanceInvalid
                      : null,
                  helperText: _distanceIsEstimate
                      ? l10n.transportDistanceEstimateNote
                      : null,
                ),
                onChanged: (_) => setState(() {
                  _distanceInvalid = false;
                  _distanceIsEstimate = false;
                }),
              ),
              if (mode.perVehicle) ...[
                const SizedBox(height: spacingSm),
                OccupancyStepper(
                  value: _occupants,
                  max: max(1, mode.maxOccupants),
                  onChanged: (occupants) =>
                      setState(() => _occupants = occupants),
                ),
              ],
              // The factor line above is per vehicle and never moves
              // with occupancy; this is where adding a passenger
              // visibly divides the leg's footprint.
              if (draft != null) ...[
                const SizedBox(height: spacingSm),
                Text(
                  l10n.calculatorEntryPreview(
                    formatCO2Compact(
                      TransportCalculator.legCo2eGrams(mode, draft).round(),
                    ),
                  ),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: spacingLg),
              if (fixed != null)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.buttonCancel),
                      ),
                    ),
                    const SizedBox(width: spacingMd),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _save(fixed),
                        child: Text(l10n.buttonSave),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _save(optionA),
                        child: Text(l10n.calculatorAddToA),
                      ),
                    ),
                    const SizedBox(width: spacingMd),
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _save(optionB),
                        child: Text(l10n.calculatorAddToB),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
