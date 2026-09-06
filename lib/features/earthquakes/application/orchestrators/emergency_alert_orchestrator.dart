import 'package:tremor/core/error/failures.dart';
import 'package:tremor/core/geo/coordinates.dart';
import 'package:tremor/core/hardware/haptic_gateway.dart';
import 'package:tremor/core/result/result.dart';
import 'package:tremor/features/earthquakes/application/commands/triage_earthquake_command.dart';
import 'package:tremor/features/earthquakes/application/queries/get_earthquake_query.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';
import 'package:tremor/features/earthquakes/domain/services/earthquake_triage_service.dart';

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
