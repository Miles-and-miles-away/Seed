import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_category_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';

const forestsCategory = EcoDexCategory(
  id: 'forests',
  nameEn: 'Forests',
  nameJa: '森',
  nameEs: 'Bosques',
);

const oceansCategory = EcoDexCategory(
  id: 'oceans',
  nameEn: 'Oceans',
  nameJa: '海',
  nameEs: 'Océanos',
);

const climateCategory = EcoDexCategory(
  id: 'climate',
  nameEn: 'Climate',
  nameJa: '気候',
  nameEs: 'Clima',
);

/// Minimal entry; [nameEn] and [iconName] default to [id].
EcoDexEntry ecoDexEntry(
  String id, {
  String category = 'forests',
  String? nameEn,
  String factEn = '',
  String hintEn = '',
  String hintEs = '',
  String? iconName,
  EcoDexCondition condition = const EcoDexCondition.totalActions(count: 1),
}) => EcoDexEntry(
  id: id,
  category: category,
  nameEn: nameEn ?? id,
  nameJa: '',
  nameEs: '',
  factEn: factEn,
  iconName: iconName ?? id,
  condition: condition,
  hintEn: hintEn,
  hintEs: hintEs,
);

/// Data holding [entries] under a single [category].
EcoDexData ecoDexDataFor(
  List<EcoDexEntry> entries, {
  EcoDexCategory category = forestsCategory,
}) => EcoDexData(categories: [category], entries: entries);
