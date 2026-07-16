import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/sdg/data/sdg_resources.dart';

/// Loads all SDG resources from the bundled JSON asset.
Future<Map<int, List<SdgResource>>> loadSdgResources() =>
    loadGoalKeyedJsonList('data/app/sdg_resources.json', SdgResource.fromJson);
