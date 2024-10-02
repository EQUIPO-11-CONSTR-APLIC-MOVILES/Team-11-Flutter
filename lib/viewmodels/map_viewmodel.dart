import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_pkg;
import 'package:permission_handler/permission_handler.dart' as permission_handler_pkg;
import 'package:restau/models/map_state.dart';
import '../models/firestore_service.dart';
import 'package:restau/models/restaurant.dart';

class MapViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  MapState _state = MapState();
  MapState get state => _state;
  final location_pkg.Location _location = location_pkg.Location();
  bool _initialLocationSet = false;

  MapViewModel() {
    _requestPermission();
    fetchRestaurants();
  }

  Future<void> _requestPermission() async {
    bool serviceEnabled;
    location_pkg.PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        _updatePermissionStatus(false);
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == location_pkg.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != location_pkg.PermissionStatus.granted) {
        _updatePermissionStatus(false);
        return;
      }
    }

    _location.onLocationChanged.listen((location_pkg.LocationData currentLocation) {
      if (!_initialLocationSet) {
        _state = _state.copyWith(
          userLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          circleLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          permissionsGranted: true,
          isCheckingPermissions: false,
        );
        _initialLocationSet = true;
      } else {
        _state = _state.copyWith(
          circleLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          permissionsGranted: true,
          isCheckingPermissions: false,
        );
      }
      updateRestaurantDistances(currentLocation);
      updateShownRestaurants();
      notifyListeners();
    });

    _updatePermissionStatus(true);
  }

  void _updatePermissionStatus(bool permissionsGranted) {
    _state = _state.copyWith(
      permissionsGranted: permissionsGranted,
      isCheckingPermissions: false
    );
    notifyListeners();
  }

  void updateCircleRadius(double radius) {
    _state = _state.copyWith(circleRadius: radius);
    updateShownRestaurants();
    notifyListeners();
  }

  Future<void> openAppSettings() async {
    await permission_handler_pkg.openAppSettings();
  }

  Future<void> fetchRestaurants() async {
    _state = _state.copyWith(isCheckingPermissions: true);

    final restaurants = await _firestoreService.getAllRestaurants();
    _state = _state.copyWith(
      restaurants: restaurants.map((data) => Restaurant.fromMap(data)).toList()
    );
  }

  void updateRestaurantDistances(location_pkg.LocationData currentLocation) {
    List<Restaurant> modifiableList = List.from(_state.restaurants);
    for (final restaurant in modifiableList) {
      restaurant.calculateDistance(LatLng(currentLocation.latitude!, currentLocation.longitude!));
    }
    modifiableList.sort((a, b) => a.distance.compareTo(b.distance));
    _state = _state.copyWith(restaurants: modifiableList);
  }

  int _binarySearch(List<Restaurant> restaurants) {
    if (_state.circleRadius == 0) {
      return 0;
    }

    int low = 0;
    int high = restaurants.length - 1;

    while (low <= high) {
      int mid = (low + high) ~/ 2;
      if (restaurants[mid].distance <= _state.circleRadius) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    return low;
  }

  void updateShownRestaurants() {
    int index = _binarySearch(_state.restaurants);
  _state = _state.copyWith(nearRestaurants: _state.restaurants.sublist(0, index));
  }
}
