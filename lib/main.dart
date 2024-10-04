import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:restau/auth/auth_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure that the app runs in portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up Firebase Crashlytics to log Flutter errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Capture errors in the zone (this catches errors in async operations)
  runZonedGuarded<Future<void>>(() async {
    runApp(const RestaUApp());
  }, (error, stackTrace) {
    // Log Dart errors that are outside Flutter framework (asynchronous errors)
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
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
