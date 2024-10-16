import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restau/models/restaurant.dart';

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
          id: doc.id
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
        Map<String, dynamic> restaurantData = doc.data() as Map<String, dynamic>;
        restaurantData['id'] = doc.id;  // Add the restaurant's ID as a key-value pair
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
}
