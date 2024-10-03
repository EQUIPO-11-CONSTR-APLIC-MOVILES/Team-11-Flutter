import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restau/models/restaurant.dart';

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