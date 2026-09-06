import 'package:flutter/material.dart';

void main() {
  runApp(const TremorApp());
}

class TremorApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tremor',
      home: Scaffold(
        body: Center(child: Text('Blank Slate')),
      ),
    );
  }
}
