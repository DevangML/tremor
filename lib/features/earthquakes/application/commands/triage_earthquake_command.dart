import 'package:tremor/core/index.dart' show Failure, Result;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeRepository;

class TriageEarthquakeCommand(final EarthquakeRepository _repository) {
  Future<Result<void, Failure>> call({required String earthquakeId}) async {
    return await _repository.markAsTriaged(earthquakeId);
  }
}
