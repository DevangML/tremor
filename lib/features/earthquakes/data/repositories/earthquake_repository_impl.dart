import 'package:tremor/core/error/failures.dart';
import 'package:tremor/core/result/result.dart';
import 'package:tremor/features/earthquakes/data/datasources/earthquake_remote_data_source.dart';
import 'package:tremor/features/earthquakes/data/mappers/earthquake_dto_mapper.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';
import 'package:tremor/features/earthquakes/domain/repositories/earthquake_repository.dart';

final class EarthquakeRepositoryImpl({
  required final EarthquakeRemoteDataSource remoteDataSource,
  required final EarthquakeDtoMapper mapper,
}) implements EarthquakeRepository {
  final Set<String> _triagedIds = {};

  @override
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes() async {
    try {
      final dtos = await remoteDataSource.getEarthquakesFeed();
      final entities = mapper.toEntityList(dtos);
      return Success(entities);
    } on Exception catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> markAsTriaged(String id) async {
    _triagedIds.add(id);
    return Success(null);
  }
}
