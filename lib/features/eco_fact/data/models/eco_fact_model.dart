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
      relatedSdgs: (json['relatedSdgs'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      unWorldDay: json['unWorldDay'] as String?,
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
}
