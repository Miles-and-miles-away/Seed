import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/transport_calculator.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';

/// One leg row in the journey builder: mode, distance, occupancy,
/// and the leg's CO2e. Displayed only -- never converted to points
/// or logged savings (No Fake Points).
class JourneyLegCard extends StatelessWidget {
  const JourneyLegCard({
    required this.leg,
    required this.mode,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  /// The leg to display.
  final JourneyLeg leg;

  /// The leg's resolved transport mode.
  final TransportMode mode;

  /// Opens the leg editor.
  final VoidCallback onTap;

  /// Removes the leg from the journey.
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final grams = TransportCalculator.legCo2eGrams(mode, leg);
    final details = [
      l10n.transportKmValue(formatKmCompact(leg.distanceKm, locale)),
      if (mode.perVehicle) l10n.transportOccupantsValue(leg.occupants),
    ].join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: spacingSm),
      child: ListTile(
        leading: Icon(
          transportGroupIcon(mode.group),
          color: theme.colorScheme.primary,
        ),
        title: Text(mode.name(locale)),
        subtitle: Text(details),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatCO2Compact(grams.round()),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.transportRemoveLeg,
              onPressed: onRemove,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
