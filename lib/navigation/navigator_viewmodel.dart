import 'package:flutter/material.dart';
import 'package:restau/models/firestore_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:restau/navigation/user_viewmodel.dart';

// Global variable to track if the location has been sent
bool _locationSent = false;

class NavigatorViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();
  String navigationPath = 'Home'; // Initial path is Home
  late String sessionId;
  String apiMessage = '';

  NavigatorViewModel() {
    initializeSessionId();
    _checkLocationPermission();
  }

  void initializeSessionId() async {
    sessionId = await addNavigationPathToFirestore();
  }

  int get selectedIndex => _selectedIndex;

  final Map<int, String> screenNames = {
    0: 'Home',
    1: 'Random',
    2: 'Search',
    3: 'Liked',
    4: 'Map',
  };

  void addNavigationPath(int index) {
    String? screen = screenNames[index];
    if (screen != null) {
      if (!navigationPath.endsWith(screen)) {
        navigationPath = '$navigationPath > $screen';
      }
      updateNavigationPathInFirestore();
    }
  }

  void onItemTapped(int index) {
    addNavigationPath(index);
    _selectedIndex = index;
    notifyListeners();
  }

  Future<String> addNavigationPathToFirestore() async {
    return await _firestoreService.addNavigationPath(navigationPath);
  }

  void updateNavigationPathInFirestore() {
    _firestoreService.updateNavigationPath(sessionId, navigationPath);
  }

  IconData getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.restaurant;
      case 1:
        return Icons.shuffle;
      case 2:
        return Icons.search;
      case 3:
        return Icons.favorite_border;
      case 4:
        return Icons.location_on_outlined;
      default:
        return Icons.home; // Fallback icon
    }
  }

  LocationData? _currentLocation;
  UserViewModel activeUser = UserViewModel();

  Future<void> _checkLocationPermission() async {
    print('Checking location permission');
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    if (_currentLocation != null && !_locationSent) {
      _sendLocationToApi();
    }
  }

  Future<void> _sendLocationToApi() async {
    print('Sending location to API');
    try {
      final userInfo = await activeUser.getUserInfo();
      final userID = userInfo?['uid'];
      final lat = _currentLocation!.latitude;
      final lon = _currentLocation!.longitude;

      String apiURL = "http://34.134.5.98:8000";

      print("fetching");
      final response = await http
        .get(
          Uri.parse(
            '$apiURL/nearbyxcuisine?userID=lPS20gyuL2SeBaf5tmiy4pVlnLK2&lat=4.6733676&lon=-74.1012443'),
            //'$apiURL/nearbyxcuisine?userID=$userID&lat=$lat&lon=$lon'),
        )
        .timeout(const Duration(seconds: 5)); // 10-second timeout

      print("Fetched");

      if (response.statusCode == 200) {
        final responseBody = response.body.replaceAll('"', "");

        print(responseBody);
        if (responseBody != 'null') {
          // Convert string
          final firstChar = responseBody.isNotEmpty ? responseBody[0].toLowerCase() : '';
          final message = ['a', 'e', 'i', 'o', 'u'].contains(firstChar)
              ? "There's an $responseBody restaurant near you"
              : "There's a $responseBody restaurant near you";

          apiMessage = message;
          _locationSent = true; // Set the flag to true after sending location
        }
        
      } else {
        print('Failed to send location to API');
        print("Response status: ${response.statusCode}");
        //apiMessage = 'Failed to get restaurant';
      }
    } catch (e) {
      print('Failed to send location to API');
      print(e);
      //apiMessage = 'Failed to fetch';
    }
    notifyListeners();
  }
}
