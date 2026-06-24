import 'package:flutter/material.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_image.dart';

const double _sheetImageSize = 160;

/// Bottom sheet showing a discovered entry's full details.
class EcoDexEntrySheet extends StatelessWidget {
  const EcoDexEntrySheet({
    required this.entry,
    required this.locale,
    super.key,
  });

  final EcoDexEntry entry;
  final String locale;

  /// Opens the sheet with the standard modal configuration.
  static Future<void> show(
    BuildContext context, {
    required EcoDexEntry entry,
    required String locale,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusXl),
        ),
      ),
      builder: (_) => EcoDexEntrySheet(entry: entry, locale: locale),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        spacingXxl,
        spacingSm,
        spacingXxl,
        spacingXxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entry artwork
          Center(
            child: EcoDexEntryImage(
              iconName: entry.iconName,
              size: _sheetImageSize,
            ),
          ),
          const SizedBox(height: spacingXl),

          // Title
          Text(
            entry.name(locale),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingLg),

          // Fact
          Text(
            entry.fact(locale),
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: spacingLg),

          // Source
          if (entry.sourceUrl.isNotEmpty)
            GestureDetector(
              onTap: () => _openSource(context),
              child: Text(
                '${l10n.ecoDexViewSource} $externalLinkChar',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openSource(BuildContext context) =>
      openExternalUrl(context, entry.sourceUrl);
}
