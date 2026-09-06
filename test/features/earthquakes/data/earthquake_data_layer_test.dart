import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/index.dart';
import 'package:tremor/features/earthquakes/data/index.dart';

final class ThrowingRemoteDataSource implements EarthquakeRemoteDataSource {
  const new();

  @override
  Future<List<EarthquakeDto>> getEarthquakesFeed() async {
    throw Exception('Socket closed');
  }
}

void main() {
  group('Data Layer DataSource & Repository Implementation Tests', () {
    test(
      'MockEarthquakeRemoteDataSource returns parsed DTOs with delay',
      () async {
        const dataSource = MockEarthquakeRemoteDataSource();
        final dtos = await dataSource.getEarthquakesFeed();
        expect(dtos, isNotEmpty);
        expect(dtos.first.id, 'us7000m8k1');
        expect(dtos.first.properties.mag, 6.8);
        expect(dtos.first.geometry.coordinates.length, 3);
      },
    );

    test(
      'EarthquakeRepositoryImpl returns Success with mapped entities',
      () async {
        const dataSource = MockEarthquakeRemoteDataSource();
        const mapper = EarthquakeDtoMapper();
        final repo = EarthquakeRepositoryImpl(
          remoteDataSource: dataSource,
          mapper: mapper,
        );

        final result = await repo.getEarthquakes();
        expect(result, isA<Success<List<dynamic>, Failure>>());

        // Test markAsTriaged
        final triageRes = await repo.markAsTriaged('us7000m8k1');
        expect(triageRes, isA<Success<void, Failure>>());
      },
    );

    test(
      'EarthquakeRepositoryImpl catches Exception and returns FailureResult',
      () async {
        const throwingDataSource = ThrowingRemoteDataSource();
        const mapper = EarthquakeDtoMapper();
        final repo = EarthquakeRepositoryImpl(
          remoteDataSource: throwingDataSource,
          mapper: mapper,
        );

        final result = await repo.getEarthquakes();
        expect(result, isA<FailureResult<List<dynamic>, Failure>>());
        final failureResult = result as FailureResult<List<dynamic>, Failure>;
        final failure = failureResult.value;
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('Socket closed'));
      },
    );
  });
}
