import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tremor/app/index.dart' show ServiceLocator, bootstrap;
import 'package:tremor/features/earthquakes/presentation/index.dart'
    show EarthquakeBloc, EarthquakeFeedPage;

Future<void> main() async {
  await bootstrap(() => const TremorApp());
}

class TremorApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tremor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: BlocProvider(
        create: (_) => EarthquakeBloc(
          orchestrator: ServiceLocator.instance.emergencyAlertOrchestrator,
          mapper: ServiceLocator.instance.presentationMapper,
        ),
        child: const EarthquakeFeedPage(),
      ),
    );
  }
}
