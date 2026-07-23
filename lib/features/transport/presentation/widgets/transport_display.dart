import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';

/// Icon for a transport mode group (dataset `group` values).
IconData transportGroupIcon(String group) => switch (group) {
  'active' => Icons.directions_walk,
  'micro' => Icons.electric_scooter,
  'car' => Icons.directions_car,
  'bus' => Icons.directions_bus,
  'taxi' => Icons.local_taxi,
  'rail' => Icons.train,
  'water' => Icons.directions_boat,
  'air' => Icons.flight,
  'high_impact' => Icons.flight_takeoff,
  _ => Icons.commute,
};

/// Localized label for a transport mode group. Unknown groups fall
/// back to the raw id so a dataset addition degrades readably.
String transportGroupLabel(AppLocalizations l10n, String group) =>
    switch (group) {
      'active' => l10n.transportGroupActive,
      'micro' => l10n.transportGroupMicro,
      'car' => l10n.transportGroupCar,
      'bus' => l10n.transportGroupBus,
      'taxi' => l10n.transportGroupTaxi,
      'rail' => l10n.transportGroupRail,
      'water' => l10n.transportGroupWater,
      'air' => l10n.transportGroupAir,
      'high_impact' => l10n.transportGroupHighImpact,
      _ => group,
    };

/// Localized emission-factor line for a mode row, stating the
/// per-vehicle vs per-passenger basis (honest-not-generous rule).
String transportModeFactorLabel(AppLocalizations l10n, TransportMode mode) {
  final grams = mode.gCo2ePerKm.round();
  return mode.perVehicle
      ? l10n.transportModeFactorPerVehicle(grams)
      : l10n.transportModeFactorPerPassenger(grams);
}

/// Binding data-honesty sublabel for a mode, or null when the mode
/// needs no caveat (data review 2026-07-17/18). Shown on comparison
/// bars and in the per-mode science sheet:
/// - electric car: the 73 g/km factor is grid-dependent;
/// - private jet: the 1,700 g/pkm includes the same radiative-forcing
///   uplift as the airline factors, so the comparison is like-for-like;
/// - active/micro modes: their zero-direct or electricity-only basis.
String? transportModeBasisNote(AppLocalizations l10n, TransportMode mode) {
  if (mode.id == 'car_bev') return l10n.transportBasisEvGrid;
  if (mode.id == 'private_jet') return l10n.transportBasisJetRf;
  if (mode.group == 'active' || mode.group == 'micro') {
    return mode.gCo2ePerKm == 0
        ? l10n.transportBasisZeroDirect
        : l10n.transportBasisElectricityOnly;
  }
  return null;
}

/// Short label for a comparison option: the group of its dominant
/// (longest) leg, so "Fly" vs "Rail" reads at a glance. Empty legs
/// yield an empty string (guarded by the caller, which never stages
/// an empty journey).
String journeyOptionLabel(
  AppLocalizations l10n,
  List<JourneyLeg> legs,
  Map<String, TransportMode> modesById,
) {
  if (legs.isEmpty) return '';
  var dominant = legs.first;
  for (final leg in legs) {
    if (leg.distanceKm > dominant.distanceKm) dominant = leg;
  }
  final mode = modesById[dominant.modeId];
  return mode == null ? '' : transportGroupLabel(l10n, mode.group);
}

/// Compact km display: whole values drop the decimal. Locale-aware
/// (grouping and decimal separators), so display only -- never feed
/// the result back into a parseable text field.
String formatKmCompact(double km, String locale) {
  final isWhole = km == km.roundToDouble();
  return isWhole
      ? NumberFormat.decimalPattern(locale).format(km.round())
      : NumberFormat('#,##0.0', locale).format(km);
}
