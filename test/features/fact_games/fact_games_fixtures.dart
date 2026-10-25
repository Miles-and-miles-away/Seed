import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

/// A playable fact for [day] whose figure is `{day} kg` unless given.
EcoFact playableFact(
  int day, {
  String? figure,
  String? figureJa,
  String? figureEs,
}) {
  final en = figure ?? '$day kg';
  final ja = figureJa ?? en;
  final es = figureEs ?? en;
  return EcoFact(
    dayOfYear: day,
    category: 'energy',
    nameEn: 'Title $day',
    nameJa: 'タイトル$day',
    nameEs: 'Título $day',
    factEn: 'Fact $day says $en.',
    factJa: 'ファクト$dayは$jaです。',
    factEs: 'El dato $day dice $es.',
    sourceEn: 'Source',
    keyFigureEn: en,
    keyFigureJa: ja,
    keyFigureEs: es,
  );
}

/// A fact with no key figure, which the games never deal.
EcoFact unplayableFact(int day) => EcoFact(
  dayOfYear: day,
  category: 'energy',
  nameEn: 'Title $day',
  factEn: 'Fact $day has no number.',
  sourceEn: 'Source',
);

/// Playable facts for days 1 to [count].
List<EcoFact> playableFacts(int count) => [
  for (var day = 1; day <= count; day++) playableFact(day),
];
