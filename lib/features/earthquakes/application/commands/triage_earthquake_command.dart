import 'package:tremor/core/error/failures.dart';
import 'package:tremor/core/result/result.dart';
import 'package:tremor/features/earthquakes/domain/repositories/earthquake_repository.dart';

class TriageEarthquakeCommand(final EarthquakeRepository _repository) {
  Future<Result<void, Failure>> call({required String earthquakeId}) async {
    return await _repository.markAsTriaged(earthquakeId);
  }
}
