import 'package:flutter/material.dart';

final class AppRouter {
  const new _();

  static const String home = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      home => MaterialPageRoute<void>(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Tremor Active'))),
      ),
      _ => MaterialPageRoute<void>(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Route Not Found'))),
      ),
    };
  }
}
