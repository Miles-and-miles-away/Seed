import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// A selectable app language: ISO code and native name.
class LanguageOption {
  const LanguageOption({required this.code, required this.nativeName});

  final String code;
  final String nativeName;
}

/// Languages offered in the picker, in display order. English is first so
/// [nativeLanguageName] can fall back to it for unknown codes.
const supportedLanguages = [
  LanguageOption(code: 'en', nativeName: 'English'),
  LanguageOption(code: 'es', nativeName: 'Español'),
  LanguageOption(code: 'ja', nativeName: '日本語'),
];

/// [code]'s name in its own language; unknown codes fall back to English.
String nativeLanguageName(String code) => supportedLanguages
    .firstWhere((l) => l.code == code, orElse: () => supportedLanguages.first)
    .nativeName;

/// [code]'s name in the current UI language ("Spanish", "スペイン語").
String languageNameFor(AppLocalizations l10n, String code) => switch (code) {
  'es' => l10n.languageNameSpanish,
  'ja' => l10n.languageNameJapanese,
  _ => l10n.languageNameEnglish,
};

/// A language's native name, drawn and spoken in that language, so 日本語
/// gets Japanese glyphs and pronunciation under any UI language.
class NativeLanguageName extends StatelessWidget {
  const NativeLanguageName(this.code, {this.style, super.key});

  final String code;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final locale = Locale(code);
    return Text.rich(
      TextSpan(text: nativeLanguageName(code), locale: locale),
      locale: locale,
      style: style,
    );
  }
}

/// One choice in a language list: native name, the name in the UI
/// language below it, and a check on the selected one.
class LanguageTile extends StatelessWidget {
  const LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localName = languageNameFor(
      AppLocalizations.of(context),
      language.code,
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      child: ListTile(
        title: NativeLanguageName(language.code),
        // The UI language's own tile would repeat its native name.
        subtitle: localName == language.nativeName ? null : Text(localName),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
            : null,
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: theme.colorScheme.primaryContainer.withValues(
          alpha: opacityMuted,
        ),
      ),
    );
  }
}
