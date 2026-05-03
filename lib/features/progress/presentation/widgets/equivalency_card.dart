import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';

/// One tile in the equivalencies row: an icon, the formatted value,
/// and the localized unit label. Cards have a fixed width so the row
/// can scroll horizontally on narrow screens without rescaling.
class EquivalencyCard extends StatelessWidget {
  const EquivalencyCard({required this.equivalency, super.key});

  static const double width = 96;

  final ImpactEquivalency equivalency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: Radii.borderMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconFor(equivalency.type),
            size: 28,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            _formatValue(equivalency, locale),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            _labelFor(equivalency.type, l10n),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _iconFor(EquivalencyType type) => switch (type) {
        EquivalencyType.trees => Icons.park,
        EquivalencyType.carKm => Icons.directions_car_outlined,
        EquivalencyType.phoneCharges => Icons.battery_charging_full,
        EquivalencyType.burgers => Icons.lunch_dining,
      };

  String _labelFor(EquivalencyType type, AppLocalizations l10n) =>
      switch (type) {
        EquivalencyType.trees => l10n.equivTreesLabel,
        EquivalencyType.carKm => l10n.equivCarKmLabel,
        EquivalencyType.phoneCharges => l10n.equivPhoneChargesLabel,
        EquivalencyType.burgers => l10n.equivBurgersLabel,
      };

  // Trees can be sub-unit (e.g. 0.4) and read most clearly with one
  // decimal. Whole-unit equivalencies use locale-aware grouping
  // separators because they easily run into the thousands.
  String _formatValue(ImpactEquivalency eq, String locale) {
    if (eq.type == EquivalencyType.trees) {
      return NumberFormat('#,##0.0', locale).format(eq.value);
    }
    return NumberFormat.decimalPattern(locale).format(eq.value.round());
  }
}
