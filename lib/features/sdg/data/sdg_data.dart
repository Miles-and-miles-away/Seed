import 'package:flutter/material.dart';

/// UN Sustainable Development Goal data
class SdgGoal {
  const SdgGoal({
    required this.number,
    required this.titleEn,
    required this.shortTitleEn,
    required this.descriptionEn,
    required this.color,
    required this.iconUrl,
    this.isLearnOnly = false,
    this.titleJa = '',
    this.titleEs = '',
    this.shortTitleJa = '',
    this.shortTitleEs = '',
    this.descriptionJa = '',
    this.descriptionEs = '',
  });

  factory SdgGoal.fromJson(Map<String, dynamic> json) {
    final hex = json['color'] as String;
    return SdgGoal(
      number: json['number'] as int,
      titleEn: json['title'] as String,
      shortTitleEn: json['shortTitle'] as String,
      descriptionEn: json['description'] as String,
      color: Color(int.parse(hex, radix: 16) + 0xFF000000),
      iconUrl: json['iconUrl'] as String,
      isLearnOnly: json['isLearnOnly'] as bool? ?? false,
      titleJa: json['titleJa'] as String? ?? '',
      titleEs: json['titleEs'] as String? ?? '',
      shortTitleJa: json['shortTitleJa'] as String? ?? '',
      shortTitleEs: json['shortTitleEs'] as String? ?? '',
      descriptionJa: json['descriptionJa'] as String? ?? '',
      descriptionEs: json['descriptionEs'] as String? ?? '',
    );
  }

  final int number;
  final String titleEn;
  final String shortTitleEn;
  final String descriptionEn;
  final Color color;
  final String iconUrl;
  final bool isLearnOnly;
  final String titleJa;
  final String titleEs;
  final String shortTitleJa;
  final String shortTitleEs;
  final String descriptionJa;
  final String descriptionEs;

  String title(String locale) => switch (locale) {
    'ja' when titleJa.isNotEmpty => titleJa,
    'es' when titleEs.isNotEmpty => titleEs,
    _ => titleEn,
  };

  String shortTitle(String locale) => switch (locale) {
    'ja' when shortTitleJa.isNotEmpty => shortTitleJa,
    'es' when shortTitleEs.isNotEmpty => shortTitleEs,
    _ => shortTitleEn,
  };

  String description(String locale) => switch (locale) {
    'ja' when descriptionJa.isNotEmpty => descriptionJa,
    'es' when descriptionEs.isNotEmpty => descriptionEs,
    _ => descriptionEn,
  };

  String get infographicAsset =>
      'assets/images/sdg_infographics/'
      'sdg_infographic_$number.jpg';
}
