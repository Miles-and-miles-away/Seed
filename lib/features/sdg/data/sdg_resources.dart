/// A single external resource link for an SDG.
class SdgResource {
  const SdgResource({
    required this.titleEn,
    required this.titleJa,
    required this.titleEs,
    required this.url,
    required this.type,
  });

  factory SdgResource.fromJson(Map<String, dynamic> json) {
    return SdgResource(
      titleEn: json['titleEn'] as String,
      titleJa: json['titleJa'] as String,
      titleEs: json['titleEs'] as String,
      url: json['url'] as String,
      type: SdgResourceType.values.byName(json['type'] as String),
    );
  }

  final String titleEn;
  final String titleJa;
  final String titleEs;
  final String url;
  final SdgResourceType type;

  String title(String locale) {
    return switch (locale) {
      'ja' => titleJa,
      'es' => titleEs,
      _ => titleEn,
    };
  }
}

enum SdgResourceType { official, action, education }
