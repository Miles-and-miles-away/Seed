import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/language_picker_sheet.dart';
import 'package:seed_app/features/settings/presentation/widgets/language_tile.dart';

/// Globe and the current language's native name; opens the language
/// picker before sign-in.
class LanguagePill extends ConsumerWidget {
  const LanguagePill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(currentLanguageProvider);
    final label = AppLocalizations.of(
      context,
    ).languageCurrentLabel(nativeLanguageName(code));
    void open() => showLanguagePickerSheet(context);

    return Tooltip(
      message: label,
      excludeFromSemantics: true,
      child: Semantics(
        container: true,
        button: true,
        label: label,
        onTap: open,
        excludeSemantics: true,
        child: TextButton.icon(
          onPressed: open,
          icon: const Icon(Icons.language),
          label: NativeLanguageName(code),
        ),
      ),
    );
  }
}
