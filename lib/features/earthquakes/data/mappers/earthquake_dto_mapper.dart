import 'package:tremor/features/earthquakes/data/index.dart'
    show EarthquakeDto;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity;

final class EarthquakeDtoMapper {
  const new();

  /// Translates a wire DTO into a pure Domain Entity.
  EarthquakeEntity toEntity(EarthquakeDto dto) {
    final rawCoords = dto.geometry.coordinates;

    return EarthquakeEntity(
      id: dto.id,
      mag: dto.properties.mag.toDouble(),
      place: dto.properties.place,
      time: DateTime.fromMillisecondsSinceEpoch(dto.properties.time),
      coordinates: (
        lat: rawCoords.length > 1 ? rawCoords[1] : 0.0,
        lng: rawCoords.isNotEmpty ? rawCoords[0] : 0.0,
      ),
    );
  }

  /// Translates a list of DTOs into a list of Domain Entities.
  List<EarthquakeEntity> toEntityList(List<EarthquakeDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
