import 'package:flutter/material.dart';
import 'package:restau/navigation/user_viewmodel.dart';

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  UserViewModel vm = UserViewModel();
  String? restaurants;

  // This method is now asynchronous
  void ponerRestaurante() async {
    await vm.likeRestaurant('ASGwnFThCchDFGncxn84'); // Await the like operation
    _updateRestaurants(); // Call a separate method to update the state
  }

  // This method is also asynchronous
  void quitar() async {
    await vm
        .unlikeRestaurant('ASGwnFThCchDFGncxn84'); // Await the unlike operation
    _updateRestaurants(); // Call a separate method to update the state
  }

  // This method fetches the liked restaurants and updates the state
  Future<void> _updateRestaurants() async {
    // Await the fetching of liked restaurants
    final likedRestaurants = await vm.getLikedRestaurants();
    setState(() {
      restaurants = likedRestaurants
          .toString(); // Update the state with fetched restaurants
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
            /** mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
          children: [
            FilledButton(onPressed: ponerRestaurante, child: const Text('Poner Restaurante')),
            FilledButton(onPressed: quitar, child: const Text('Quitar Restaurante')),
            if (restaurants != null) ...[
              Text(restaurants!)
            ]
          ],
        */
            ),
      ),
    );
  }
}
