import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';

// ignore_for_file: constant_identifier_names
const _ASSET_PATH = 'data/app/mascot_species.json';

/// Loads all mascot species from the bundled JSON asset.
Future<List<MascotSpeciesModel>> loadMascotSpecies() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  final json = jsonDecode(jsonString) as List<dynamic>;

  return json
      .map(
        (e) => MascotSpeciesModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList();
}

/// Get a species by ID from a loaded species list.
MascotSpeciesModel? getSpeciesById(
  String id,
  List<MascotSpeciesModel> species,
) {
  for (final s in species) {
    if (s.id == id) return s;
  }
  return null;
}
