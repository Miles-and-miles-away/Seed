import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';

// ignore_for_file: constant_identifier_names
const _ASSET_PATH = 'data/app/achievements.json';

/// SpecialCriteria.specialType values the checker knows how to
/// evaluate. Keep in sync with the `'first_action'` arm of
/// `AchievementChecker._isMet`; new variants need both a checker
/// branch and an entry here.
const _knownSpecialTypes = <String>{'first_action'};

/// Loads the bundled achievement catalog. The list order matches the
/// JSON order and is treated as the canonical display order for the
/// Achievements screen and Profile preview.
Future<List<AchievementDefinition>> loadAchievementDefinitions() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  final list = jsonDecode(jsonString) as List<dynamic>;
  final defs = list
      .map(
        (e) => AchievementDefinition.fromJson(e as Map<String, dynamic>),
      )
      .toList(growable: false);
  assert(
    () {
      for (final d in defs) {
        final c = d.criteria;
        if (c is SpecialCriteria &&
            !_knownSpecialTypes.contains(c.specialType)) {
          throw StateError(
            'Unknown SpecialCriteria.specialType "${c.specialType}" '
            'in achievement "${d.id}" — add a checker branch and '
            'register it in _knownSpecialTypes.',
          );
        }
      }
      return true;
    }(),
    'Catalog contains a special type the checker cannot evaluate.',
  );
  return defs;
}
