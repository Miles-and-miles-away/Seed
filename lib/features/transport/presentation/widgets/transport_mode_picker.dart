import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/journey_distance.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';
import 'package:seed_app/shared/widgets/group_heading.dart';

/// Grouped transport mode list for the leg editor.
///
/// Groups render in dataset order. When a city-pair [suggestions] map
/// is provided, modes eligible for a prefill show the estimated
/// distance; every mode stays selectable either way, with manual
/// distance entry. Each tile carries an info button opening the
/// per-mode science sheet (8.4).
class TransportModePicker extends StatelessWidget {
  const TransportModePicker({
    required this.modes,
    required this.onSelected,
    required this.onInfo,
    this.suggestions,
    this.flightBandId,
    super.key,
  });

  /// All modes, in dataset order.
  final List<TransportMode> modes;

  /// Called with the picked mode and its prefill estimate, if any.
  final void Function(TransportMode mode, double? suggestedKm) onSelected;

  /// Opens the per-mode science sheet.
  final void Function(TransportMode mode) onInfo;

  /// Suggested distances per journey kind from `suggestedDistancesKm`
  /// (threaded through `citySuggestionsProvider`), or null when no
  /// city pair is selected.
  final Map<String, double>? suggestions;

  /// The honest flight band for the selected city pair (8.3). When
  /// set, only that air-group mode is offered -- suggesting a
  /// long-haul factor for a short hop would be dishonest. Null (no
  /// city pair) leaves every flight band manually selectable.
  final String? flightBandId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final band = flightBandId;
    final groups = <String, List<TransportMode>>{};
    for (final mode in modes) {
      // With a city pair, hide the flight bands that do not match the
      // auto-picked one so the user cannot stage a dishonest option.
      if (band != null && mode.group == 'air' && mode.id != band) continue;
      groups.putIfAbsent(mode.group, () => []).add(mode);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in groups.entries) ...[
          GroupHeading(transportGroupLabel(l10n, entry.key)),
          for (final mode in entry.value)
            _ModeTile(
              mode: mode,
              suggestedKm: suggestions == null
                  ? null
                  : prefillKmForMode(mode, suggestions!),
              onSelected: onSelected,
              onInfo: onInfo,
            ),
        ],
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.suggestedKm,
    required this.onSelected,
    required this.onInfo,
  });

  final TransportMode mode;
  final double? suggestedKm;
  final void Function(TransportMode mode, double? suggestedKm) onSelected;
  final void Function(TransportMode mode) onInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final km = suggestedKm;
    return ListTile(
      leading: Icon(transportGroupIcon(mode.group)),
      title: Text(mode.name(locale)),
      subtitle: Text(transportModeFactorLabel(l10n, mode)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (km != null)
            Flexible(
              child: Text(
                l10n.transportEstimatedKm(
                  NumberFormat.decimalPattern(locale).format(km.round()),
                ),
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.transportModeScienceTooltip,
            onPressed: () => onInfo(mode),
          ),
        ],
      ),
      onTap: () => onSelected(mode, km),
    );
  }
}
