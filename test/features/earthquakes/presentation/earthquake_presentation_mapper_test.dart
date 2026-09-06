import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/design_system/tremor_theme.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';
import 'package:tremor/features/earthquakes/presentation/mappers/earthquake_presentation_mapper.dart';

void main() {
  group('EarthquakePresentationMapper (Presentation Translation)', () {
    const mapper = EarthquakePresentationMapper();

    test('pre-computes UI values and severity colors correctly', () {
      final severeEntity = EarthquakeEntity(
        id: 'q_severe',
        mag: 6.8,
        place: 'Ferndale, CA',
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        coordinates: (lat: 40.4, lng: -125.8),
      );

      final uiModel = mapper.toUiModel(severeEntity);

      expect(uiModel.id, 'q_severe');
      expect(uiModel.formattedMag, '6.8');
      expect(uiModel.place, 'Ferndale, CA');
      expect(uiModel.formattedTime, '10m ago');
      expect(uiModel.severityColor, TremorColors.severe);
    });

    test('assigns low severity color for micro earthquakes', () {
      final lowEntity = EarthquakeEntity(
        id: 'q_low',
        mag: 2.1,
        place: 'Reno, NV',
        time: DateTime.now(),
        coordinates: (lat: 39.5, lng: -119.8),
      );

      final uiModel = mapper.toUiModel(lowEntity);

      expect(uiModel.formattedMag, '2.1');
      expect(uiModel.severityColor, TremorColors.low);
    });
  });
}
