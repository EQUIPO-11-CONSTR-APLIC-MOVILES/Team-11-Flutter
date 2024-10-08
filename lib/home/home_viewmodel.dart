import 'package:intl/intl.dart';
import 'package:restau/models/restaurant.dart';

class HomeViewModel {
  // Function to get the current day name (e.g., "monday")
  String getCurrentDay() {
    final now = DateTime.now();
    return DateFormat('EEEE').format(now).toLowerCase();
  }

  // Function to get the current time in HHMM format (e.g., 1530 for 3:30 PM)
  int getCurrentTime() {
    final now = DateTime.now();
    return now.hour * 100 + now.minute; // Convert to HHMM format
  }

  // This function filters the restaurants based on the selected button
  List<Restaurant> filterRestaurants(List<Restaurant> restaurants,
      int selectedIndex, Map<String, dynamic> userInfo) {
    if (selectedIndex == 1) {
      // "Open Now" filter logic
      final currentDay = getCurrentDay();
      final currentTime = getCurrentTime();

      return restaurants.where((restaurant) {
        if (restaurant.schedule.containsKey(currentDay)) {
          final daySchedule = restaurant.schedule[currentDay];
          final start = daySchedule?['start'] ?? 0;
          final end = daySchedule?['end'] ?? 2359;

          final startInt = int.parse(start.toString());
          final endInt = int.parse(end.toString());

          return currentTime >= startInt && currentTime <= endInt;
        }
        return false;
      }).toList();
    } else if (selectedIndex == 2) {
      final List<String> userPreferences =
          userInfo['preferences'].cast<String>();
      return restaurants.where((restaurant) {
        final restaurantCategories = restaurant.categories;
        return restaurantCategories.any((category) {
          return userPreferences.contains(category);
        });
      }).toList();
    }
    // If "All" is selected, return all restaurants
    return restaurants;
  }
}
