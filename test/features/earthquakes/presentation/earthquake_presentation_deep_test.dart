import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/index.dart';
import 'package:tremor/features/earthquakes/application/index.dart';
import 'package:tremor/features/earthquakes/domain/index.dart';
import 'package:tremor/features/earthquakes/presentation/index.dart';

final class SpyRepository implements EarthquakeRepository {
  new({required this.quakes, this.shouldFail = false});

  final List<EarthquakeEntity> quakes;
  final bool shouldFail;

  @override
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (shouldFail) {
      return FailureResult(ServerFailure('Repo Down'));
    }
    return Success(quakes);
  }

  @override
  Future<Result<void, Failure>> markAsTriaged(String id) async =>
      Success(null);
}

final class SpyHapticGateway implements HapticGateway {
  @override
  Future<void> triggerSevereAlertHaptic() async {}
}

void main() {
  group('EarthquakePresentationBloc & Widgets Deep Coverage', () {
    test('EarthquakeEvent and EarthquakeState instantiate properly', () {
      final fetch = FetchEarthquakesEvent();
      expect(fetch, isA<EarthquakeEvent>());

      final filter = FilterByMagnitudeEvent(4.5);
      expect(filter.minMagnitude, 4.5);

      final initial = EarthquakeInitialState();
      expect(initial, isA<EarthquakeState>());

      final loading = EarthquakeLoadingState();
      expect(loading, isA<EarthquakeState>());

      final loaded = EarthquakeLoadedState(earthquakes: []);
      expect(loaded.earthquakes, isEmpty);
      expect(loaded.selectedMinMag, equals(2.0));

      final loadedFiltered = EarthquakeLoadedState(
        earthquakes: [],
        selectedMinMag: 4.5,
      );
      expect(loadedFiltered.selectedMinMag, equals(4.5));

      final error = EarthquakeErrorState('Failed to fetch');
      expect(error.message, 'Failed to fetch');
    });

    testWidgets(
      'MagnitudeRingPainter repaints when mag or color changes',
      (tester) async {
        const painter1 = MagnitudeRingPainter(mag: 4.5, color: Colors.amber);
        const painter2 = MagnitudeRingPainter(mag: 5.5, color: Colors.amber);
        const painter3 = MagnitudeRingPainter(mag: 4.5, color: Colors.red);
        const painterSame = MagnitudeRingPainter(mag: 4.5, color: Colors.amber);

        expect(painter1.shouldRepaint(painterSame), isFalse);
        expect(painter1.shouldRepaint(painter2), isTrue);
        expect(painter1.shouldRepaint(painter3), isTrue);
      },
    );

    testWidgets(
      'EarthquakeFeedPage renders error state and handles FAB tap',
      (tester) async {
        final query = GetEarthquakeQuery(
          SpyRepository(quakes: [], shouldFail: true),
        );
        final cmd = TriageEarthquakeCommand(
          SpyRepository(quakes: [], shouldFail: true),
        );
        final orchestrator = EmergencyAlertOrchestrator(
          query: query,
          command: cmd,
          hapticGateway: SpyHapticGateway(),
          triageService: const EarthquakeTriageService(),
        );
        final bloc = EarthquakeBloc(
          orchestrator: orchestrator,
          mapper: const EarthquakePresentationMapper(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<EarthquakeBloc>.value(
              value: bloc,
              child: const EarthquakeFeedPage(),
            ),
          ),
        );

        // Tap FAB to trigger FetchEarthquakesEvent that leads to error state:
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Repo Down'), findsOneWidget);
      },
    );
  });
}
