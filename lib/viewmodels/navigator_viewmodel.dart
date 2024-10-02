import 'package:flutter/material.dart';
import 'package:restau/models/firestore_service.dart';

class NavigatorViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();
  String navigationPath = 'Home'; // Initial path is Home
  late String sessionId;

  NavigatorViewModel() {
    initializeSessionId();
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
        return Icons.home;
      case 1:
        return Icons.shuffle;
      case 2:
        return Icons.search;
      case 3:
        return Icons.favorite;
      case 4:
        return Icons.map;
      default:
        return Icons.home; // Fallback icon
    }
  }
}
