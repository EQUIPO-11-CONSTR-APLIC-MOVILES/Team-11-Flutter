import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restau/models/restaurant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all restaurants and cast to List<Restaurant>
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('restaurants').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> restaurantData =
            doc.data() as Map<String, dynamic>;
        return Restaurant(
          averageRating: restaurantData['averageRating'],
          categories: List<String>.from(restaurantData['categories']),
          imageUrl: restaurantData['imageUrl'],
          latitude: restaurantData['latitude'],
          longitude: restaurantData['longitude'],
          name: restaurantData['name'],
          openingDate: restaurantData['openingDate'],
          placeName: restaurantData['placeName'],
          schedule: Map<String, Map<String, dynamic>>.from(
              restaurantData['schedule']),
          id: doc.id,
          description: restaurantData['description'],
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Fetch all restaurants and include the restaurant ID in the returned map
  Future<List<Map<String, dynamic>>> getAllRestaurantsMap() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('restaurants').get();

      // Add the document ID to each restaurant's data
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> restaurantData =
            doc.data() as Map<String, dynamic>;
        restaurantData['id'] =
            doc.id; // Add the restaurant's ID as a key-value pair
        return restaurantData;
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> registerSearchType(Map<String, dynamic> types) async {
    try {
      await _db.collection('restaurant_search_types').add(types);
    } catch (e) {
      print("Error registering user: $e");
      if (e is FirebaseException) {
        print("FirebaseException: ${e.message}");
      }
    }
  }

  Future<List<String>> getTopRestaurants() async {
    final url = Uri.parse('http://35.239.202.192:8000/like_review_week');
    try {
      // Fetch data from the URL
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode the JSON data
        final List<dynamic> data = json.decode(response.body);

        // Extract the first three restaurant names
        final topRestaurants = data.take(3).map((restaurant) => restaurant['name'].toString()).toList();

        return topRestaurants;
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      // Handle errors by returning an empty list
      print('Error: $e');
      return [];
    }
  }
  Future<void> registerMapSearch() async {
    try {
      // Get the current timestamp
      final timestamp = DateTime.now();
      
      // Add the document with the timestamp field
      await _db.collection('map_search_times').add({
        'time': timestamp,
      });

      print("Map search registered at: $timestamp");
    } catch (e) {
      print("Error registering map search: $e");
      if (e is FirebaseException) {
        print("FirebaseException: ${e.message}");
      }
    }
  }
}
