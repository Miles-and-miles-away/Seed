import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';

import 'package:seed_app/features/eco_dex/data/models/eco_dex_category_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';

// ignore_for_file: constant_identifier_names
const _ASSET_PATH = 'data/app/eco_dex_entries.json';

/// Loaded Eco-Dex data: categories + entries.
class EcoDexData {
  const EcoDexData({
    required this.categories,
    required this.entries,
  });

  final List<EcoDexCategory> categories;
  final List<EcoDexEntry> entries;
}

/// Loads all Eco-Dex data from the bundled JSON asset.
Future<EcoDexData> loadEcoDexData() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  // 160 KB of JSON: decode off the UI thread.
  return Isolate.run(() => _parseEcoDexData(jsonString));
}

EcoDexData _parseEcoDexData(String jsonString) {
  final json = jsonDecode(jsonString) as Map<String, dynamic>;

  final categories = (json['categories'] as List<dynamic>)
      .map(
        (e) => EcoDexCategory.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList();

  final entries = (json['entries'] as List<dynamic>)
      .map(
        (e) => EcoDexEntry.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList();

  return EcoDexData(categories: categories, entries: entries);
}
