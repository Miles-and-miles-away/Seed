import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import '../providers/settings_providers.dart';

/// Languages offered in the picker, in display order. English is first so
/// [LanguageOption.nativeName] lookups can fall back to it for unknown codes.
const supportedLanguages = [
  LanguageOption(code: 'en', name: 'English', nativeName: 'English'),
  LanguageOption(code: 'es', name: 'Spanish', nativeName: 'Español'),
  LanguageOption(code: 'ja', name: 'Japanese', nativeName: '日本語'),
];

/// Screen for selecting the app language.
///
/// Supports English and Japanese with live switching.
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
              child: Text(
                l10n.languageSettingsDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Divider(height: 1),
            for (final language in supportedLanguages)
              _LanguageTile(
                language: language,
                isSelected: currentLanguage == language.code,
                onTap: () => ref
                    .read(settingsProvider.notifier)
                    .updateLanguage(language.code),
              ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(spacingLg),
              child: Text(
                l10n.languageSettingsNote,
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

/// A selectable app language: ISO code, English name and native name.
class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  final String code;
  final String name;
  final String nativeName;
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(language.nativeName),
      subtitle: Text(language.name),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primaryContainer.withValues(
        alpha: opacityMuted,
      ),
    );
  }
}
