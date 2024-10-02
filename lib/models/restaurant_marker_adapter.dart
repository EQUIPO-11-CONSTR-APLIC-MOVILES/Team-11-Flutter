import 'package:restau/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restau/widgets/info_window.dart';

class RestaurantMarkerAdapter {
  final Restaurant restaurant;
  final BuildContext context;

  RestaurantMarkerAdapter({required this.restaurant, required this.context});

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
    // Implement your logic to select the icon based on the restaurant
    // For example:
    return BitmapDescriptor.defaultMarker;
  }
}