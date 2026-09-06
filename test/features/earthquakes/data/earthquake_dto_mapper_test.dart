import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/features/earthquakes/data/mappers/earthquake_dto_mapper.dart';
import 'package:tremor/features/earthquakes/data/models/earthquake_dto.dart';

void main() {
  group('EarthquakeDtoMapper (Data Layer Mapping)', () {
    const mapper = EarthquakeDtoMapper();

    test('maps raw GeoJSON DTO correctly into Domain Entity', () {
      const dto = EarthquakeDto(
        id: 'nc7388',
        properties: EarthquakePropertiesDto(
          mag: 5.4,
          place: 'San Francisco, CA',
          time: 1725619200000,
        ),
        geometry: EarthquakeGeometryDto(coordinates: [-122.4194, 37.7749, 8.0]),
      );

      final entity = mapper.toEntity(dto);

      expect(entity.id, 'nc7388');
      expect(entity.mag, 5.4);
      expect(entity.place, 'San Francisco, CA');
      expect(entity.coordinates.lat, 37.7749);
      expect(entity.coordinates.lng, -122.4194);
      expect(entity.time.millisecondsSinceEpoch, 1725619200000);
    });
  });
}
