import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/food/data/models/food_item_model.dart';

// ignore_for_file: constant_identifier_names
const FOOD_ITEM_COUNT = 166;
const _ASSET_PATH = 'data/app/food_items.json';

/// Loads all food items from the bundled JSON asset.
///
/// The asset also carries a `metadata` block (scope statement, primary
/// source); load it via [loadFoodMetadata] when the methodology sheet
/// needs it.
Future<List<FoodItem>> loadFoodItems() async {
  final root = await _loadRoot();
  return (root['items'] as List<dynamic>)
      .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Loads the dataset metadata block (version, scope, sources).
Future<Map<String, dynamic>> loadFoodMetadata() async {
  final root = await _loadRoot();
  return root['metadata'] as Map<String, dynamic>;
}

Future<Map<String, dynamic>> _loadRoot() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  return json.decode(jsonString) as Map<String, dynamic>;
}
