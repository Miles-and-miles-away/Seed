import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// User-facing categorization for in-app feedback submissions.
///
/// The subject prefix is appended to the mailto subject line so the
/// developer's inbox can be triaged at a glance.
enum FeedbackCategory {
  bug('[Bug]'),
  featureRequest('[Feature]'),
  general('[Feedback]');

  const FeedbackCategory(this.subjectPrefix);

  /// Bracketed tag prepended to the mailto subject (e.g. `[Bug]`).
  final String subjectPrefix;

  /// Localized label shown in the category chip and mailto body.
  String label(AppLocalizations l10n) {
    switch (this) {
      case FeedbackCategory.bug:
        return l10n.feedbackCategoryBug;
      case FeedbackCategory.featureRequest:
        return l10n.feedbackCategoryFeature;
      case FeedbackCategory.general:
        return l10n.feedbackCategoryGeneral;
    }
  }
}
