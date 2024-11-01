import 'package:restau/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restau/widgets/info_window.dart';
import 'package:restau/navigation/user_viewmodel.dart';

class RestaurantMarkerAdapter {
  final Restaurant restaurant;
  final BuildContext context;
  final UserViewModel userViewModel = UserViewModel();
  final BitmapDescriptor? newRestaurantIcon;

  RestaurantMarkerAdapter({required this.restaurant, required this.context, this.newRestaurantIcon});

  Marker toMarker() {
    return Marker(
      markerId: MarkerId(restaurant.name),
      position: LatLng(restaurant.latitude, restaurant.longitude),
      icon: _selectIcon(restaurant),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: CustomInfoWindow(restaurant: restaurant),
            );
          },
        );
      },
    );
  }

  BitmapDescriptor _selectIcon(Restaurant restaurant) {
    bool isNew = DateTime.now().difference(restaurant.openingDate.toDate()).inDays < 30;
    
    bool isLiked = userViewModel.likedRestaurants.contains(restaurant.id);
    
    List<dynamic> preferences = [];
    if (userViewModel.userInfo != null && userViewModel.userInfo!.containsKey("preferences")) {
      preferences = userViewModel.userInfo!["preferences"];
    }
    List<String> categories = restaurant.categories;
    bool categoryMatch = preferences.any((element) => categories.contains(element));
    
    if (isNew && !isLiked && categoryMatch) {
      print('New restaurant: ${restaurant.name}');
      return newRestaurantIcon ?? BitmapDescriptor.defaultMarker;
    }

    return BitmapDescriptor.defaultMarker;
  }
}