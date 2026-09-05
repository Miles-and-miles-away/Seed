import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';

/// Icon and localized unit label for each equivalency type, shared by
/// the dashboard card and the info sheet.
extension EquivalencyTypeDisplay on EquivalencyType {
  IconData get icon => switch (this) {
    EquivalencyType.trees => Icons.park,
    EquivalencyType.carKm => Icons.directions_car_outlined,
    EquivalencyType.phoneCharges => Icons.battery_charging_full,
    EquivalencyType.burgers => Icons.lunch_dining,
  };

  String label(AppLocalizations l10n) => switch (this) {
    EquivalencyType.trees => l10n.equivTreesLabel,
    EquivalencyType.carKm => l10n.equivCarKmLabel,
    EquivalencyType.phoneCharges => l10n.equivPhoneChargesLabel,
    EquivalencyType.burgers => l10n.equivBurgersLabel,
  };
}
