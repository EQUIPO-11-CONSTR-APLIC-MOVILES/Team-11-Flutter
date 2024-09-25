import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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