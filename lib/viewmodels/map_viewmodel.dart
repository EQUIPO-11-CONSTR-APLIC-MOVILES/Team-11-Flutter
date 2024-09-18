import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_pkg;
import 'package:permission_handler/permission_handler.dart' as permission_handler_pkg;
import 'package:restau/models/map_state.dart';

class MapViewModel extends ChangeNotifier {
  MapState _state = MapState();
  MapState get state => _state;
  final location_pkg.Location _location = location_pkg.Location();
  bool _initialLocationSet = false;

  MapViewModel() {
    _requestPermission();
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
        _state = MapState(
          startLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          circleLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          permissionsGranted: true,
          restaurants: _state.restaurants,
          circleRadius: _state.circleRadius,
          isCheckingPermissions: false,
        );
        _initialLocationSet = true;
        notifyListeners();
      } else {
        _state = MapState(
          startLocation: _state.startLocation,
          circleLocation: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          permissionsGranted: true,
          restaurants: _state.restaurants,
          circleRadius: _state.circleRadius,
          isCheckingPermissions: false,
        );
        notifyListeners();
      }
    });

    _updatePermissionStatus(true);
  }

  void _updatePermissionStatus(bool permissionsGranted) {
    _state = MapState(
      startLocation: _state.startLocation,
      circleLocation: _state.circleLocation,
      permissionsGranted: permissionsGranted,
      restaurants: _state.restaurants,
      circleRadius: _state.circleRadius,
      isCheckingPermissions: false,
    );
    notifyListeners();
  }

  void updateCircleRadius(double radius) {
    _state = MapState(
      startLocation: _state.startLocation,
      circleLocation: _state.circleLocation,
      permissionsGranted: _state.permissionsGranted,
      restaurants: _state.restaurants,
      circleRadius: radius,
      isCheckingPermissions: _state.isCheckingPermissions,
    );
    notifyListeners();
  }

  Future<void> openAppSettings() async {
    await permission_handler_pkg.openAppSettings();
  }
}
