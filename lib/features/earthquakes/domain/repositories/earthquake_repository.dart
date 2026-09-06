import 'package:tremor/core/error/failures.dart';
import 'package:tremor/core/result/result.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';

abstract interface class EarthquakeRepository {
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes();
  Future<Result<void, Failure>> markAsTriaged(String id);
}
