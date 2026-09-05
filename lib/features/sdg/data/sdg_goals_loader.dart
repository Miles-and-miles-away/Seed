import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';

/// Loaded SDG goals with O(1) lookup by goal number.
class SdgGoalsData {
  const SdgGoalsData({required this.goals, required this.goalMap});

  final List<SdgGoal> goals;
  final Map<int, SdgGoal> goalMap;
}

/// Loads all 17 SDG goals from the bundled JSON asset.
Future<SdgGoalsData> loadSdgGoals() async {
  final goals = await loadJsonList('data/app/sdg_goals.json', SdgGoal.fromJson);
  return SdgGoalsData(
    goals: goals,
    goalMap: {for (final g in goals) g.number: g},
  );
}
