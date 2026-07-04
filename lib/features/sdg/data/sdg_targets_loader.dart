import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/sdg/data/sdg_targets.dart';

/// Loads all 169 SDG targets from the bundled JSON asset,
/// keyed by goal number for O(1) lookup.
Future<Map<int, List<SdgTarget>>> loadSdgTargets() => loadGoalKeyedJsonList(
      'data/app/sdg_targets.json',
      SdgTarget.fromJson,
    );
