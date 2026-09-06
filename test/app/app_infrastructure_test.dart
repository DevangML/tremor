import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/app/index.dart';
import 'package:tremor/main.dart' as entry;

void main() {
  group('App Infrastructure', () {
    test('EnvConfig constants are correctly configured', () {
      const config = EnvConfig.dev;
      expect(config.environment, Environment.dev);
      expect(config.apiBaseUrl, contains('earthquake.usgs.gov'));
      expect(config.enableDetailedLogs, isTrue);
    });

    test('ServiceLocator initializes all singletons properly', () {
      final locator = ServiceLocator.instance
        ..initialize(config: EnvConfig.dev);

      expect(locator.envConfig.environment, Environment.dev);
      expect(locator.logger, isNotNull);
      expect(locator.analytics, isNotNull);
      expect(locator.secureVault, isNotNull);
      expect(locator.hapticGateway, isNotNull);
      expect(locator.syncStorage, isNotNull);
      expect(locator.remoteDataSource, isNotNull);
      expect(locator.dtoMapper, isNotNull);
      expect(locator.earthquakeRepository, isNotNull);
      expect(locator.triageService, isNotNull);
      expect(locator.getEarthquakeQuery, isNotNull);
      expect(locator.filterEarthquakesQuery, isNotNull);
      expect(locator.triageEarthquakeCommand, isNotNull);
      expect(locator.applicationService, isNotNull);
      expect(locator.emergencyAlertOrchestrator, isNotNull);
      expect(locator.hazardAssessmentOrchestrator, isNotNull);
      expect(locator.presentationMapper, isNotNull);
    });

    testWidgets('AppRouter generates valid routes for home and unknown', (
      tester,
    ) async {
      final homeRoute = AppRouter.onGenerateRoute(
        const RouteSettings(name: AppRouter.home),
      );
      expect(homeRoute, isA<MaterialPageRoute<void>>());

      final unknownRoute = AppRouter.onGenerateRoute(
        const RouteSettings(name: '/unknown_path'),
      );
      expect(unknownRoute, isA<MaterialPageRoute<void>>());

      await tester.pumpWidget(
        const MaterialApp(
          key: ValueKey('home_app'),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: AppRouter.home,
        ),
      );
      expect(find.text('Tremor Active'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          key: ValueKey('unknown_app'),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: '/unknown_path',
        ),
      );
      expect(find.text('Route Not Found'), findsOneWidget);
    });

    testWidgets('bootstrap starts app binding and executes builder', (
      tester,
    ) async {
      var appBuilt = false;
      await bootstrap(() {
        appBuilt = true;
        return const SizedBox();
      });
      expect(appBuilt, isTrue);

      final errorHandler = ui.PlatformDispatcher.instance.onError;
      expect(errorHandler, isNotNull);
      final handled = errorHandler!(
        Exception('Mock unhandled'),
        StackTrace.empty,
      );
      expect(handled, isTrue);
    });

    testWidgets('TremorApp and main() render main entry point with DI tree', (
      tester,
    ) async {
      ServiceLocator.instance.initialize(config: EnvConfig.dev);
      await tester.pumpWidget(const entry.TremorApp());
      expect(find.text('Tremor Live Monitor'), findsOneWidget);

      expect(entry.main, returnsNormally);
    });
  });
}
