import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:restau/viewmodels/log_in_viewmodel.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  LogInViewmodel vm = LogInViewmodel();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _errorMessage; // Variable to hold the error message

  void attemptSignIn() async {
    setState(() {
      _errorMessage = null; // Reset error message
    });

    vm.logIn(userController.text, passwordController.text);

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _errorMessage = "Sign-in failed.";
    });
  }

  void signInGoogle() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      // TODO: remove
      email: 'a@a.com',
      password: 'aaaaaa',
    );
  }

  void signUp() {
    print("Sign up");
  }

  void showPassword() {
    setState(() {
      _obscurePassword = false;
    });
  }

  void hidePassword() {
    setState(() {
      _obscurePassword = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        double imageSize = 0.3 * screenWidth;
        double elementSpacing = 0.04 * screenHeight;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(51),
            child: Column(
              children: [
                SizedBox(
                  width: imageSize, // Image is 35% of the screen width
                  child: Image.asset(
                    'lib/assets/drawable/restau.png',
                    color: const Color(0xFFD9534F),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: elementSpacing),
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(fontFamily: "Poppins"),
                    prefixIcon: Icon(Icons.mail_outline, color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: elementSpacing),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                    suffixIcon: GestureDetector(
                      onLongPress: showPassword,
                      onLongPressUp: hidePassword,
                      child: const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Color(0xFFD9534F),
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: elementSpacing),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: attemptSignIn,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color(0xFFD9534F)),
                    ),
                    child: const Text('Sign In'),
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
                SizedBox(height: elementSpacing),
                const Text.rich(TextSpan(
                  text: '────────── ', // default text style
                  children: <TextSpan>[
                    TextSpan(text: ' OR ', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                    TextSpan(text: ' ──────────'),
                  ],
                )),
                SizedBox(height: elementSpacing),
                SignInButton(
                  Buttons.google,
                  onPressed: signInGoogle,
                ),
                const Spacer(), // Pushes the "Sign Up" to the bottom
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFFB1B1B1),
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFFD9534F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = signUp, // Call the signUp function when tapped
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
