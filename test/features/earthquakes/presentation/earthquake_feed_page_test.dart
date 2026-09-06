import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/error/failures.dart';
import 'package:tremor/core/hardware/haptic_gateway.dart';
import 'package:tremor/core/result/result.dart';
import 'package:tremor/features/earthquakes/application/commands/triage_earthquake_command.dart';
import 'package:tremor/features/earthquakes/application/orchestrators/emergency_alert_orchestrator.dart';
import 'package:tremor/features/earthquakes/application/queries/get_earthquake_query.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';
import 'package:tremor/features/earthquakes/domain/repositories/earthquake_repository.dart';
import 'package:tremor/features/earthquakes/domain/services/earthquake_triage_service.dart';
import 'package:tremor/features/earthquakes/presentation/bloc/earthquake_bloc.dart';
import 'package:tremor/features/earthquakes/presentation/mappers/earthquake_presentation_mapper.dart';
import 'package:tremor/features/earthquakes/presentation/pages/earthquake_feed_page.dart';

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
      },
    );
  });
}
