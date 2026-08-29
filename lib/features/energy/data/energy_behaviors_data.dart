import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';

// ignore_for_file: constant_identifier_names
const ENERGY_BEHAVIOR_COUNT = 33;
const _ASSET_PATH = 'data/app/energy_behaviors.json';

/// Loads all energy behaviors from the bundled JSON asset.
///
/// The asset also carries a `metadata` block (scope statement, both
/// carrier factors); load it via [loadEnergyMetadata] when the
/// methodology screen needs it.
Future<List<EnergyBehavior>> loadEnergyBehaviors() async {
  final root = await _loadRoot();
  return (root['behaviors'] as List<dynamic>)
      .map((e) => EnergyBehavior.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Loads the dataset metadata block (scope, carrier factors, notes).
Future<Map<String, dynamic>> loadEnergyMetadata() async {
  final root = await _loadRoot();
  return root['metadata'] as Map<String, dynamic>;
}

Future<Map<String, dynamic>> _loadRoot() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  return json.decode(jsonString) as Map<String, dynamic>;
}
