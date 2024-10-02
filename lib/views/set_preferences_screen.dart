import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SetPreferencesScreen extends StatefulWidget {
  const SetPreferencesScreen({super.key, required String mail, required String user, required String password});

  @override
  State<SetPreferencesScreen> createState() => _SetPreferencesScreenState();
}

class _SetPreferencesScreenState extends State<SetPreferencesScreen> {
  String? _errorMessage; 
  void attemptRegister(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(51),
        child: Column(
          children: [
            const Text(
              "Tell us what you like!",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Error message shown if sign-in fails
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: attemptRegister,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFFD9534F)),
                ),
                child: const Text('Let\'s go!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}