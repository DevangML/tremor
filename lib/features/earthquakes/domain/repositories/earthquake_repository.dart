import 'package:tremor/core/index.dart' show Failure, Result;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity;

abstract interface class EarthquakeRepository {
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes();
  Future<Result<void, Failure>> markAsTriaged(String id);
}
