import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/presentation/providers/language_sync_provider.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/language_tile.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const _minLineWidth = phraseNarrowestScreenWidth - 2 * spacingXxl;

/// Opens the language picker; completes when it closes, picked or not.
Future<void> showLanguagePickerSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: sheetShape,
      builder: (_) => const LanguagePickerSheet(),
    );

/// The language list as a bottom sheet: one tap applies a language and
/// closes the sheet.
class LanguagePickerSheet extends ConsumerWidget {
  const LanguagePickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(currentLanguageProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: spacingXxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PhraseText(
                    l10n.languagePickerTitle,
                    minLineWidth: _minLineWidth,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: spacingSm),
                  PhraseText(
                    l10n.languagePickerHint,
                    minLineWidth: _minLineWidth,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: spacingLg),
            for (final language in supportedLanguages)
              LanguageTile(
                language: language,
                isSelected: current == language.code,
                onTap: () {
                  unawaited(
                    ref
                        .read(languageSyncProvider.notifier)
                        .choose(language.code),
                  );
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
