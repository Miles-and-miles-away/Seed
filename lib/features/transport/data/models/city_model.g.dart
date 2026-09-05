// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_City _$CityFromJson(Map<String, dynamic> json) => _City(
  name: json['name'] as String,
  cc: json['cc'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  mass: json['mass'] as String,
  pop: (json['pop'] as num?)?.toInt() ?? 0,
  nameJa: json['name_ja'] as String?,
  nameEs: json['name_es'] as String?,
);

Map<String, dynamic> _$CityToJson(_City instance) => <String, dynamic>{
  'name': instance.name,
  'cc': instance.cc,
  'lat': instance.lat,
  'lon': instance.lon,
  'mass': instance.mass,
  'pop': instance.pop,
  'name_ja': instance.nameJa,
  'name_es': instance.nameEs,
};

_CityLink _$CityLinkFromJson(Map<String, dynamic> json) => _CityLink(
  a: json['a'] as String,
  b: json['b'] as String,
  kind: json['kind'] as String,
  label: json['label'] as String? ?? '',
  maxKm: (json['max_km'] as num?)?.toDouble(),
  portALat: (json['port_a_lat'] as num?)?.toDouble(),
  portALon: (json['port_a_lon'] as num?)?.toDouble(),
  radiusAKm: (json['radius_a_km'] as num?)?.toDouble(),
  portBLat: (json['port_b_lat'] as num?)?.toDouble(),
  portBLon: (json['port_b_lon'] as num?)?.toDouble(),
  radiusBKm: (json['radius_b_km'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CityLinkToJson(_CityLink instance) => <String, dynamic>{
  'a': instance.a,
  'b': instance.b,
  'kind': instance.kind,
  'label': instance.label,
  'max_km': instance.maxKm,
  'port_a_lat': instance.portALat,
  'port_a_lon': instance.portALon,
  'radius_a_km': instance.radiusAKm,
  'port_b_lat': instance.portBLat,
  'port_b_lon': instance.portBLon,
  'radius_b_km': instance.radiusBKm,
};
