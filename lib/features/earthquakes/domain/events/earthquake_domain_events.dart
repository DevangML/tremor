import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';

sealed class EarthquakeDomainEvent();

final class MajorTremorDetectedEvent(final EarthquakeEntity earthquake)
    extends EarthquakeDomainEvent;

final class EarthquakeClusterIdentifiedEvent(
  final List<EarthquakeEntity> cluster,
) extends EarthquakeDomainEvent;
