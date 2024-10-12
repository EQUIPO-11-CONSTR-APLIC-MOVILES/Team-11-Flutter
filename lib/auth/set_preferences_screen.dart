import 'package:flutter/material.dart';
import 'package:restau/auth/register_viewmodel.dart';
import 'package:restau/auth/auth_screen.dart';
import 'package:restau/widgets/preference_button.dart';

class SetPreferencesScreen extends StatelessWidget {
  const SetPreferencesScreen({super.key, required this.mail, required this.user, required this.password});

  final String mail;
  final String user;
  final String password;

  @override
  Widget build(BuildContext context) {
    final RegisterViewModel vm = RegisterViewModel();
    Set<String> selectedPreferences = {};

    void attemptRegister() async {
      vm.registerUser(mail, user, password, selectedPreferences.toList());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(51),
        child: Column(
          children: [
            const Text(
              "Tell us what\nyou like!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>?>(
                future: vm.getAllPreferences(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No preferences found'));
                  } else {
                    var preferences = snapshot.data!;
                    return ListView(
                      children: preferences.map((preferenceMap) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: preferenceMap.entries.map((categoryEntry) {
                            final categoryKey = categoryEntry.key;
                            final categoryDetails = categoryEntry.value;
                            final List<dynamic> options = categoryDetails['list'];

                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoryKey,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: options.map((option) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: PreferenceButton(
                                            option: option.toString(),
                                            selectedPreferences: selectedPreferences,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
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