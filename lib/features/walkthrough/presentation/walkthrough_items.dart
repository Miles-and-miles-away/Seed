import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// Everything the walkthrough asks a new user to find. [name] is the id
/// stored in the user's `settings.walkthroughFound` list.
enum WalkthroughItem {
  /// The greeting after mascot selection. Not a checklist entry.
  intro,
  logAction,
  dailyChallenge,
  sdg,
  ecoFact,
  calculators,
  quiz,
  progress;

  /// The entries shown in the checklist, in display order.
  static final List<WalkthroughItem> checklist = values
      .where((item) => item != intro)
      .toList(growable: false);

  String label(AppLocalizations l10n) => switch (this) {
    intro => '',
    logAction => l10n.walkthroughItemLogAction,
    dailyChallenge => l10n.walkthroughItemDailyChallenge,
    sdg => l10n.walkthroughItemSdg,
    ecoFact => l10n.walkthroughItemEcoFact,
    calculators => l10n.walkthroughItemCalculators,
    quiz => l10n.walkthroughItemQuiz,
    progress => l10n.walkthroughItemProgress,
  };

  /// The explanation, one short page per entry, tapped through in order.
  List<String> pages(AppLocalizations l10n, {required String mascotName}) =>
      switch (this) {
        intro => [l10n.walkthroughIntro1(mascotName), l10n.walkthroughIntro2],
        logAction => [l10n.walkthroughLogAction1],
        dailyChallenge => [l10n.walkthroughDailyChallenge1],
        sdg => [l10n.walkthroughSdg1],
        ecoFact => [l10n.walkthroughEcoFact1],
        calculators => [
          l10n.walkthroughCalculators1,
          l10n.walkthroughCalculators2,
          l10n.walkthroughCalculators3,
          l10n.walkthroughCalculators4,
        ],
        quiz => [l10n.walkthroughQuiz1],
        progress => [
          l10n.walkthroughProgress1,
          l10n.walkthroughProgress2,
          l10n.walkthroughProgress3,
        ],
      };
}
