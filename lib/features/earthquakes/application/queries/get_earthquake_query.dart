import 'package:tremor/core/index.dart'
    show Failure, FailureResult, Result, Success;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity, EarthquakeRepository;

class GetEarthquakeQuery(final EarthquakeRepository _repository) {
  Future<Result<List<EarthquakeEntity>, Failure>> call() async {
    final result = await _repository.getEarthquakes();

    return switch (result) {
      Success(:final value) => Success(
        value.where((quake) => quake.mag >= 2.0).toList(),
      ),
      FailureResult() => result,
    };
  }
}
