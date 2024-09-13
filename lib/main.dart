import 'package:flutter/material.dart';
import 'screens/navigator_screen.dart';
import 'theme.dart';

void main() {
  runApp(const RestaUApp());
}

class RestaUApp extends StatelessWidget {
  const RestaUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RestaU',
      theme: restauTheme,
      home: NavigatorScreen(),
    );
  }
}