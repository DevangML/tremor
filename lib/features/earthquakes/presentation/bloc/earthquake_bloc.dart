import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tremor/core/index.dart' show FailureResult, Success;
import 'package:tremor/features/earthquakes/application/index.dart'
    show EmergencyAlertOrchestrator;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity;
import 'package:tremor/features/earthquakes/presentation/index.dart'
    show
        EarthquakeErrorState,
        EarthquakeEvent,
        EarthquakeInitialState,
        EarthquakeLoadedState,
        EarthquakeLoadingState,
        EarthquakePresentationMapper,
        EarthquakeState,
        FetchEarthquakesEvent,
        FilterByMagnitudeEvent;

class EarthquakeBloc extends Bloc<EarthquakeEvent, EarthquakeState> {
  new({required this._orchestrator, required this._mapper})
    : super(EarthquakeInitialState()) {
    on<FetchEarthquakesEvent>(_onFetchEarthquakes);
    on<FilterByMagnitudeEvent>(_onFilterByMagnitude);
  }

  final EmergencyAlertOrchestrator _orchestrator;
  final EarthquakePresentationMapper _mapper;
  List<EarthquakeEntity> _cachedQuakes = const [];

  Future<void> _onFetchEarthquakes(
    FetchEarthquakesEvent event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(EarthquakeLoadingState());

    final result = await _orchestrator.execute(
      userLocation: (lat: 37.7749, lng: -122.4194),
      alertRadiusKm: 250,
    );

    switch (result) {
      case Success(:final value):
        _cachedQuakes = value;
        final uiModels = _mapper.toUiModelList(value);
        emit(EarthquakeLoadedState(earthquakes: uiModels));
      case FailureResult(:final value):
        emit(EarthquakeErrorState(value.message));
    }
  }

  void _onFilterByMagnitude(
    FilterByMagnitudeEvent event,
    Emitter<EarthquakeState> emit,
  ) {
    final filtered = _cachedQuakes
        .where((q) => q.mag >= event.minMagnitude)
        .toList();
    final uiModels = _mapper.toUiModelList(filtered);
    emit(
      EarthquakeLoadedState(
        earthquakes: uiModels,
        selectedMinMag: event.minMagnitude,
      ),
    );
  }
}
