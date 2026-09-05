/// Model for an Eco-Dex category with trilingual names.
class EcoDexCategory {
  const EcoDexCategory({
    required this.id,
    required this.nameEn,
    required this.nameJa,
    required this.nameEs,
  });

  factory EcoDexCategory.fromJson(Map<String, dynamic> json) {
    return EcoDexCategory(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameJa: json['nameJa'] as String,
      nameEs: json['nameEs'] as String,
    );
  }

  final String id;
  final String nameEn;
  final String nameJa;
  final String nameEs;

  String name(String locale) => switch (locale) {
    'ja' when nameJa.isNotEmpty => nameJa,
    'es' when nameEs.isNotEmpty => nameEs,
    _ => nameEn,
  };
}
