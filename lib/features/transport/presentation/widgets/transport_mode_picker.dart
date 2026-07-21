import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/journey_distance.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';

// TODO(phase8): 8.4 adds a per-mode info icon opening the science
// bottom sheet (factor, basis, calculation notes, sources). Binding
// UI requirements recorded for the 8.3/8.4 comparison and detail
// views: the electric car row carries a "global-average grid; varies
// with your electricity" sublabel, the private jet a radiative-
// forcing footnote, and active modes show their electricity-only
// basis (project data-honesty rules).

/// Grouped transport mode list for the leg editor.
///
/// Groups render in dataset order. When a city-pair [suggestions] map
/// is provided, modes eligible for a prefill show the estimated
/// distance; every mode stays selectable either way, with manual
/// distance entry.
class TransportModePicker extends StatelessWidget {
  const TransportModePicker({
    required this.modes,
    required this.onSelected,
    this.suggestions,
    super.key,
  });

  /// All modes, in dataset order.
  final List<TransportMode> modes;

  /// Called with the picked mode and its prefill estimate, if any.
  final void Function(TransportMode mode, double? suggestedKm) onSelected;

  /// Suggested distances per journey kind from `suggestedDistancesKm`
  /// (threaded through `citySuggestionsProvider`), or null when no
  /// city pair is selected.
  final Map<String, double>? suggestions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final groups = <String, List<TransportMode>>{};
    for (final mode in modes) {
      groups.putIfAbsent(mode.group, () => []).add(mode);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              spacingLg,
              spacingMd,
              spacingLg,
              0,
            ),
            child: Text(
              transportGroupLabel(l10n, entry.key),
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          for (final mode in entry.value)
            _ModeTile(
              mode: mode,
              suggestedKm: suggestions == null
                  ? null
                  : prefillKmForMode(mode, suggestions!),
              onSelected: onSelected,
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
  });

  final TransportMode mode;
  final double? suggestedKm;
  final void Function(TransportMode mode, double? suggestedKm) onSelected;

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
      trailing: km == null
          ? null
          : Text(
              l10n.transportEstimatedKm(
                NumberFormat.decimalPattern(locale).format(km.round()),
              ),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
      onTap: () => onSelected(mode, km),
    );
  }
}
