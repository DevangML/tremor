import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/features/earthquakes/domain/index.dart' show HazardLevel;

void main() {
  group('HazardLevel Extension Type (Dart 3.13+ Value Object)', () {
    test('classifies risk levels correctly based on integer scale', () {
      final runtimeScore = DateTime.now().year > 2000 ? 1 : 0;
      final runtimeHazard = HazardLevel(runtimeScore);
      expect(runtimeHazard.score, equals(1));

      const low = HazardLevel(1);
      const moderate = HazardLevel(2);
      const high = HazardLevel(3);
      const catastrophic = HazardLevel(4);

      expect(low.isTsunamiRisk, isFalse);
      expect(low.isStructuralRisk, isFalse);
      expect(low.severityLabel, equals('Low Risk'));

      expect(moderate.isTsunamiRisk, isFalse);
      expect(moderate.isStructuralRisk, isFalse);
      expect(moderate.severityLabel, equals('Moderate Advisory'));

      expect(high.isTsunamiRisk, isTrue);
      expect(high.isStructuralRisk, isTrue);
      expect(high.severityLabel, equals('High Alert'));

      expect(catastrophic.isTsunamiRisk, isTrue);
      expect(catastrophic.isStructuralRisk, isTrue);
      expect(catastrophic.severityLabel, equals('Catastrophic Emergency'));

      const unknown = HazardLevel(99);
      expect(unknown.severityLabel, equals('Unclassified Risk'));
    });

    test('evaluates hazard level from seismic magnitude and focal depth', () {
      // Shallow depth (<= 50km) and high magnitude (>= 7.0) -> Catastrophic (4)
      final cat = HazardLevel.fromSeismicData(mag: 7.2, depthKm: 15);
      expect(cat, equals(const HazardLevel(4)));

      // Shallow depth (<= 50km) and strong magnitude (>= 6.0) -> High (3)
      final high = HazardLevel.fromSeismicData(mag: 6.5, depthKm: 20);
      expect(high, equals(const HazardLevel(3)));

      // Deep earthquake (> 50km) with high magnitude -> Moderate (2)
      final deepModerate = HazardLevel.fromSeismicData(mag: 6.5, depthKm: 70);
      expect(deepModerate, equals(const HazardLevel(2)));

      // Moderate magnitude (>= 4.0 and < 6.0) shallow -> Moderate (2)
      final shallowMod = HazardLevel.fromSeismicData(mag: 4.8, depthKm: 10);
      expect(shallowMod, equals(const HazardLevel(2)));

      // Low magnitude (< 4.0) -> Low (1)
      final low = HazardLevel.fromSeismicData(mag: 3.2, depthKm: 5);
      expect(low, equals(const HazardLevel(1)));
    });

    test('validates score range bounds', () {
      expect(HazardLevel.isValidScore(1), isTrue);
      expect(HazardLevel.isValidScore(4), isTrue);
      expect(HazardLevel.isValidScore(0), isFalse);
      expect(HazardLevel.isValidScore(5), isFalse);
    });
  });
}
