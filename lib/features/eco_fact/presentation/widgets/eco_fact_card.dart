import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

/// Card displaying an eco-fact with source, category chip,
/// and related SDG icons. Supports a locked state for future
/// challenge integration.
class EcoFactCard extends ConsumerWidget {
  const EcoFactCard({required this.fact, this.isLocked = false, super.key});

  final EcoFact fact;
  final bool isLocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final goalMap = ref.watch(sdgGoalsDataProvider).value?.goalMap ?? {};

    if (isLocked) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(spacingXxl),
          child: Column(
            children: [
              Icon(
                Icons.lock_outline,
                size: spacingHuge,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: spacingMd),
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
        padding: const EdgeInsets.all(spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category chip
            _CategoryChip(category: fact.category, l10n: l10n),
            const SizedBox(height: spacingLg),

            // "Did you know?" header
            Text(
              l10n.ecoFactDidYouKnow,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: spacingSm),

            // Fact text
            Text(fact.fact(locale), style: theme.textTheme.bodyLarge),
            const SizedBox(height: spacingLg),

            // Source (name itself is the link when a URL is present)
            _SourceLine(
              sourceName: fact.source(locale),
              sourceUrl: fact.sourceUrl,
            ),

            // UN World Day badge
            if (fact.unWorldDay != null) ...[
              const SizedBox(height: spacingMd),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: borderRadiusMd,
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
              const SizedBox(height: spacingMd),
              _buildSdgBadges(fact.relatedSdgs, goalMap, locale, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSdgBadges(
    List<int> sdgNums,
    Map<int, SdgGoal> goalMap,
    String locale,
    ThemeData theme,
  ) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: sdgNums.map((sdgNum) {
        final goal = goalMap[sdgNum];
        if (goal == null) return const SizedBox();
        return Tooltip(
          message: goal.shortTitle(locale),
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
    );
  }
}

class _SourceLine extends StatefulWidget {
  const _SourceLine({required this.sourceName, required this.sourceUrl});

  final String sourceName;
  final String sourceUrl;

  @override
  State<_SourceLine> createState() => _SourceLineState();
}

class _SourceLineState extends State<_SourceLine> {
  TapGestureRecognizer? _recognizer;

  bool get _hasUrl => widget.sourceUrl.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_hasUrl) {
      _recognizer = TapGestureRecognizer()..onTap = _launchUrl;
    }
  }

  @override
  void dispose() {
    _recognizer?.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() => openExternalUrl(context, widget.sourceUrl);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final baseStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.menu_book_outlined,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: baseStyle,
              children: [
                TextSpan(text: '${l10n.ecoFactSource}: '),
                if (_hasUrl)
                  TextSpan(
                    text: '${widget.sourceName} $externalLinkChar',
                    style: baseStyle?.copyWith(
                      color: colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: colorScheme.primary,
                    ),
                    recognizer: _recognizer,
                  )
                else
                  TextSpan(text: widget.sourceName),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category, required this.l10n});

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: spacingXs),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: borderRadiusMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.secondary),
          const SizedBox(width: spacingXs),
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
