import 'package:tremor/features/earthquakes/data/models/earthquake_dto.dart';

abstract interface class EarthquakeRemoteDataSource {
  Future<List<EarthquakeDto>> getEarthquakesFeed();
}

final class MockEarthquakeRemoteDataSource
    implements EarthquakeRemoteDataSource {
  const new();

  @override
  Future<List<EarthquakeDto>> getEarthquakesFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final rawGeoJson = [
      {
        'id': 'us7000m8k1',
        'properties': {
          'mag': 6.8,
          'place': '142 km W of Ferndale, California',
          'time': 1725619200000,
        },
        'geometry': {
          'coordinates': [-125.8, 40.4, 10.0],
        },
      },
      {
        'id': 'nc73886731',
        'properties': {
          'mag': 3.2,
          'place': '12km E of San Jose, CA',
          'time': 1725615600000,
        },
        'geometry': {
          'coordinates': [-121.8, 37.3, 5.2],
        },
      },
      {
        'id': 'ak024bf819',
        'properties': {
          'mag': 1.4,
          'place': 'Southern Alaska',
          'time': 1725612000000,
        },
        'geometry': {
          'coordinates': [-150.2, 61.1, 15.0],
        },
      },
    ];

    return rawGeoJson.map(EarthquakeDto.fromJson).toList();
  }
}
