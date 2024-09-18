import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:restau/models/map_state.dart';
import 'package:url_launcher/url_launcher.dart';

class MapViewModel extends ChangeNotifier {
  MapState _state = MapState();
  MapState get state => _state;
  final Location _location = Location();
  bool _initialLocationSet = false;

  MapViewModel() {
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      if (!_initialLocationSet) {
        _state = MapState(
          startLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          circleLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!), // Update circle location
          permissionsGranted: true,
          restaurants: _state.restaurants,
          circleRadius: _state.circleRadius, // Preserve the current circle radius
        );
        _initialLocationSet = true;
        notifyListeners();
      } else {
        _state = MapState(
          startLocation: _state.startLocation,
          circleLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!), // Update circle location
          permissionsGranted: true,
          restaurants: _state.restaurants,
          circleRadius: _state.circleRadius, // Preserve the current circle radius
        );
        notifyListeners();
      }
    });
  }

  void updateCircleRadius(double radius) {
    _state = MapState(
      startLocation: _state.startLocation,
      circleLocation: _state.circleLocation,
      permissionsGranted: _state.permissionsGranted,
      restaurants: _state.restaurants,
      circleRadius: radius,
    );
    notifyListeners();
  }

  Future<void> openAppSettings() async {
    await launchUrl(Uri.parse('app-settings:'));
  }
}