import 'package:collection/collection.dart';

import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';

/// Loads all mascot species from the bundled JSON asset.
Future<List<MascotSpeciesModel>> loadMascotSpecies() => loadJsonList(
      'data/app/mascot_species.json',
      MascotSpeciesModel.fromJson,
    );

/// Get a species by ID from a loaded species list.
MascotSpeciesModel? getSpeciesById(
  String id,
  List<MascotSpeciesModel> species,
) =>
    species.firstWhereOrNull((s) => s.id == id);
