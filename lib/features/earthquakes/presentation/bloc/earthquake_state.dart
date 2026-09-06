import 'package:tremor/features/earthquakes/presentation/models/earthquake_card_ui_model.dart';

sealed class EarthquakeState();

final class EarthquakeInitialState() extends EarthquakeState;

final class EarthquakeLoadingState() extends EarthquakeState;

final class EarthquakeLoadedState(final List<EarthquakeCardUiModel> earthquakes)
    extends EarthquakeState;

final class EarthquakeErrorState(final String message) extends EarthquakeState;
