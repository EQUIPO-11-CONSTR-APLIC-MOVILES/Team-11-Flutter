import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  final LatLng userLocation;
  final bool permissionsGranted;
  final List<Restaurant> restaurants;
  final List<Restaurant> nearRestaurants;
  final LatLng circleLocation;
  final double circleRadius;
  final bool isCheckingPermissions;

  MapState({
    this.userLocation = const LatLng(4.603096177609384, -74.06584744436493),
    this.permissionsGranted = false,
    this.restaurants = const [],
    this.nearRestaurants = const [],
    this.circleLocation = const LatLng(4.603096177609384, -74.06584744436493),
    this.circleRadius = 0,
    this.isCheckingPermissions = true,
  });

  MapState copyWith({
    LatLng? userLocation,
    bool? permissionsGranted,
    List<Restaurant>? restaurants,
    List<Restaurant>? nearRestaurants,
    LatLng? circleLocation,
    double? circleRadius,
    bool? isCheckingPermissions,
  }) {
    return MapState(
      userLocation: userLocation ?? this.userLocation,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      restaurants: restaurants ?? this.restaurants,
      nearRestaurants: nearRestaurants ?? this.nearRestaurants,
      circleLocation: circleLocation ?? this.circleLocation,
      circleRadius: circleRadius ?? this.circleRadius,
      isCheckingPermissions: isCheckingPermissions ?? this.isCheckingPermissions,
    );
  }
}

class Restaurant {
  final String name;
  final LatLng location;
  double distance;

  Restaurant({
    required this.name,
    required this.location,
    this.distance = 0.0,
  });

  factory Restaurant.fromMap(Map<String, dynamic> data) {
    return Restaurant(
      name: data['name'],
      location: LatLng(data['latitude'], data['longitude']),
    );
  }

  void calculateDistance(LatLng userLocation) {
    const double earthRadius = 6371; // km
    final double dLat = _degToRad(location.latitude - userLocation.latitude);
    final double dLon = _degToRad(location.longitude - userLocation.longitude);
    final double a = 
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(userLocation.latitude)) * cos(_degToRad(location.latitude)) *
      sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    distance = earthRadius * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }
}