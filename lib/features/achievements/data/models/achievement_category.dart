/// Top-level grouping for an achievement. Drives the Profile and
/// Achievements-screen sections and the badge color used in §6.8.
enum AchievementCategory {
  special,
  action,
  streak,
  level,
  sdg,
  milestone;

  /// Parses the JSON string written in `data/app/achievements.json`.
  /// Returns null if the value does not match any known category.
  static AchievementCategory? fromString(String? value) {
    if (value == null) return null;
    return AchievementCategory.values.cast<AchievementCategory?>().firstWhere(
          (c) => c?.name == value,
          orElse: () => null,
        );
  }
}
