import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:tremor/app/index.dart' show EnvConfig, ServiceLocator;

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize central DI composition root:
  ServiceLocator.instance.initialize(config: EnvConfig.dev);

  // Global platform error interceptor:
  PlatformDispatcher.instance.onError = (error, stack) {
    ServiceLocator.instance.logger.error('Unhandled Root Error', error, stack);
    return true;
  };

  runApp(await builder());
}
