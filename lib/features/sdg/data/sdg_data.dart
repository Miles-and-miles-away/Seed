import 'package:flutter/material.dart';

/// UN Sustainable Development Goal data
class SdgGoal {
  const SdgGoal({
    required this.number,
    required this.title,
    required this.shortTitle,
    required this.description,
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
      title: json['title'] as String,
      shortTitle: json['shortTitle'] as String,
      description: json['description'] as String,
      color: Color(
        int.parse(hex, radix: 16) + 0xFF000000,
      ),
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
  final String title;
  final String shortTitle;
  final String description;
  final Color color;
  final String iconUrl;
  final bool isLearnOnly;
  final String titleJa;
  final String titleEs;
  final String shortTitleJa;
  final String shortTitleEs;
  final String descriptionJa;
  final String descriptionEs;

  String getTitle(String locale) => switch (locale) {
        'ja' when titleJa.isNotEmpty => titleJa,
        'es' when titleEs.isNotEmpty => titleEs,
        _ => title,
      };

  String getShortTitle(String locale) => switch (locale) {
        'ja' when shortTitleJa.isNotEmpty => shortTitleJa,
        'es' when shortTitleEs.isNotEmpty => shortTitleEs,
        _ => shortTitle,
      };

  String getDescription(String locale) => switch (locale) {
        'ja' when descriptionJa.isNotEmpty => descriptionJa,
        'es' when descriptionEs.isNotEmpty => descriptionEs,
        _ => description,
      };

  String get infographicAsset => 'assets/images/sdg_infographics/'
      'sdg_infographic_$number.jpg';
}
