import 'package:flutter/material.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/models/restaurant_repository.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/widgets/restaurant_card/restaurant_list.dart';
import 'package:restau/home/home_viewmodel.dart';
import 'package:restau/widgets/button_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantRepository restaurantRepository = RestaurantRepository();
  final UserViewModel user = UserViewModel();
  final HomeViewModel homeViewModel = HomeViewModel();

  // Current selected button (0 = All, 1 = Open Now, 2 = For You)
  int selectedIndex = 0;

  // Function to handle button press and change the selected button
  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          restaurantRepository.getAllRestaurants(),
          user.getUserInfo(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            final userInfo = snapshot.data![1] as Map<String, dynamic>;
            final filteredRestaurants = homeViewModel.filterRestaurants(
              snapshot.data![0] as List<Restaurant>,
              selectedIndex,
              userInfo,
            );
            return Column(
              children: [
                // Buttons Row
                ButtonRow(
                  selectedIndex: selectedIndex,
                  onButtonPressed: onButtonPressed,
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
