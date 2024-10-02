import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restau/views/auth_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RestaUApp());
}

class RestaUApp extends StatelessWidget {
  const RestaUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RestaU',
      home: AuthScreen(),
    );
  }
}
