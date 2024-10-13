import 'package:restau/models/restaurant.dart';
import 'package:restau/models/restaurant_repository.dart';

class LikedViewModel {
  LikedViewModel._privateConstructor();
  RestaurantRepository repo = RestaurantRepository();

  static final LikedViewModel _instance = LikedViewModel._privateConstructor();
  
  factory LikedViewModel() {
    return _instance;
  }

  Future<List<Map<String, dynamic>>> getAllRestaurants() async {
    return await repo.getAllRestaurantsMap();
  }


  // Function to cast restaurant data to List<Restaurant> and filter by liked restaurants
  List<Restaurant> castToRestaurantList(
      List<Map<String, dynamic>> snapshotData, List<String> likedRestaurantIds) {
    return snapshotData.where((restaurantData) {
      return likedRestaurantIds.contains(restaurantData['id']);
    }).map((restaurantData) {
      return Restaurant(
        averageRating: restaurantData['averageRating'],
        categories: List<String>.from(restaurantData['categories']),
        imageUrl: restaurantData['imageUrl'],
        latitude: restaurantData['latitude'],
        longitude: restaurantData['longitude'],
        name: restaurantData['name'],
        openingDate: restaurantData['openingDate'],
        placeName: restaurantData['placeName'],
        schedule:
            Map<String, Map<String, dynamic>>.from(restaurantData['schedule']),
        id: restaurantData['id']
      );
    }).toList();
  }

}
