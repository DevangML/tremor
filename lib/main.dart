import 'package:flutter/material.dart';

void main() {
  runApp(const TremorApp());
}

class TremorApp extends StatelessWidget {
  const TremorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tremor',
      home: const Scaffold(
        body: Center(child: Text('Blank Slate')),
      ),
    );
  }
}
