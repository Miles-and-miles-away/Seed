import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_display.dart';

/// One tile in the equivalencies row: an icon, the formatted value,
/// and the localized unit label. Width is dictated by the parent row,
/// which flexes all four cards equally to fit the screen; the value's
/// FittedBox and the label's ellipsis keep narrow cards legible.
class EquivalencyCard extends StatelessWidget {
  const EquivalencyCard({required this.equivalency, super.key});

  final ImpactEquivalency equivalency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: spacingSm,
        vertical: spacingMd,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: borderRadiusMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            equivalency.type.icon,
            size: 28,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: spacingXs),
          // Value is the focal element; never let it wrap. Large
          // all-time totals (e.g. "23,000" phone charges) get scaled
          // down to fit the card width rather than breaking onto two
          // lines.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _formatValue(equivalency, locale),
              maxLines: 1,
              softWrap: false,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: spacingXxs),
          // Labels can be multi-word ("km not driven", "phone
          // charges") -- cap at two lines with ellipsis so the card
          // height stays bounded on every locale.
          Text(
            equivalency.type.label(l10n),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Trees can be sub-unit (e.g. 0.4) and read most clearly with one
  // decimal. Whole-unit equivalencies use locale-aware grouping
  // separators because they easily run into the thousands.
  //
  // Floors: any positive value that would round to "0" / "0.0" gets
  // a "<1" / "<0.1" sentinel instead -- a real action shouldn't read
  // as no impact at all.
  String _formatValue(ImpactEquivalency eq, String locale) {
    if (eq.type == EquivalencyType.trees) {
      if (eq.value > 0 && eq.value < 0.05) return '<0.1';
      return NumberFormat('#,##0.0', locale).format(eq.value);
    }
    if (eq.value > 0 && eq.value < 0.5) return '<1';
    return NumberFormat.decimalPattern(locale).format(eq.value.round());
  }
}
