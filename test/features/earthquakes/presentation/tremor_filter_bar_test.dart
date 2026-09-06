import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/features/earthquakes/presentation/index.dart'
    show TremorFilterBarDelegate, TremorFilterBarWidget;

void main() {
  group('TremorFilterBarWidget & Sliver Delegate', () {
    testWidgets(
      'renders filter chips and triggers magnitude selection callback',
      (tester) async {
        double? selectedMag;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TremorFilterBarWidget(
                selectedMinMag: 3,
                onMagnitudeSelected: (mag) => selectedMag = mag,
              ),
            ),
          ),
        );

        expect(find.text('All (2.0+)'), findsOneWidget);
        expect(find.text('3.0+'), findsOneWidget);
        expect(find.text('5.0+ (Severe)'), findsOneWidget);

        await tester.tap(find.text('5.0+ (Severe)'));
        await tester.pump();

        expect(selectedMag, equals(5.0));
      },
    );

    testWidgets('Sliver delegate enforces geometry and rebuild contracts', (
      tester,
    ) async {
      double? chosenMag;
      final delegate1 = TremorFilterBarDelegate(
        selectedMinMag: 2,
        onMagnitudeSelected: (mag) => chosenMag = mag,
      );
      final delegateSame = TremorFilterBarDelegate(
        selectedMinMag: 2,
        onMagnitudeSelected: (mag) => chosenMag = mag,
      );
      final delegateDifferent = TremorFilterBarDelegate(
        selectedMinMag: 5,
        onMagnitudeSelected: (mag) => chosenMag = mag,
      );

      expect(delegate1.minExtent, equals(56));
      expect(delegate1.maxExtent, equals(56));
      expect(delegate1.shouldRebuild(delegateSame), isFalse);
      expect(delegate1.shouldRebuild(delegateDifferent), isTrue);
      expect(chosenMag, isNull);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: delegate1,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('All (2.0+)'), findsOneWidget);
    });
  });
}
