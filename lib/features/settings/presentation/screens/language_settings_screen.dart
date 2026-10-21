import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';
import '../providers/language_sync_provider.dart';
import '../providers/settings_providers.dart';
import '../widgets/language_tile.dart';

/// Screen for selecting the app language, with live switching.
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.languageSettingsTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(spacingLg),
              child: PhraseText(
                l10n.languageSettingsDescription,
                minLineWidth: phraseNarrowestScreenWidth - 2 * spacingLg,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Divider(height: 1),
            for (final language in supportedLanguages)
              LanguageTile(
                language: language,
                isSelected: currentLanguage == language.code,
                onTap: () => ref
                    .read(languageSyncProvider.notifier)
                    .choose(language.code),
              ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(spacingLg),
              child: PhraseText(
                l10n.languageSettingsNote,
                minLineWidth: phraseNarrowestScreenWidth - 2 * spacingLg,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
