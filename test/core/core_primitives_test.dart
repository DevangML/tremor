import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/index.dart';

void main() {
  group('Core Primitives & Services Unit Tests', () {
    test('ConsoleAnalyticsTracker logs events without throwing', () async {
      const tracker = ConsoleAnalyticsTracker();
      await expectLater(
        tracker.logEvent('test_event', {'param': 'value'}),
        completes,
      );
    });

    test(
      'PlatformHapticDriver triggers haptic call without throwing',
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        const driver = PlatformHapticDriver();
        await expectLater(driver.triggerSevereAlertHaptic(), completes);
      },
    );

    test('AppLogger outputs info and error logs safely', () {
      const logger = AppLogger();
      expect(() => logger.info('Test Info Message'), returnsNormally);
      expect(
        () => logger.error(
          'Test Error Message',
          Exception('Failure'),
          StackTrace.empty,
        ),
        returnsNormally,
      );
    });

    test('SecureVault masks keys longer than 4 chars and short keys', () {
      final vaultLong = SecureVault('ABCDEF123456');
      expect(vaultLong.maskedKey, 'ABCD****');

      final vaultShort = SecureVault('ABC');
      expect(vaultShort.maskedKey, '****');
    });

    test('InMemorySyncStorage saves and retrieves sync timestamps', () async {
      final storage = InMemorySyncStorage();
      expect(await storage.getLastSyncTime('earthquakes'), isNull);

      final now = DateTime.now();
      await storage.saveLastSyncTime('earthquakes', now);
      final retrieved = await storage.getLastSyncTime('earthquakes');
      expect(retrieved, now);
    });

    test('TremorColors provides correct severity colors across thresholds', () {
      expect(TremorColors.severityColor(1.5), TremorColors.low);
      expect(TremorColors.severityColor(2.9), TremorColors.low);
      expect(TremorColors.severityColor(3), TremorColors.moderate);
      expect(TremorColors.severityColor(4.9), TremorColors.moderate);
      expect(TremorColors.severityColor(5), TremorColors.severe);
      expect(TremorColors.severityColor(8.5), TremorColors.severe);
    });

    test('Failures instantiate with default and custom messages/codes', () {
      final defaultServer = ServerFailure();
      expect(defaultServer.message, 'Server Error');
      expect(defaultServer.code, isNull);

      final customServer = ServerFailure('Custom Msg', 500);
      expect(customServer.message, 'Custom Msg');
      expect(customServer.code, 500);

      final defaultNet = NetworkError();
      expect(defaultNet.message, 'Network Error');
      expect(defaultNet.code, isNull);

      final customNet = NetworkError('Timeout', 408);
      expect(customNet.message, 'Timeout');
      expect(customNet.code, 408);
    });

    test('Result class supports Success and FailureResult pattern match', () {
      final Result<int, Failure> success = Success(42);
      final Result<int, Failure> failure = FailureResult(ServerFailure('Down'));

      final sVal = switch (success) {
        Success(:final value) => value,
        FailureResult() => 0,
      };
      expect(sVal, 42);

      final fVal = switch (failure) {
        Success() => 'none',
        FailureResult(:final value) => value.message,
      };
      expect(fVal, 'Down');
    });
  });
}
