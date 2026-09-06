import 'package:tremor/core/index.dart'
    show Failure, FailureResult, Result, ServerFailure, Success;
import 'package:tremor/features/earthquakes/data/index.dart'
    show EarthquakeDtoMapper, EarthquakeRemoteDataSource;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity, EarthquakeRepository;

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
