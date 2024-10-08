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
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
