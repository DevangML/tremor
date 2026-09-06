// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earthquake_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EarthquakeDto _$EarthquakeDtoFromJson(Map<String, dynamic> json) =>
    _EarthquakeDto(
      id: json['id'] as String,
      properties: EarthquakePropertiesDto.fromJson(
        json['properties'] as Map<String, dynamic>,
      ),
      geometry: EarthquakeGeometryDto.fromJson(
        json['geometry'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$EarthquakeDtoToJson(_EarthquakeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'properties': instance.properties,
      'geometry': instance.geometry,
    };

_EarthquakePropertiesDto _$EarthquakePropertiesDtoFromJson(
  Map<String, dynamic> json,
) => _EarthquakePropertiesDto(
  mag: json['mag'] as num,
  place: json['place'] as String,
  time: (json['time'] as num).toInt(),
);

Map<String, dynamic> _$EarthquakePropertiesDtoToJson(
  _EarthquakePropertiesDto instance,
) => <String, dynamic>{
  'mag': instance.mag,
  'place': instance.place,
  'time': instance.time,
};

_EarthquakeGeometryDto _$EarthquakeGeometryDtoFromJson(
  Map<String, dynamic> json,
) => _EarthquakeGeometryDto(
  coordinates: (json['coordinates'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$EarthquakeGeometryDtoToJson(
  _EarthquakeGeometryDto instance,
) => <String, dynamic>{'coordinates': instance.coordinates};
