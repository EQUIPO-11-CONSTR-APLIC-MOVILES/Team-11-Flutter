import 'package:flutter/material.dart';
import '../models/firestore_service.dart';

class NavigatorViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  final Map<int, String> screenNames = {
    0: 'Home',
    1: 'Random',
    2: 'Search',
    3: 'Liked',
    4: 'Map',
  };

  void onItemTapped(int index) {



    _firestoreService.addNavigationPath(screenNames[_selectedIndex]!, screenNames[index]!);
    _selectedIndex = index;
    notifyListeners();
  }
}