import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/transport/data/models/city_model.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/features/transport/presentation/widgets/city_pair_fields.dart';
import 'package:seed_app/features/transport/presentation/widgets/occupancy_stepper.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_mode_picker.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

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

/// Bottom sheet for adding or editing a journey leg.
///
/// Two steps in one sheet: a grouped mode picker with optional
/// city-pair distance estimates, then the distance/occupancy form.
/// Pops with the resulting [JourneyLeg], or null when dismissed.
class LegEditorSheet extends ConsumerStatefulWidget {
  const LegEditorSheet({this.initialLeg, this.initialMode, super.key});

  /// Leg being edited, or null when adding a new one.
  final JourneyLeg? initialLeg;

  /// Resolved mode of [initialLeg]; skips the picker step when set.
  final TransportMode? initialMode;

  /// Shows the sheet modally, mirroring the app's bottom-sheet
  /// conventions (drag handle, rounded top corners).
  static Future<JourneyLeg?> show(
    BuildContext context, {
    JourneyLeg? initialLeg,
    TransportMode? initialMode,
  }) {
    return showModalBottomSheet<JourneyLeg>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) =>
          LegEditorSheet(initialLeg: initialLeg, initialMode: initialMode),
    );
  }

  @override
  ConsumerState<LegEditorSheet> createState() => _LegEditorSheetState();
}

class _LegEditorSheetState extends ConsumerState<LegEditorSheet> {
  final _distanceController = TextEditingController();
  TransportMode? _mode;
  int _occupants = 1;
  City? _fromCity;
  City? _toCity;
  bool _distanceIsEstimate = false;
  bool _distanceInvalid = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    final leg = widget.initialLeg;
    if (leg != null) {
      _distanceController.text = _distanceSeedText(leg.distanceKm);
      _occupants = leg.occupants;
    }
  }

  @override
  void dispose() {
    _distanceController.dispose();
    super.dispose();
  }

  void _selectMode(TransportMode mode, double? suggestedKm) {
    setState(() {
      _mode = mode;
      _occupants = _occupants.clamp(1, max(1, mode.maxOccupants));
      _distanceInvalid = false;
      // Prefill only when it would not overwrite a manual entry; an
      // unedited estimate from a previously picked mode is fair game.
      final canPrefill =
          _distanceController.text.trim().isEmpty || _distanceIsEstimate;
      if (suggestedKm != null && canPrefill) {
        _distanceController.text = suggestedKm.round().toString();
        _distanceIsEstimate = true;
      } else if (suggestedKm == null) {
        // A leftover flag would mislabel the field as an estimate
        // for a mode the pair never suggested one for.
        _distanceIsEstimate = false;
      }
    });
  }

  void _save() {
    final mode = _mode;
    if (mode == null) return;
    // Locale keypads emit ',' as the decimal separator; normalize
    // before parsing so "12,5" reads as 12.5.
    final text = _distanceController.text.trim().replaceAll(',', '.');
    final km = double.tryParse(text);
    // tryParse accepts "NaN" and "Infinity"; reject those too.
    if (km == null || km.isNaN || km.isInfinite || km < 0) {
      setState(() => _distanceInvalid = true);
      return;
    }
    Navigator.pop(
      context,
      JourneyLeg(
        modeId: mode.id,
        distanceKm: km,
        occupants: mode.perVehicle ? _occupants : 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modesAsync = ref.watch(transportModesProvider);
    final mode = _mode;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: modesAsync.when(
          data: (modes) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              spacingLg,
              0,
              spacingLg,
              spacingLg,
            ),
            child: mode == null ? _buildModeStep(modes) : _buildFormStep(mode),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(spacingXxl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const Padding(
            padding: EdgeInsets.all(spacingXxl),
            child: Center(child: ErrorDisplay()),
          ),
        ),
      ),
    );
  }

  Widget _buildModeStep(List<TransportMode> modes) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final from = _fromCity;
    final to = _toCity;
    Map<String, double>? suggestions;
    if (from != null && to != null) {
      // citySuggestionsProvider threads the water-blocked pair set
      // (review requirement); never call suggestedDistancesKm directly here.
      suggestions = ref.watch(citySuggestionsProvider(from, to)).value;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.transportSelectMode,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: spacingMd),
        CityPairFields(
          from: from,
          to: to,
          onChanged: (newFrom, newTo) => setState(() {
            _fromCity = newFrom;
            _toCity = newTo;
          }),
        ),
        TransportModePicker(
          modes: modes,
          suggestions: suggestions,
          onSelected: _selectMode,
        ),
      ],
    );
  }

  Widget _buildFormStep(TransportMode mode) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.initialLeg == null
              ? l10n.transportAddLeg
              : l10n.transportEditLeg,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: spacingMd),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(transportGroupIcon(mode.group)),
          title: Text(mode.name(locale)),
          subtitle: Text(transportModeFactorLabel(l10n, mode)),
          trailing: TextButton(
            onPressed: () => setState(() => _mode = null),
            child: Text(l10n.transportChangeMode),
          ),
        ),
        const SizedBox(height: spacingSm),
        TextField(
          controller: _distanceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [_distanceInputFormatter],
          decoration: InputDecoration(
            labelText: l10n.transportDistanceLabel,
            border: const OutlineInputBorder(),
            errorText: _distanceInvalid ? l10n.transportDistanceInvalid : null,
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
            onChanged: (occupants) => setState(() => _occupants = occupants),
          ),
        ],
        const SizedBox(height: spacingLg),
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
                onPressed: _save,
                child: Text(l10n.buttonSave),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
