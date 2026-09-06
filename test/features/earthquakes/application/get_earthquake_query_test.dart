import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/error/failures.dart';
import 'package:tremor/core/result/result.dart';
import 'package:tremor/features/earthquakes/application/queries/get_earthquake_query.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';
import 'package:tremor/features/earthquakes/domain/repositories/earthquake_repository.dart';

final class FakeEarthquakeRepository implements EarthquakeRepository {
  new(this._result);

  final Result<List<EarthquakeEntity>, Failure> _result;

  @override
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes() async =>
      _result;

  @override
  Future<Result<void, Failure>> markAsTriaged(String id) async =>
      Success(null);
}

void main() {
  group('GetEarthquakeQuery (Pure Unit Tests)', () {
    test('filters out quakes with magnitude < 2.0 on Success', () async {
      final sampleQuakes = [
        EarthquakeEntity(
          id: 'q1',
          mag: 4.5,
          place: 'California',
          time: DateTime.now(),
          coordinates: (lat: 37, lng: -122),
        ),
        EarthquakeEntity(
          id: 'q2',
          mag: 1.2,
          place: 'Alaska',
          time: DateTime.now(),
          coordinates: (lat: 61, lng: -150),
        ),
      ];

      final repo = FakeEarthquakeRepository(Success(sampleQuakes));
      final query = GetEarthquakeQuery(repo);

      final result = await query();

      switch (result) {
        case Success(:final value):
          expect(value.length, 1);
          expect(value.first.id, 'q1');
          expect(value.first.mag, 4.5);
        case FailureResult():
          fail('Expected Success, got Failure');
      }
    });

    test('forwards FailureResult when repository fails', () async {
      final repo = FakeEarthquakeRepository(
        FailureResult(ServerFailure('Connection Error', 500)),
      );
      final query = GetEarthquakeQuery(repo);

      final result = await query();

      switch (result) {
        case Success():
          fail('Expected Failure, got Success');
        case FailureResult(:final value):
          expect(value.message, 'Connection Error');
          expect(value.code, 500);
      }
    });
  });
}
