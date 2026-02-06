import '../../../../core/l10n/generated/app_localizations.dart';

/// Sort options for the action library.
enum ActionSortOption {
  /// Sort alphabetically A-Z.
  alphabeticalAsc,

  /// Sort alphabetically Z-A.
  alphabeticalDesc,

  /// Sort by CO₂ impact, highest first.
  co2HighToLow,

  /// Sort by CO₂ impact, lowest first.
  co2LowToHigh,

  /// Sort by points, highest first.
  pointsHighToLow,

  /// Sort by points, lowest first.
  pointsLowToHigh;

  /// Returns the localized display name for this sort option.
  String displayName(AppLocalizations l10n) {
    return switch (this) {
      ActionSortOption.alphabeticalAsc => l10n.sortAlphabeticalAZ,
      ActionSortOption.alphabeticalDesc => l10n.sortAlphabeticalZA,
      ActionSortOption.co2HighToLow => l10n.sortCo2HighToLow,
      ActionSortOption.co2LowToHigh => l10n.sortCo2LowToHigh,
      ActionSortOption.pointsHighToLow => l10n.sortPointsHighToLow,
      ActionSortOption.pointsLowToHigh => l10n.sortPointsLowToHigh,
    };
  }
}
