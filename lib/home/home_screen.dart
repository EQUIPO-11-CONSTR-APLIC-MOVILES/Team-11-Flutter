import 'package:flutter/material.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/models/restaurant_repository.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/review/review_viewmodel.dart';
import 'package:restau/widgets/restaurant_card/restaurant_list.dart';
import 'package:restau/home/home_viewmodel.dart';
import 'package:restau/widgets/button_row.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantRepository restaurantRepository = RestaurantRepository();
  final UserViewModel user = UserViewModel();
  final ReviewViewmodel reviews = ReviewViewmodel();
  final HomeViewModel homeViewModel = HomeViewModel();

  int selectedIndex = 0;
  int reviewedPercentage = 0;

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _showNoConnectionDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
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
                  Connectivity().checkConnectivity().then((connectivityResult) {
                    if (connectivityResult == ConnectivityResult.none) {
                      _showNoConnectionDialog();
                    }
                  });
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
                      ButtonRow(
                        selectedIndex: selectedIndex,
                        onButtonPressed: onButtonPressed,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: RestaurantList(
                          restaurants: filteredRestaurants,
                          showReviewPercentage: true,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
