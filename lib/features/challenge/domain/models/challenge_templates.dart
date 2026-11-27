/// Daily and multi-day challenge template definitions.
library;

/// A single-day challenge naming one library action.
class DailyChallengeTemplate {
  const DailyChallengeTemplate({
    required this.actionId,
    required this.category,
  });

  factory DailyChallengeTemplate.fromJson(Map<String, dynamic> json) =>
      DailyChallengeTemplate(
        actionId: json['actionId'] as String,
        category: json['category'] as String,
      );

  final String actionId;

  /// Any action in this category completes the challenge.
  final String category;

  /// The id stored in `recentChallengeIds`.
  String get id => actionId;
}

/// A multi-day challenge spanning several consecutive days.
class MultiDayChallengeTemplate {
  const MultiDayChallengeTemplate({
    required this.id,
    required this.category,
    required this.targetDays,
    required this.titleEn,
    required this.titleEs,
    required this.titleJa,
    required this.descriptionEn,
    required this.descriptionEs,
    required this.descriptionJa,
  });

  factory MultiDayChallengeTemplate.fromJson(Map<String, dynamic> json) {
    return MultiDayChallengeTemplate(
      id: json['id'] as String,
      category: json['category'] as String?,
      targetDays: json['targetDays'] as int,
      titleEn: json['titleEn'] as String,
      titleEs: json['titleEs'] as String,
      titleJa: json['titleJa'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionEs: json['descriptionEs'] as String,
      descriptionJa: json['descriptionJa'] as String,
    );
  }

  final String id;
  final String? category;
  final int targetDays;
  final String titleEn;
  final String titleEs;
  final String titleJa;
  final String descriptionEn;
  final String descriptionEs;
  final String descriptionJa;

  String title(String locale) {
    return switch (locale) {
      'es' when titleEs.isNotEmpty => titleEs,
      'ja' when titleJa.isNotEmpty => titleJa,
      _ => titleEn,
    };
  }

  String description(String locale) {
    return switch (locale) {
      'es' when descriptionEs.isNotEmpty => descriptionEs,
      'ja' when descriptionJa.isNotEmpty => descriptionJa,
      _ => descriptionEn,
    };
  }
}

/// Loaded challenge template data.
class ChallengeTemplateData {
  const ChallengeTemplateData({required this.daily, required this.multiDay});

  final List<DailyChallengeTemplate> daily;
  final List<MultiDayChallengeTemplate> multiDay;
}
