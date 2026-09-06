import 'dart:math' as math;
import 'package:tremor/core/geo/coordinates.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';

class EarthquakeTriageService {
  const new();

  double distanceBetweenKm(Coordinates a, Coordinates b) {
    const pie = math.pi / 180;
    const cos = math.cos;
    final aLat = a.lat * pie;
    final bLat = b.lat * pie;
    final dLat = (b.lat - a.lat) * pie;
    final dLng = (b.lng - a.lng) * pie;

    final computation =
        0.5 - cos(dLat) / 2 + cos(aLat) * cos(bLat) * (1 - cos(dLng)) / 2;

    return 12742 * math.asin(math.sqrt(computation));
  }

  List<EarthquakeEntity> filterWithinRadius({
    required List<EarthquakeEntity> quakes,
    required Coordinates center,
    required double radius,
  }) {
    return quakes
        .where((q) => distanceBetweenKm(q.coordinates, center) <= radius)
        .toList();
  }
}
