import 'package:flutter/material.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const RestaUApp());
}

class RestaUApp extends StatelessWidget {
  const RestaUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'RestaU',
      home: SplashScreen(),
    );
  }
}