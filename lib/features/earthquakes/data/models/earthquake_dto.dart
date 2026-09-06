import 'package:freezed_annotation/freezed_annotation.dart';

part 'earthquake_dto.freezed.dart';
part 'earthquake_dto.g.dart';

@freezed
abstract class EarthquakeDto with _$EarthquakeDto {
  const factory({
    required String id,
    required EarthquakePropertiesDto properties,
    required EarthquakeGeometryDto geometry,
  }) = _EarthquakeDto;

  factory fromJson(Map<String, dynamic> json) => _$EarthquakeDtoFromJson(json);
}

@freezed
abstract class EarthquakePropertiesDto with _$EarthquakePropertiesDto {
  const factory({required num mag, required String place, required int time}) =
      _EarthquakePropertiesDto;

  factory fromJson(Map<String, dynamic> json) =>
      _$EarthquakePropertiesDtoFromJson(json);
}

@freezed
abstract class EarthquakeGeometryDto with _$EarthquakeGeometryDto {
  const factory({required List<double> coordinates}) = _EarthquakeGeometryDto;

  factory fromJson(Map<String, dynamic> json) =>
      _$EarthquakeGeometryDtoFromJson(json);
}
