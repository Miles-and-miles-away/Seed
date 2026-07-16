/// UN SDG target data model.
class SdgTarget {
  const SdgTarget({
    required this.code,
    required this.descriptionEn,
    this.descriptionJa = '',
    this.descriptionEs = '',
  });

  factory SdgTarget.fromJson(Map<String, dynamic> json) {
    return SdgTarget(
      code: json['code'] as String,
      descriptionEn: json['description'] as String,
      descriptionJa: json['descriptionJa'] as String? ?? '',
      descriptionEs: json['descriptionEs'] as String? ?? '',
    );
  }

  final String code;
  final String descriptionEn;
  final String descriptionJa;
  final String descriptionEs;

  String description(String locale) => switch (locale) {
    'ja' when descriptionJa.isNotEmpty => descriptionJa,
    'es' when descriptionEs.isNotEmpty => descriptionEs,
    _ => descriptionEn,
  };
}
