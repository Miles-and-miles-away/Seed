// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascot_species_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MascotSpeciesModel _$MascotSpeciesModelFromJson(Map<String, dynamic> json) =>
    _MascotSpeciesModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameJa: json['nameJa'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionJa: json['descriptionJa'] as String,
      evolutionStages: (json['evolutionStages'] as List<dynamic>)
          .map((e) => EvolutionStageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nameEs: json['nameEs'] as String? ?? '',
      descriptionEs: json['descriptionEs'] as String? ?? '',
      availability: json['availability'] as String? ?? 'free',
    );

Map<String, dynamic> _$MascotSpeciesModelToJson(_MascotSpeciesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameEn': instance.nameEn,
      'nameJa': instance.nameJa,
      'descriptionEn': instance.descriptionEn,
      'descriptionJa': instance.descriptionJa,
      'evolutionStages': instance.evolutionStages,
      'nameEs': instance.nameEs,
      'descriptionEs': instance.descriptionEs,
      'availability': instance.availability,
    };
