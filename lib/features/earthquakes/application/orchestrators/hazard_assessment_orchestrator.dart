import 'package:tremor/core/index.dart'
    show Coordinates, Failure, FailureResult, HapticGateway, Result, Success;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show
        EarthquakeEntity,
        EarthquakeRepository,
        EarthquakeTriageService,
        HazardLevel,
        SecondaryHazardPredictedEvent;

class HazardAssessmentOrchestrator({
  required final EarthquakeRepository repository,
  required final EarthquakeTriageService triageService,
  required final HapticGateway hapticGateway,
}) {
  Future<Result<List<EarthquakeEntity>, Failure>> assessRegionalRisks({
    required Coordinates epicenter,
    required double radiusKm,
    required double focalDepthKm,
    void Function(SecondaryHazardPredictedEvent event)? onHazardIdentified,
  }) async {
    final result = await repository.getEarthquakes();

    return await switch (result) {
      Success(:final value) => _processAssessment(
        quakes: value,
        epicenter: epicenter,
        radiusKm: radiusKm,
        focalDepthKm: focalDepthKm,
        onHazardIdentified: onHazardIdentified,
      ),
      FailureResult() => result,
    };
  }

  Future<Result<List<EarthquakeEntity>, Failure>> _processAssessment({
    required List<EarthquakeEntity> quakes,
    required Coordinates epicenter,
    required double radiusKm,
    required double focalDepthKm,
    void Function(SecondaryHazardPredictedEvent event)? onHazardIdentified,
  }) async {
    final regionalQuakes = triageService.filterWithinRadius(
      quakes: quakes,
      center: epicenter,
      radius: radiusKm,
    );

    var hasSevereHazard = false;

    for (final quake in regionalQuakes) {
      final hazard = HazardLevel.fromSeismicData(
        mag: quake.mag,
        depthKm: focalDepthKm,
      );

      if (hazard.isTsunamiRisk) {
        hasSevereHazard = true;
      }

      onHazardIdentified?.call(
        SecondaryHazardPredictedEvent(
          earthquake: quake,
          hazardLevel: hazard,
        ),
      );
    }

    if (hasSevereHazard) {
      await hapticGateway.triggerSevereAlertHaptic();
    }

    return Success(regionalQuakes);
  }
}
