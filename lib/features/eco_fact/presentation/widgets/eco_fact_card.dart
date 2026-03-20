import 'package:flutter/material.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:url_launcher/url_launcher.dart';

/// Card displaying an eco-fact with source, category chip,
/// and related SDG icons. Supports a locked state for future
/// challenge integration.
class EcoFactCard extends StatelessWidget {
  const EcoFactCard({
    required this.fact,
    this.isLocked = false,
    super.key,
  });

  final EcoFact fact;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    if (isLocked) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.lock_outline,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.ecoFactLocked,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category chip
            _CategoryChip(
              category: fact.category,
              l10n: l10n,
            ),
            const SizedBox(height: 16),

            // "Did you know?" header
            Text(
              l10n.ecoFactDidYouKnow,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Fact text
            Text(
              fact.getFact(locale),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Source
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${l10n.ecoFactSource}: '
                    '${fact.getSource(locale)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            // Source URL link
            if (fact.sourceUrl.isNotEmpty) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: GestureDetector(
                  onTap: () => _launchUrl(fact.sourceUrl),
                  child: Text(
                    l10n.sdgResources,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],

            // UN World Day badge
            if (fact.unWorldDay != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  fact.unWorldDay!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],

            // Related SDGs
            if (fact.relatedSdgs.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: fact.relatedSdgs.map((sdgNum) {
                  final goal = sdgGoalMap[sdgNum];
                  if (goal == null) return const SizedBox();
                  return Tooltip(
                    message: goal.getShortTitle(locale),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: goal.color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$sdgNum',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.l10n,
  });

  final String category;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final label = switch (category) {
      'comparison' => l10n.ecoFactCategoryComparison,
      'individual' => l10n.ecoFactCategoryIndividual,
      'mythBuster' => l10n.ecoFactCategoryMythBuster,
      'natureWonder' => l10n.ecoFactCategoryNatureWonder,
      'positiveNews' => l10n.ecoFactCategoryPositiveNews,
      _ => category,
    };

    final icon = switch (category) {
      'comparison' => Icons.compare_arrows,
      'individual' => Icons.person_outline,
      'mythBuster' => Icons.lightbulb_outline,
      'natureWonder' => Icons.park_outlined,
      'positiveNews' => Icons.celebration_outlined,
      _ => Icons.eco,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.secondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
