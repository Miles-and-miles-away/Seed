import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/sdg/data/sdg_data.dart';

// ignore_for_file: constant_identifier_names
const _ASSET_PATH = 'data/app/sdg_goals.json';

/// Loaded SDG goals with O(1) lookup by goal number.
class SdgGoalsData {
  const SdgGoalsData({
    required this.goals,
    required this.goalMap,
  });

  final List<SdgGoal> goals;
  final Map<int, SdgGoal> goalMap;
}

/// Loads all 17 SDG goals from the bundled JSON asset.
Future<SdgGoalsData> loadSdgGoals() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  final list = jsonDecode(jsonString) as List<dynamic>;
  final goals = list
      .map(
        (e) => SdgGoal.fromJson(e as Map<String, dynamic>),
      )
      .toList();
  final goalMap = {for (final g in goals) g.number: g};
  return SdgGoalsData(goals: goals, goalMap: goalMap);
}
