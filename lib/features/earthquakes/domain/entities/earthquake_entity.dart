import 'package:tremor/core/geo/coordinates.dart';

class EarthquakeEntity({
  required final String id,
  required final double mag,
  required final String place,
  required final DateTime time,
  required final Coordinates coordinates,
});
