import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';

// ignore_for_file: constant_identifier_names
const TRANSPORT_MODE_COUNT = 27;
const _ASSET_PATH = 'data/app/transport_modes.json';

/// Loads all transport modes from the bundled JSON asset.
///
/// The asset also carries a `metadata` block (scope statement,
/// grid factor); load it via [loadTransportMetadata] when the
/// methodology sheet needs it.
Future<List<TransportMode>> loadTransportModes() =>
    loadJsonListUnder(_ASSET_PATH, 'modes', TransportMode.fromJson);

/// Loads the dataset metadata block (version, scope, sources).
Future<Map<String, dynamic>> loadTransportMetadata() async {
  final root = await loadJsonRoot(_ASSET_PATH);
  return root['metadata'] as Map<String, dynamic>;
}
