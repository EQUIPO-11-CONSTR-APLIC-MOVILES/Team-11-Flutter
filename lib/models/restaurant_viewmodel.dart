import 'package:restau/models/restaurant_repository.dart';

class RestaurantViewmodel {
  RestaurantViewmodel._privateConstructor();
  RestaurantRepository repo = RestaurantRepository();

  static final RestaurantViewmodel _instance = RestaurantViewmodel._privateConstructor();
  
  factory RestaurantViewmodel() {
    return _instance;
  }

  void sendPreferences(List<String> preferences) {
    // Convert the list of preferences into the required map format
    Map<String, dynamic> formattedPreferences = {
      for (var type in preferences) type: null
    };

    // Send the formatted preferences to the repository
    repo.registerSearchType(formattedPreferences);
  }
}
