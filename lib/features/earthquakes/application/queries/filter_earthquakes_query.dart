import 'package:tremor/core/index.dart'
    show Coordinates, Failure, FailureResult, Result, Success;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity, EarthquakeRepository, EarthquakeTriageService;

class FilterEarthquakesQuery({
  required final EarthquakeRepository repository,
  required final EarthquakeTriageService triageService,
}) {
  Future<Result<List<EarthquakeEntity>, Failure>> call({
    double? minMagnitude,
    Coordinates? center,
    double? maxRadiusKm,
  }) async {
    final result = await repository.getEarthquakes();

    return switch (result) {
      Success(:final value) => Success(_filter(
        quakes: value,
        minMagnitude: minMagnitude,
        center: center,
        maxRadiusKm: maxRadiusKm,
      )),
      FailureResult() => result,
    };
  }

  List<EarthquakeEntity> _filter({
    required List<EarthquakeEntity> quakes,
    double? minMagnitude,
    Coordinates? center,
    double? maxRadiusKm,
  }) {
    var filtered = quakes;

    if (minMagnitude != null) {
      filtered = filtered.where((q) => q.mag >= minMagnitude).toList();
    }

    if (center != null && maxRadiusKm != null) {
      filtered = triageService.filterWithinRadius(
        quakes: filtered,
        center: center,
        radius: maxRadiusKm,
      );
    }

    return filtered;
  }
}
