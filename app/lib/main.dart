import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: CupidDateApp()));
}

class CupidDateApp extends StatelessWidget {
  const CupidDateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cupid Date',
      home: Scaffold(
        body: Center(
          child: Text('Cupid Date'),
        ),
      ),
    );
  }
}
