import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';

// ignore_for_file: constant_identifier_names
const TRANSPORT_MODE_COUNT = 27;
const _ASSET_PATH = 'data/app/transport_modes.json';

/// Loads all transport modes from the bundled JSON asset.
///
/// The asset also carries a `metadata` block (scope statement,
/// grid factor); load it via [loadTransportMetadata] when the
/// methodology sheet needs it.
Future<List<TransportMode>> loadTransportModes() async {
  final root = await _loadRoot();
  return (root['modes'] as List<dynamic>)
      .map((e) => TransportMode.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Loads the dataset metadata block (version, scope, sources).
Future<Map<String, dynamic>> loadTransportMetadata() async {
  final root = await _loadRoot();
  return root['metadata'] as Map<String, dynamic>;
}

Future<Map<String, dynamic>> _loadRoot() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  return json.decode(jsonString) as Map<String, dynamic>;
}
