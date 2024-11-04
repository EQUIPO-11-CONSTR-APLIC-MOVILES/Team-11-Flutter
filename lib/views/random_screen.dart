import 'package:flutter/material.dart';
import 'dart:math';
import 'package:restau/models/restaurant.dart';
import 'package:restau/models/restaurant_repository.dart';
import 'package:restau/detail/detail_screen.dart';

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => RandomScreenState();
}

class RandomScreenState extends State<RandomScreen> {
  final RestaurantRepository restaurantRepository = RestaurantRepository();
  Restaurant? randomRestaurant;

  @override
  void initState() {
    super.initState();
    fetchRandomRestaurant();
  }

  Future<void> fetchRandomRestaurant() async {
    List<Restaurant> restaurants = await restaurantRepository.getAllRestaurants();
    if (restaurants.isNotEmpty) {
      final random = Random();
      setState(() {
        randomRestaurant = restaurants[random.nextInt(restaurants.length)];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: randomRestaurant == null
                ? const CircularProgressIndicator()
                : DetailScreen(restaurant: randomRestaurant!, isRandom: true),
          ),
        ],
      ),
    );
  }
}