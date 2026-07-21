import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
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

/// Compact km display: whole values drop the decimal. Locale-aware
/// (grouping and decimal separators), so display only -- never feed
/// the result back into a parseable text field.
String formatKmCompact(double km, String locale) {
  final isWhole = km == km.roundToDouble();
  return isWhole
      ? NumberFormat.decimalPattern(locale).format(km.round())
      : NumberFormat('#,##0.0', locale).format(km);
}
