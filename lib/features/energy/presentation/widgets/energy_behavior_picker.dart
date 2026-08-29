import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';

/// Grouped energy behavior list for the routine builder (Phase 8.14).
///
/// No search field, matching the transport picker: 33 behaviors across
/// ten headings all fit a scroll, and the group headings are the way
/// people look for them ("hot water", "laundry"). Each tile carries an
/// info button opening the per-behavior science sheet.
class EnergyBehaviorPicker extends StatelessWidget {
  const EnergyBehaviorPicker({
    required this.behaviors,
    required this.onSelected,
    required this.onInfo,
    this.recentIds = const [],
    super.key,
  });

  /// All behaviors, in dataset order.
  final List<EnergyBehavior> behaviors;

  final void Function(EnergyBehavior behavior) onSelected;
  final void Function(EnergyBehavior behavior) onInfo;

  /// Ids picked earlier this session, most recent first.
  final List<String> recentIds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final byId = {for (final b in behaviors) b.id: b};
    final recents = [
      for (final id in recentIds)
        if (byId[id] != null) byId[id]!,
    ];
    final groups = <String, List<EnergyBehavior>>{};
    for (final behavior in behaviors) {
      groups.putIfAbsent(behavior.comparableGroup, () => []).add(behavior);
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (recents.isNotEmpty) ...[
          _GroupHeading(label: l10n.energyPickerRecents),
          for (final behavior in recents)
            _BehaviorTile(
              behavior: behavior,
              onSelected: onSelected,
              onInfo: onInfo,
            ),
        ],
        for (final entry in groups.entries) ...[
          _GroupHeading(label: energyGroupLabel(l10n, entry.key)),
          for (final behavior in entry.value)
            _BehaviorTile(
              behavior: behavior,
              onSelected: onSelected,
              onInfo: onInfo,
            ),
        ],
      ],
    );
  }
}

class _GroupHeading extends StatelessWidget {
  const _GroupHeading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(spacingLg, spacingMd, spacingLg, 0),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _BehaviorTile extends StatelessWidget {
  const _BehaviorTile({
    required this.behavior,
    required this.onSelected,
    required this.onInfo,
  });

  final EnergyBehavior behavior;
  final void Function(EnergyBehavior behavior) onSelected;
  final void Function(EnergyBehavior behavior) onInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return ListTile(
      leading: Icon(energyGroupIcon(behavior.comparableGroup)),
      title: Text(behavior.name(locale)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(energyBehaviorFactorLabel(l10n, behavior)),
          // The two weakest figures in the dataset say so on their own
          // row rather than only in the science sheet (PDR section 5,
          // rules 6 and 21).
          if (behavior.isLowConfidence)
            Text(
              l10n.energyLowConfidenceNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
      isThreeLine: behavior.isLowConfidence,
      trailing: IconButton(
        icon: const Icon(Icons.info_outline),
        tooltip: l10n.energyBehaviorScienceTooltip,
        onPressed: () => onInfo(behavior),
      ),
      onTap: () => onSelected(behavior),
    );
  }
}
