import 'package:flutter/material.dart';
import '../models/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: RestaurantList(),
    );
  }
}

class RestaurantList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
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
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              final name = restaurant['name'] ?? 'No name';
              final address = restaurant['placeName'] ?? 'No address';
              return ListTile(
                title: Text(name),
                subtitle: Text(address),
              );
            },
          );
        }
      },
    );
  }
}