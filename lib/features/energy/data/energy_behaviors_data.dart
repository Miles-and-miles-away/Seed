import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';

// ignore_for_file: constant_identifier_names
const ENERGY_BEHAVIOR_COUNT = 33;
const _ASSET_PATH = 'data/app/energy_behaviors.json';

/// Loads all energy behaviors from the bundled JSON asset.
///
/// The asset also carries a `metadata` block (scope statement, both
/// carrier factors); load it via [loadEnergyMetadata] when the
/// methodology screen needs it.
Future<List<EnergyBehavior>> loadEnergyBehaviors() =>
    loadJsonListUnder(_ASSET_PATH, 'behaviors', EnergyBehavior.fromJson);

/// Loads the dataset metadata block (scope, carrier factors, notes).
Future<Map<String, dynamic>> loadEnergyMetadata() async {
  final root = await loadJsonRoot(_ASSET_PATH);
  return root['metadata'] as Map<String, dynamic>;
}
