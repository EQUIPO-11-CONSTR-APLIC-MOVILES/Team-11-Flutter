import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  final LatLng startLocation;
  final bool permissionsGranted;
  final List<Restaurant> restaurants;
  final LatLng circleLocation;
  final double circleRadius;
  final bool isCheckingPermissions;

  MapState({
    this.startLocation = const LatLng(4.603096177609384, -74.06584744436493),
    this.permissionsGranted = false,
    this.restaurants = const [],
    this.circleLocation = const LatLng(4.603096177609384, -74.06584744436493),
    this.circleRadius = 0.1,
    this.isCheckingPermissions = true,
  });
}

class Restaurant {
  // Define your Restaurant model here
}