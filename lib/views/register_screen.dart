import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:restau/viewmodels/log_in_viewmodel.dart';
import 'package:restau/views/log_in_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  LogInViewmodel vm = LogInViewmodel();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        double imageSize = 0.3 * screenWidth;
        double elementSpacing = 0.04 * screenHeight;
        
        bool _obscurePassword = true;
        String? _errorMessage; 

        void signIn() {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LogInScreen(),
            ),
          );
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

        void attemptSignIn() async {
          setState(() {
            _errorMessage = null; 
          });

          final ans = vm.checkValidUser(mailController.text, userController.text,passwordController.text);
          if (ans == "email"){
            setState(() {
              _errorMessage = "Invalid email.";
            });
          } else if (ans == "password"){
            setState(() {
              _errorMessage = "Passwords should have between 6 and 32 characters.";
            });
          } else if (ans == "user"){
            setState(() {
              _errorMessage = "Invalid user.";
            });
          } else {
            Navigator();
          }
          setState(() {
            _errorMessage = "Sign-up failed.";
          });
        }

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
                      "Create Account",
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
                    hintText: 'Name',
                    hintStyle: TextStyle(fontFamily: "Poppins"),
                    prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: elementSpacing),
                TextField(
                  controller: mailController,
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
                  controller: mailController,
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
                const Spacer(), // Pushes the "Sign Up" to the bottom
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFFB1B1B1),
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign In',
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFFD9534F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = signIn, // Call the signUp function when tapped
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