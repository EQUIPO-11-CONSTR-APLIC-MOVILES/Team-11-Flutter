import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restau/liked/liked_viewmodel.dart';
import 'package:restau/models/firestore_service.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/widgets/restaurant_card/restaurant_list.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({super.key});

  @override
  _LikedScreenState createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final UserViewModel vm = UserViewModel();
  final LikedViewModel lvm = LikedViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          lvm.getAllRestaurants(),
          vm.getLikedRestaurants(), // Fetch the liked restaurant IDs
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            final restaurants = snapshot.data![0] as List<Map<String, dynamic>>;
            final likedRestaurantIds = snapshot.data![1] as List<String>; // Liked restaurant IDs
            final likedRestaurants = lvm.castToRestaurantList(restaurants, likedRestaurantIds);
            
            return Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: likedRestaurants.isNotEmpty
                      ? RestaurantList(restaurants: likedRestaurants)
                      : const Center(child: Text('No liked restaurants found')),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
