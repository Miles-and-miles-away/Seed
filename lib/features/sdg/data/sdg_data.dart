import 'package:flutter/material.dart';

/// UN Sustainable Development Goal data
class SdgGoal {
  const SdgGoal({
    required this.number,
    required this.titleEn,
    required this.shortTitleEn,
    required this.descriptionEn,
    required this.color,
    this.isLearnOnly = false,
    this.titleJa = '',
    this.titleEs = '',
    this.shortTitleJa = '',
    this.shortTitleEs = '',
    this.descriptionJa = '',
    this.descriptionEs = '',
    this.keyFigureEn = '',
    this.keyFigureJa = '',
    this.keyFigureEs = '',
    this.clueEn = '',
    this.clueJa = '',
    this.clueEs = '',
  });

  factory SdgGoal.fromJson(Map<String, dynamic> json) {
    final hex = json['color'] as String;
    return SdgGoal(
      number: json['number'] as int,
      titleEn: json['title'] as String,
      shortTitleEn: json['shortTitle'] as String,
      descriptionEn: json['description'] as String,
      color: Color(int.parse(hex, radix: 16) + 0xFF000000),
      isLearnOnly: json['isLearnOnly'] as bool? ?? false,
      titleJa: json['titleJa'] as String? ?? '',
      titleEs: json['titleEs'] as String? ?? '',
      shortTitleJa: json['shortTitleJa'] as String? ?? '',
      shortTitleEs: json['shortTitleEs'] as String? ?? '',
      descriptionJa: json['descriptionJa'] as String? ?? '',
      descriptionEs: json['descriptionEs'] as String? ?? '',
      keyFigureEn: json['keyFigureEn'] as String? ?? '',
      keyFigureJa: json['keyFigureJa'] as String? ?? '',
      keyFigureEs: json['keyFigureEs'] as String? ?? '',
      clueEn: json['clueEn'] as String? ?? '',
      clueJa: json['clueJa'] as String? ?? '',
      clueEs: json['clueEs'] as String? ?? '',
    );
  }

  final int number;
  final String titleEn;
  final String shortTitleEn;
  final String descriptionEn;
  final Color color;
  final bool isLearnOnly;
  final String titleJa;
  final String titleEs;
  final String shortTitleJa;
  final String shortTitleEs;
  final String descriptionJa;
  final String descriptionEs;

  /// Headline figure, verbatim in each language's description; all set or
  /// all empty.
  final String keyFigureEn;
  final String keyFigureJa;
  final String keyFigureEs;

  /// What the key figure measures, short enough for a Fact pairs card.
  final String clueEn;
  final String clueJa;
  final String clueEs;

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

  String iconAsset(String locale) {
    final code = switch (locale) {
      'ja' || 'es' => locale,
      _ => 'en',
    };
    return 'assets/images/sdg_icons/$code/'
        'sdg_icon_${number.toString().padLeft(2, '0')}.webp';
  }

  String get progressChartAsset =>
      'assets/images/sdg_progress/'
      'sdg_progress_${number.toString().padLeft(2, '0')}.webp';
}
