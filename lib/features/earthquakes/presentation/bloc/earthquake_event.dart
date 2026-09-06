sealed class EarthquakeEvent();

final class FetchEarthquakesEvent() extends EarthquakeEvent;

final class FilterByMagnitudeEvent(final double minMagnitude)
    extends EarthquakeEvent;
