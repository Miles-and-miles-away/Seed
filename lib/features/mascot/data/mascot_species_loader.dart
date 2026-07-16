import 'package:collection/collection.dart';

import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';

/// Loads all mascot species from the bundled JSON asset.
Future<List<MascotSpeciesModel>> loadMascotSpecies() =>
    loadJsonList('data/app/mascot_species.json', MascotSpeciesModel.fromJson);

/// Get a species by ID from a loaded species list.
MascotSpeciesModel? getSpeciesById(
  String id,
  List<MascotSpeciesModel> species,
) => species.firstWhereOrNull((s) => s.id == id);

/// Availability value for species that are currently offered to users.
///
/// Other values (e.g. 'coming_soon', 'premium', or a points cost) exclude
/// the species from the starter selection and egg hatching, but mascots a
/// user already owns keep rendering via [getSpeciesById].
const String speciesAvailabilityFree = 'free';

/// Species currently offered as starters or egg hatches.
List<MascotSpeciesModel> selectableSpecies(List<MascotSpeciesModel> species) =>
    species.where((s) => s.availability == speciesAvailabilityFree).toList();
