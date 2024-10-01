import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/widgets/restaurant_card/restaurant_list.dart';
import '../models/firestore_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final Timestamp now = Timestamp.now();

  // Function to get the current day name (e.g., "monday")
  String getCurrentDay() {
    final now = DateTime.now();
    return DateFormat('EEEE').format(now).toLowerCase();
  }

  // Function to get the current time in HHMM format (e.g., 1530 for 3:30 PM)
  int getCurrentTime() {
    final now = DateTime.now();
    return now.hour * 100 + now.minute; // Convert to HHMM format
  }

  // Current selected button (0 = All, 1 = Open Now, 2 = For You)
  int selectedIndex = 0;

  // This function filters the restaurants based on the selected button
  List<Restaurant> filterRestaurants(
      List<Restaurant> restaurants, int selectedIndex) {
    if (selectedIndex == 1) {
      // "Open Now" filter logic
      final currentDay = getCurrentDay();
      final currentTime = getCurrentTime();

      return restaurants.where((restaurant) {
        if (restaurant.schedule.containsKey(currentDay)) {
          final daySchedule = restaurant.schedule[currentDay];
          final start = daySchedule?['start'] ?? 0;
          final end = daySchedule?['end'] ?? 2359;

          final startInt = int.parse(start.toString());
          final endInt = int.parse(end.toString());

          return currentTime >= startInt && currentTime <= endInt;
        }
        return false;
      }).toList();
    } else if (selectedIndex == 2) {
      // Filter for "For You" logic (e.g., personalized recommendations)
      return restaurants.where((restaurant) {
        return true; // Replace with "for you" condition
      }).toList();
    }
    // If "All" is selected, return all restaurants
    return restaurants;
  }

  // Function to handle button press and change the selected button
  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Function to cast restaurant data to List<Restaurant>
  List<Restaurant> castToRestaurantList(
      List<Map<String, dynamic>> snapshotData) {
    return snapshotData.map((restaurantData) {
      return Restaurant(
        averageRating: restaurantData['averageRating'],
        categories: List<String>.from(restaurantData['categories']),
        imageUrl: restaurantData['imageUrl'],
        latitude: restaurantData['latitude'],
        longitude: restaurantData['longitude'],
        name: restaurantData['name'],
        openingDate: restaurantData['openingDate'],
        placeName: restaurantData['placeName'],
        schedule:
            Map<String, Map<String, dynamic>>.from(restaurantData['schedule']),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home screen"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: firestoreService.getAllRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No restaurants found'));
          } else {
            final restaurants = snapshot.data!;
            final _registeredRestaurants = castToRestaurantList(restaurants);
            final filteredRestaurants =
                filterRestaurants(_registeredRestaurants, selectedIndex);

            return Column(
              children: [
                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // "All" Button
                    ElevatedButton(
                      onPressed: () => onButtonPressed(0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 0
                            ? const Color(0xFFD9534F)
                            : Colors.grey.shade200, // Red if selected
                        foregroundColor:
                            selectedIndex == 0 ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text("All"),
                    ),
                    // "Open Now" Button
                    ElevatedButton(
                      onPressed: () => onButtonPressed(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 1
                            ? const Color(0xFFD9534F)
                            : Colors.grey.shade200,
                        foregroundColor:
                            selectedIndex == 1 ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text("Open Now"),
                    ),
                    // "For You" Button
                    ElevatedButton(
                      onPressed: () => onButtonPressed(2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 2
                            ? const Color(0xFFD9534F)
                            : Colors.grey.shade200,
                        foregroundColor:
                            selectedIndex == 2 ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text("For You"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Restaurant list
                Expanded(
                  child: RestaurantList(restaurants: filteredRestaurants),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
