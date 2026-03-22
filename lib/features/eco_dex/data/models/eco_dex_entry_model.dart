import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';

/// Immutable model for a single Eco-Dex encyclopedia entry.
class EcoDexEntry {
  const EcoDexEntry({
    required this.id,
    required this.category,
    required this.nameEn,
    required this.nameJa,
    required this.nameEs,
    required this.factEn,
    required this.factJa,
    required this.factEs,
    required this.sourceUrl,
    required this.iconName,
    required this.condition,
    required this.hintEn,
    required this.hintJa,
    required this.hintEs,
  });

  factory EcoDexEntry.fromJson(Map<String, dynamic> json) {
    return EcoDexEntry(
      id: json['id'] as String,
      category: json['category'] as String,
      nameEn: json['nameEn'] as String,
      nameJa: json['nameJa'] as String,
      nameEs: json['nameEs'] as String,
      factEn: json['factEn'] as String,
      factJa: json['factJa'] as String? ?? '',
      factEs: json['factEs'] as String? ?? '',
      sourceUrl: json['sourceUrl'] as String? ?? '',
      iconName: json['iconName'] as String,
      condition: EcoDexCondition.fromJson(
        json['condition'] as Map<String, dynamic>,
      ),
      hintEn: json['hintEn'] as String,
      hintJa: json['hintJa'] as String? ?? '',
      hintEs: json['hintEs'] as String? ?? '',
    );
  }

  final String id;
  final String category;
  final String nameEn;
  final String nameJa;
  final String nameEs;
  final String factEn;
  final String factJa;
  final String factEs;
  final String sourceUrl;
  final String iconName;
  final EcoDexCondition condition;
  final String hintEn;
  final String hintJa;
  final String hintEs;

  String name(String locale) => switch (locale) {
        'ja' => nameJa,
        'es' when nameEs.isNotEmpty => nameEs,
        _ => nameEn,
      };

  String fact(String locale) => switch (locale) {
        'ja' when factJa.isNotEmpty => factJa,
        'es' when factEs.isNotEmpty => factEs,
        _ => factEn,
      };

  String hint(String locale) => switch (locale) {
        'ja' when hintJa.isNotEmpty => hintJa,
        'es' when hintEs.isNotEmpty => hintEs,
        _ => hintEn,
      };
}
