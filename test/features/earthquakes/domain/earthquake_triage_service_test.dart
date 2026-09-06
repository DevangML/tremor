import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity, EarthquakeTriageService;

void main() {
  group('EarthquakeTriageService (Pure Domain Unit Tests)', () {
    const service = EarthquakeTriageService();

    test(
      'calculates Haversine distance between SF and San Jose correctly (~70km)',
      () {
        const sf = (lat: 37.7749, lng: -122.4194);
        const sj = (lat: 37.3382, lng: -121.8863);

        final distance = service.distanceBetweenKm(sf, sj);

        expect(distance, greaterThan(65));
        expect(distance, lessThan(75));
      },
    );

    test('filters earthquakes within radius correctly', () {
      const sf = (lat: 37.7749, lng: -122.4194);

      final quakes = [
        EarthquakeEntity(
          id: 'q1',
          mag: 4.5,
          place: 'Near SF',
          time: DateTime.now(),
          coordinates: (lat: 37.78, lng: -122.41),
        ),
        EarthquakeEntity(
          id: 'q2',
          mag: 5.2,
          place: 'Tokyo',
          time: DateTime.now(),
          coordinates: (lat: 35.6762, lng: 139.6503),
        ),
      ];

      final filtered = service.filterWithinRadius(
        quakes: quakes,
        center: sf,
        radius: 50,
      );

      expect(filtered.length, 1);
      expect(filtered.first.id, 'q1');
    });
  });
}
