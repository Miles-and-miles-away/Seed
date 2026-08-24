import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';

/// Per-mascot stats card ("Our Journey"). Each stat is derived from the
/// mascot itself (`createdAt`, `co2SavedGrams`), so it stays correct when
/// the user switches between mascots they are raising one at a time.
class MascotStatsCard extends StatelessWidget {
  const MascotStatsCard({required this.mascot, super.key});

  static const _statPlaceholder = '--';

  final MascotModel mascot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final createdAt = mascot.createdAt;
    final birthdayText = createdAt != null
        ? DateFormat.yMMMd(locale).format(createdAt)
        : _statPlaceholder;
    final daysTogether = createdAt != null ? _daysTogether(createdAt) : 0;

    return Container(
      padding: const EdgeInsets.all(spacingLg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.mascotStatsTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingMd),
          _buildStatRow(
            Icons.cake_outlined,
            l10n.mascotStatBirthday,
            birthdayText,
            theme,
            colorScheme,
          ),
          const SizedBox(height: spacingMd),
          _buildStatRow(
            Icons.favorite_outline,
            l10n.mascotStatDaysTogether,
            '$daysTogether',
            theme,
            colorScheme,
          ),
          const SizedBox(height: spacingMd),
          _buildStatRow(
            Icons.eco_outlined,
            l10n.mascotStatCo2Together,
            formatCO2Compact(mascot.co2SavedGrams),
            theme,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: spacingMd),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Days the user and mascot have been together, counting the birthday
  /// as day 1. Uses date-only values so partial days do not skew the count.
  int _daysTogether(DateTime birthday) {
    final now = DateTime.now();
    final start = DateTime(birthday.year, birthday.month, birthday.day);
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(start).inDays + 1;
  }
}
