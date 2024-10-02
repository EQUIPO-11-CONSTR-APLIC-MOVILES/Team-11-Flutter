import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:restau/views/log_in_screen.dart";
import "package:restau/views/navigator_screen.dart";

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              return const NavigatorScreen();
            } else {
              return const LogInScreen();
            }
          }
        )
    );
  }
}