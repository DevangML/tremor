import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/index.dart'
    show Failure, HapticGateway, Result, Success;
import 'package:tremor/features/earthquakes/application/index.dart'
    show
        EmergencyAlertOrchestrator,
        GetEarthquakeQuery,
        TriageEarthquakeCommand;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity, EarthquakeRepository, EarthquakeTriageService;
import 'package:tremor/features/earthquakes/presentation/index.dart'
    show
        EarthquakeBloc,
        EarthquakeFeedPage,
        EarthquakePresentationMapper;

final class TestRepo implements EarthquakeRepository {
  new(this.quakes);

  final List<EarthquakeEntity> quakes;

  @override
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes() async {
    // Artificial delay to simulate real I/O and let the spinner show:
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return Success(quakes);
  }

  @override
  Future<Result<void, Failure>> markAsTriaged(String id) async =>
      Success(null);
}

final class DummyHaptic implements HapticGateway {
  @override
  Future<void> triggerSevereAlertHaptic() async {}
}

void main() {
  group('EarthquakeFeedPage (Widget & Viewport Tests)', () {
    testWidgets(
      'renders Idle view and transitions to Loaded view on tap',
      (tester) async {
        final repo = TestRepo([
          EarthquakeEntity(
            id: '1',
            mag: 6.8,
            place: 'San Francisco, CA',
            time: DateTime.fromMillisecondsSinceEpoch(1672531199000),
            coordinates: (lat: 37.7749, lng: -122.4194),
          ),
        ]);
        final query = GetEarthquakeQuery(repo);
        final cmd = TriageEarthquakeCommand(repo);
        final orchestrator = EmergencyAlertOrchestrator(
          query: query,
          command: cmd,
          hapticGateway: DummyHaptic(),
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

        expect(find.text('Tremor Live Monitor'), findsOneWidget);
        expect(find.text('Scan Active Quakes'), findsOneWidget);

        // Tap scan button
        await tester.tap(find.text('Scan Active Quakes'));
        await tester.pump(); // Advance frame to render indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Advance timer and settle final loaded state:
        await tester.pumpAndSettle();
        expect(find.text('Active Tremors'), findsAtLeastNWidgets(1));
        expect(find.text('San Francisco, CA'), findsOneWidget);
        expect(find.text('6.8'), findsOneWidget);

        // Tap filter chip for 5.0+ (Severe)
        expect(find.text('5.0+ (Severe)'), findsOneWidget);
        await tester.tap(find.text('5.0+ (Severe)'));
        await tester.pumpAndSettle();
        expect(find.text('San Francisco, CA'), findsOneWidget);

        // Tap filter chip for 3.0+
        await tester.tap(find.text('3.0+'));
        await tester.pumpAndSettle();
        expect(find.text('San Francisco, CA'), findsOneWidget);
      },
    );
  });
}
