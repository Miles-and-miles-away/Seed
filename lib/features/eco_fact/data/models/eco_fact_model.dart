/// Immutable model for a single daily eco-fact.
class EcoFact {
  const EcoFact({
    required this.dayOfYear,
    required this.category,
    required this.factEn,
    required this.sourceEn,
    this.nameEn = '',
    this.nameJa = '',
    this.nameEs = '',
    this.factJa = '',
    this.factEs = '',
    this.sourceJa = '',
    this.sourceEs = '',
    this.sourceUrl = '',
    this.relatedSdgs = const [],
    this.unWorldDay,
    this.keyFigureEn = '',
    this.keyFigureJa = '',
    this.keyFigureEs = '',
    this.clueEn = '',
    this.clueJa = '',
    this.clueEs = '',
  });

  factory EcoFact.fromJson(Map<String, dynamic> json) {
    return EcoFact(
      dayOfYear: json['dayOfYear'] as int,
      category: json['category'] as String,
      nameEn: json['nameEn'] as String? ?? '',
      nameJa: json['nameJa'] as String? ?? '',
      nameEs: json['nameEs'] as String? ?? '',
      factEn: json['factEn'] as String,
      sourceEn: json['sourceEn'] as String,
      factJa: json['factJa'] as String? ?? '',
      factEs: json['factEs'] as String? ?? '',
      sourceJa: json['sourceJa'] as String? ?? '',
      sourceEs: json['sourceEs'] as String? ?? '',
      sourceUrl: json['sourceUrl'] as String? ?? '',
      relatedSdgs:
          (json['relatedSdgs'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      unWorldDay: json['unWorldDay'] as String?,
      keyFigureEn: json['keyFigureEn'] as String? ?? '',
      keyFigureJa: json['keyFigureJa'] as String? ?? '',
      keyFigureEs: json['keyFigureEs'] as String? ?? '',
      clueEn: json['clueEn'] as String? ?? '',
      clueJa: json['clueJa'] as String? ?? '',
      clueEs: json['clueEs'] as String? ?? '',
    );
  }

  final int dayOfYear;
  final String category;
  final String nameEn;
  final String nameJa;
  final String nameEs;
  final String factEn;
  final String factJa;
  final String factEs;
  final String sourceEn;
  final String sourceJa;
  final String sourceEs;
  final String sourceUrl;
  final List<int> relatedSdgs;
  final String? unWorldDay;

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

  String source(String locale) => switch (locale) {
    'ja' when sourceJa.isNotEmpty => sourceJa,
    'es' when sourceEs.isNotEmpty => sourceEs,
    _ => sourceEn,
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

  bool get isPlayable => keyFigureEn.isNotEmpty;
}
