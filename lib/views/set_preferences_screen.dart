import 'package:flutter/material.dart';
import 'package:restau/viewmodels/log_in_viewmodel.dart';
import 'package:restau/views/auth_screen.dart';

class SetPreferencesScreen extends StatefulWidget {
  const SetPreferencesScreen({super.key, required this.mail, required this.user, required this.password});

  final String mail;
  final String user;
  final String password;

  @override
  State<SetPreferencesScreen> createState() => _SetPreferencesScreenState();
}

class _SetPreferencesScreenState extends State<SetPreferencesScreen> {
  String? _errorMessage;
  final LogInViewmodel vm = LogInViewmodel();
  
  // A set to keep track of selected preferences
  Set<String> selectedPreferences = {};

  void attemptRegister() async {

    vm.registerUser(widget.mail, widget.user, widget.password, selectedPreferences.toList());
    
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AuthScreen(),
      ),
    ); 
    
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
              "Tell us what\nyou like!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            // The FutureBuilder wrapped inside Expanded to take up available space
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
                    // Data is available, we process it
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
                                    scrollDirection: Axis.horizontal, // Allows horizontal scrolling
                                    child: Row(
                                      children: options.map((option) {
                                        // Determine the button color based on whether the option is selected
                                        final bool isSelected = selectedPreferences.contains(option.toString());
                                        final Color buttonColor = isSelected ? const Color(0xFFFFEEAD) : Colors.white;

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all(buttonColor),
                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                                ),
                                              ),
                                              elevation: WidgetStateProperty.all(5.0), // Shadow elevation
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                // Toggle selection: add or remove from the set
                                                if (isSelected) {
                                                  selectedPreferences.remove(option.toString());
                                                } else {
                                                  selectedPreferences.add(option.toString());
                                                }
                                              });
                                            },
                                            child: Text(
                                              option.toString(),
                                              style: const TextStyle(
                                                color: Colors.black, // Text color
                                                fontFamily: 'Poppins', // Font family
                                                fontSize: 16.0, // Optional: You can adjust the font size
                                              ),
                                            ),
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
                }
              ),
            ),
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
