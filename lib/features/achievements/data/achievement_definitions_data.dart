import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';

// ignore_for_file: constant_identifier_names
const _ASSET_PATH = 'data/app/achievements.json';

/// Loads the bundled achievement catalog. The list order matches the
/// JSON order and is treated as the canonical display order for the
/// Achievements screen and Profile preview.
Future<List<AchievementDefinition>> loadAchievementDefinitions() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  final list = jsonDecode(jsonString) as List<dynamic>;
  return list
      .map(
        (e) => AchievementDefinition.fromJson(e as Map<String, dynamic>),
      )
      .toList(growable: false);
}
