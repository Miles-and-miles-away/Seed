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

/// Every distinct mode in a journey, in order, joined for the banked
/// action name ("Train + Bus"). Occupancy is appended to a shared
/// vehicle so drive-alone and carpool stay distinguishable.
///
/// Used only where the journey has to describe itself outside the
/// two-column screen -- chiefly the logged custom action, which lands
/// in the action history with no columns around it. On screen the
/// options are named "Option A" / "Option B"; naming a single
/// dominant leg there read as an arbitrary pick from the list.
String journeySummaryLabel(
  AppLocalizations l10n,
  List<JourneyLeg> legs,
  Map<String, TransportMode> modesById,
  String locale,
) {
  final parts = <String>[];
  for (final leg in legs) {
    final mode = modesById[leg.modeId];
    if (mode == null) continue;
    final name = (mode.perVehicle && leg.occupants > 1)
        ? '${mode.name(locale)} · ${l10n.transportOccupantsValue(leg.occupants)}'
        : mode.name(locale);
    if (!parts.contains(name)) parts.add(name);
  }
  return parts.join(' + ');
}

/// Short label for a comparison option: the mode of its dominant
/// (longest) leg, plus occupancy when the vehicle is shared.
///
/// Retained for the per-mode ordering it gives the analytics event;
/// user-facing copy uses [journeySummaryLabel] or the column names.
String journeyOptionLabel(
  AppLocalizations l10n,
  List<JourneyLeg> legs,
  Map<String, TransportMode> modesById,
  String locale,
) {
  if (legs.isEmpty) return '';
  var dominant = legs.first;
  for (final leg in legs) {
    if (leg.distanceKm > dominant.distanceKm) dominant = leg;
  }
  final mode = modesById[dominant.modeId];
  if (mode == null) return '';
  final name = mode.name(locale);
  return (mode.perVehicle && dominant.occupants > 1)
      ? '$name · ${l10n.transportOccupantsValue(dominant.occupants)}'
      : name;
}

/// Compact km display: whole values drop the decimal. Locale-aware
/// (grouping and decimal separators), so display only -- never feed
/// the result back into a parseable text field.
String formatKmCompact(double km, String locale) => km == km.roundToDouble()
    ? NumberFormat.decimalPattern(locale).format(km.round())
    : NumberFormat('#,##0.0', locale).format(km);
