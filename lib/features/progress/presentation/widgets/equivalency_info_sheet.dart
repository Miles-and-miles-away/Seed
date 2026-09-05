import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_display.dart';

const double _kMaxChildSize = 0.9;
const double _kMinChildSize = 0.4;

/// Bottom sheet explaining how each equivalency on the Impact
/// dashboard is computed: short plain-language explainer, a
/// prominent tappable source link, and the exact formula. Conversion
/// factors and source URLs come from
/// `data/app/impact_equivalencies.json` via
/// [impactEquivalenciesDataProvider]; explainer copy is localized in
/// the ARB files. Reached via the info icon next to the
/// "Equivalent to" header.
class EquivalencyInfoSheet extends ConsumerWidget {
  const EquivalencyInfoSheet({super.key});

  /// Shows the sheet modally over its parent. Mirrors the
  /// [showModalBottomSheet] conventions used elsewhere in the app
  /// (drag handle, rounded top corners, scrollable inner content).
  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: sheetShape,
      builder: (_) => const EquivalencyInfoSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final metadataAsync = ref.watch(impactEquivalenciesDataProvider);

    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: _kMaxChildSize,
      minChildSize: _kMinChildSize,
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: spacingXxl,
                vertical: spacingSm,
              ),
              child: Text(
                l10n.impactInfoTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              // SingleChildScrollView + Column instead of ListView so
              // every explainer is laid out up front -- the sheet
              // initial height only shows the first 1-2 cards, but
              // tests (and screen readers) need to find them all
              // without scroll-driven lazy building.
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  spacingXxl,
                  spacingLg,
                  spacingXxl,
                  spacingXxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.impactInfoIntro,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: spacingLg),
                    ...metadataAsync.when(
                      data: (metadata) => [
                        for (final m in metadata)
                          _EquivalencyExplainer(metadata: m, locale: locale),
                      ],
                      loading: () => const [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: spacingXl),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                      error: (_, _) => const [SizedBox.shrink()],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EquivalencyExplainer extends StatelessWidget {
  const _EquivalencyExplainer({required this.metadata, required this.locale});

  final EquivalencyMetadata metadata;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final formattedFactor = NumberFormat.decimalPattern(
      locale,
    ).format(metadata.gramsPerUnit);

    return Padding(
      padding: const EdgeInsets.only(bottom: spacingLg),
      child: Container(
        padding: const EdgeInsets.all(spacingLg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: borderRadiusMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  metadata.type.icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: spacingSm),
                Expanded(
                  child: Text(
                    metadata.type.label(l10n),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacingSm),
            Text(
              _explainerFor(metadata.type, l10n),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: spacingMd),
            // Source tile lives directly under the explainer (not
            // under the formula) so the credibility link is adjacent
            // to the claim it backs.
            _SourceLinkTile(
              label: l10n.impactInfoSourceLabel,
              sourceName: metadata.sourceName,
              onTap: () => openExternalUrl(context, metadata.sourceUrl),
            ),
            const SizedBox(height: spacingSm),
            _LabeledLine(
              label: l10n.impactInfoFormulaLabel,
              value: l10n.equivFormulaTemplate(formattedFactor),
            ),
          ],
        ),
      ),
    );
  }

  String _explainerFor(EquivalencyType type, AppLocalizations l10n) =>
      switch (type) {
        EquivalencyType.trees => l10n.equivTreesExplainer,
        EquivalencyType.carKm => l10n.equivCarKmExplainer,
        EquivalencyType.phoneCharges => l10n.equivPhoneChargesExplainer,
        EquivalencyType.burgers => l10n.equivBurgersExplainer,
      };
}

/// Prominent tappable tile that opens the source URL externally.
/// Distinct from [_LabeledLine] -- this is the headline citation
/// for each equivalency and needs to read unambiguously as a link.
class _SourceLinkTile extends StatelessWidget {
  const _SourceLinkTile({
    required this.label,
    required this.sourceName,
    required this.onTap,
  });

  final String label;
  final String sourceName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final linkColor = theme.colorScheme.primary;
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: borderRadiusSm,
      child: InkWell(
        borderRadius: borderRadiusSm,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          child: Row(
            children: [
              Icon(Icons.menu_book_outlined, size: 18, color: linkColor),
              const SizedBox(width: spacingSm),
              Expanded(
                child: Text(
                  '$label: $sourceName $externalLinkChar',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: linkColor,
                    decoration: TextDecoration.underline,
                    decorationColor: linkColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single "Label: value" line used for the formula row. Keeps prefix
/// typography consistent.
class _LabeledLine extends StatelessWidget {
  const _LabeledLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$label: ',
          style: base?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(value, style: base?.copyWith(fontFamily: 'monospace')),
      ],
    );
  }
}
