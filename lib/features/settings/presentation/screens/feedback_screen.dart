import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/presentation/feedback_category.dart';
import 'package:seed_app/features/settings/presentation/feedback_mailto.dart';
import 'package:seed_app/shared/providers/package_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Visible separator between metadata key/value pairs in the footer chip row.
const String _metadataSeparator = ' · ';

/// Structured feedback form. Collects category + description, then launches
/// the user's mail client with a pre-populated [mailto] URI tagged with app
/// + device metadata.
class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  FeedbackCategory _selectedCategory = FeedbackCategory.bug;
  bool _submitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _submitting = true);

    var launched = false;
    try {
      final pkgInfo = await ref.read(packageInfoProvider.future);
      if (!mounted) return;

      final locale = Localizations.localeOf(context).toLanguageTag();
      final uid = ref.read(firebaseAuthProvider).currentUser?.uid;

      final uri = buildFeedbackMailto(
        category: _selectedCategory,
        categoryLabel: _selectedCategory.label(l10n),
        description: _descriptionController.text,
        appVersion: pkgInfo.version,
        buildNumber: pkgInfo.buildNumber,
        platform: Platform.operatingSystem,
        osVersion: Platform.operatingSystemVersion,
        locale: locale,
        userId: uid,
      );

      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      // Covers PlatformException from launchUrl and a failed package-info
      // read; both fall through to the feedbackMailFailed snackbar.
      launched = false;
    } finally {
      // Always release the spinner, even on an unexpected throw.
      if (mounted) setState(() => _submitting = false);
    }

    if (!mounted) return;

    if (launched) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackThanks)));
      navigator.pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackMailFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final pkgAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.feedbackTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(spacingLg),
          children: [
            _CategorySection(
              selected: _selectedCategory,
              onChanged: (cat) => setState(() => _selectedCategory = cat),
            ),
            const SizedBox(height: spacingXxl),
            Text(
              l10n.feedbackDescriptionLabel,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: spacingSm),
            TextField(
              controller: _descriptionController,
              maxLines: 8,
              minLines: 5,
              maxLength: feedbackDescriptionMaxLength,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: l10n.feedbackDescriptionHint,
                border: OutlineInputBorder(borderRadius: borderRadiusMd),
              ),
            ),
            const SizedBox(height: spacingXxl),
            _MetadataFooter(packageInfo: pkgAsync.value),
            const SizedBox(height: spacingXxl),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _descriptionController,
              builder: (context, value, _) {
                final canSubmit = value.text.trim().isNotEmpty && !_submitting;
                return FilledButton(
                  onPressed: canSubmit ? _handleSubmit : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(spacingHuge),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: spacingXl,
                          width: spacingXl,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.feedbackSubmit),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.selected, required this.onChanged});

  final FeedbackCategory selected;
  final ValueChanged<FeedbackCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.feedbackCategoryLabel, style: theme.textTheme.titleMedium),
        const SizedBox(height: spacingSm),
        Wrap(
          spacing: spacingSm,
          runSpacing: spacingSm,
          children: [
            for (final category in FeedbackCategory.values)
              ChoiceChip(
                label: Text(category.label(l10n)),
                selected: selected == category,
                onSelected: (isSelected) {
                  if (isSelected) onChanged(category);
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _MetadataFooter extends StatelessWidget {
  const _MetadataFooter({required this.packageInfo});

  final PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final version = packageInfo?.version ?? '...';
    final buildNumber = packageInfo?.buildNumber ?? '';
    final platform = Platform.operatingSystem;

    final parts = <String>[
      'App v${appVersionLabel(version, buildNumber)}',
      platform,
      locale,
    ];

    return Container(
      padding: const EdgeInsets.all(spacingMd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.feedbackMetadataNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: spacingXs),
          Text(
            parts.join(_metadataSeparator),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
