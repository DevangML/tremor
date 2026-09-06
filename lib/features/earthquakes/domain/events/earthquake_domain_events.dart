import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';
import 'package:tremor/features/earthquakes/domain/value_objects/hazard_level.dart';

sealed class EarthquakeDomainEvent();

final class MajorTremorDetectedEvent(final EarthquakeEntity earthquake)
    extends EarthquakeDomainEvent;

final class EarthquakeClusterIdentifiedEvent(
  final List<EarthquakeEntity> cluster,
) extends EarthquakeDomainEvent;

final class SecondaryHazardPredictedEvent({
  required final EarthquakeEntity earthquake,
  required final HazardLevel hazardLevel,
}) extends EarthquakeDomainEvent;
