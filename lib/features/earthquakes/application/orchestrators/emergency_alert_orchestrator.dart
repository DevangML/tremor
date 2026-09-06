import 'package:tremor/core/index.dart'
    show Coordinates, Failure, FailureResult, HapticGateway, Result, Success;
import 'package:tremor/features/earthquakes/application/index.dart'
    show GetEarthquakeQuery, TriageEarthquakeCommand;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity, EarthquakeTriageService;

class EmergencyAlertOrchestrator({
  required final GetEarthquakeQuery query,
  required final TriageEarthquakeCommand command,
  required final HapticGateway hapticGateway,
  required final EarthquakeTriageService triageService,
}) {
  Future<Result<List<EarthquakeEntity>, Failure>> execute({
    required Coordinates userLocation,
    double alertRadiusKm = 100.0,
  }) async {
    final queryResult = await query();

    return await switch (queryResult) {
      Success(:final value) => _handleSuccess(
        quakes: value,
        userLocation: userLocation,
        alertRadiusKm: alertRadiusKm,
      ),
      FailureResult() => queryResult,
    };
  }

  Future<Result<List<EarthquakeEntity>, Failure>> _handleSuccess({
    required List<EarthquakeEntity> quakes,
    required Coordinates userLocation,
    required double alertRadiusKm,
  }) async {
    final nearByQuakes = triageService.filterWithinRadius(
      quakes: quakes,
      center: userLocation,
      radius: alertRadiusKm,
    );

    final hasSevereEmergency = nearByQuakes.any((q) => q.mag >= 5.0);

    if (hasSevereEmergency) {
      await hapticGateway.triggerSevereAlertHaptic();

      final criticalQuake = nearByQuakes.firstWhere((q) => q.mag >= 5.0);

      await command(earthquakeId: criticalQuake.id);
    }

    return Success(quakes);
  }
}
