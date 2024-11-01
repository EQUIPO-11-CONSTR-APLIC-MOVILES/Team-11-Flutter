import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:restau/auth/log_in_screen.dart";
import "package:restau/navigation/navigator_screen.dart";

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              return WillPopScope(
              onWillPop: () async {
                // Returning false prevents the back action
                return false;
              },
              child: const NavigatorScreen(),
            );
            } else {
              return const LogInScreen();
            }
          }
        )
    );
  }
}