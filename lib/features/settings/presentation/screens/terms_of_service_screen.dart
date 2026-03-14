import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/data/legal_content.dart';
import 'legal_document_screen.dart';

/// Screen displaying the terms of service.
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return LegalDocumentScreen(
      title: l10n.termsOfServiceTitle,
      sections: TermsOfServiceContent.forLocale(locale),
      lastUpdated: TermsOfServiceContent.lastUpdated,
    );
  }
}
