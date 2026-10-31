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
    required this.iconName,
    required this.condition,
    required this.hintEn,
    this.factJa = '',
    this.factEs = '',
    this.sourceUrl = '',
    this.hintJa = '',
    this.hintEs = '',
    this.keyFigureEn = '',
    this.keyFigureJa = '',
    this.keyFigureEs = '',
    this.clueEn = '',
    this.clueJa = '',
    this.clueEs = '',
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
      keyFigureEn: json['keyFigureEn'] as String? ?? '',
      keyFigureJa: json['keyFigureJa'] as String? ?? '',
      keyFigureEs: json['keyFigureEs'] as String? ?? '',
      clueEn: json['clueEn'] as String? ?? '',
      clueJa: json['clueJa'] as String? ?? '',
      clueEs: json['clueEs'] as String? ?? '',
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

  /// Headline figure, verbatim in each language's fact; all set or all empty.
  final String keyFigureEn;
  final String keyFigureJa;
  final String keyFigureEs;

  /// What the key figure measures, short enough for a Fact pairs card.
  final String clueEn;
  final String clueJa;
  final String clueEs;

  String name(String locale) => switch (locale) {
    'ja' when nameJa.isNotEmpty => nameJa,
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

  String clue(String locale) => switch (locale) {
    'ja' when clueJa.isNotEmpty => clueJa,
    'es' when clueEs.isNotEmpty => clueEs,
    _ => clueEn,
  };

  /// A blank figure in JA or ES stays unset rather than falling back to EN.
  String? keyFigure(String locale) {
    final figure = switch (locale) {
      'ja' => keyFigureJa,
      'es' => keyFigureEs,
      _ => keyFigureEn,
    };
    return figure.isEmpty ? null : figure;
  }
}
