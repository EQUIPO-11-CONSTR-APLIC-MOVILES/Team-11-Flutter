import 'package:flutter/material.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/widgets/restaurant_card/restaurant_item.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key, required this.restaurants});

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (ctx, index) => Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
        child: RestaurantItem(
          restaurant: restaurants[index],
        ),
      ),
    );
  }
}
