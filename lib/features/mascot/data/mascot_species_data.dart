import 'models/evolution_stage_model.dart';
import 'models/mascot_species_model.dart';

/// Default mascot species data for MVP.
///
/// In the future, this data will be stored in Firestore's `mascotSpecies`
/// collection. For Phase 2 MVP, we use hardcoded data to avoid setup overhead.
const List<MascotSpeciesModel> defaultMascotSpecies = [
  _seedSpecies,
];

/// The Seed mascot species - the default and only mascot for MVP.
const _seedSpecies = MascotSpeciesModel(
  id: 'seed',
  nameEn: 'Seed',
  nameJa: 'シード',
  nameEs: 'Semilla',
  descriptionEn:
      'A tiny seed with big dreams! Watch it grow as you nurture the planet.',
  descriptionJa: '大きな夢を持つ小さな種！地球を大切にすると一緒に成長します。',
  descriptionEs: '¡Una pequeña semilla con grandes '
      'sueños! Mírala crecer mientras '
      'cuidas el planeta.',
  evolutionStages: [
    EvolutionStageModel(
      level: 1,
      assetPath: 'assets/images/mascot/seed_stage1.svg',
      nameEn: 'Seed',
      nameJa: 'たね',
      nameEs: 'Semilla',
    ),
    EvolutionStageModel(
      level: 10,
      assetPath: 'assets/images/mascot/seed_stage2.svg',
      nameEn: 'Sprout',
      nameJa: 'めばえ',
      nameEs: 'Brote',
    ),
    EvolutionStageModel(
      level: 25,
      assetPath: 'assets/images/mascot/seed_stage3.svg',
      nameEn: 'Sapling',
      nameJa: 'なえぎ',
      nameEs: 'Plantón',
    ),
    EvolutionStageModel(
      level: 50,
      assetPath: 'assets/images/mascot/seed_stage4.svg',
      nameEn: 'Tree',
      nameJa: 'たいぼく',
      nameEs: 'Árbol',
    ),
  ],
);

/// Get a species by ID from the default species list.
MascotSpeciesModel? getSpeciesById(String id) {
  for (final species in defaultMascotSpecies) {
    if (species.id == id) return species;
  }
  return null;
}
