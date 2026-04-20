import 'package:cupid_date/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: CupidDateApp()));
}

class CupidDateApp extends StatelessWidget {
  const CupidDateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cupid Date',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('Cupid Date')),
      ),
    );
  }
}
