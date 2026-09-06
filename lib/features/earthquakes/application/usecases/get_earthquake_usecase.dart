import 'package:tremor/core/error/failures.dart';
import 'package:tremor/core/result/result.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';
import 'package:tremor/features/earthquakes/domain/repositories/earthquake_repository.dart';

class GetEarthquakeUsecase(final EarthquakeRepository _repository) {
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
