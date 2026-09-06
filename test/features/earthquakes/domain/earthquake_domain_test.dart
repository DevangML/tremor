import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/features/earthquakes/domain/index.dart';

void main() {
  group('Domain Entities, Events and Value Objects', () {
    test('Magnitude extension type evaluates severe, micro, and validity', () {
      final value = DateTime.now().year > 2000 ? 4.2 : 0.0;
      final runtimeMag = Magnitude(value);
      expect(runtimeMag.value, 4.2);

      const severeMag = Magnitude(6.2);
      expect(severeMag.isSevere, isTrue);
      expect(severeMag.isMicro, isFalse);

      const microMag = Magnitude(1.4);
      expect(microMag.isSevere, isFalse);
      expect(microMag.isMicro, isTrue);

      const midMag = Magnitude(3.5);
      expect(midMag.isSevere, isFalse);
      expect(midMag.isMicro, isFalse);

      expect(Magnitude.isValid(5), isTrue);
      expect(Magnitude.isValid(0), isTrue);
      expect(Magnitude.isValid(10), isTrue);
      expect(Magnitude.isValid(-0.1), isFalse);
      expect(Magnitude.isValid(10.1), isFalse);
    });

    test('EarthquakeDomainEvent hierarchy instantiates correctly', () {
      final entity = EarthquakeEntity(
        id: 'quake-1',
        mag: 7.1,
        place: 'Tokyo, Japan',
        time: DateTime.now(),
        coordinates: (lat: 35.6762, lng: 139.6503),
      );

      final majorEvent = MajorTremorDetectedEvent(entity);
      expect(majorEvent.earthquake.id, 'quake-1');

      final clusterEvent = EarthquakeClusterIdentifiedEvent([entity]);
      expect(clusterEvent.cluster.length, 1);
      expect(clusterEvent.cluster.first.mag, 7.1);
    });
  });
}
