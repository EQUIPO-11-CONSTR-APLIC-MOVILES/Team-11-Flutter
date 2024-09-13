import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'random_screen.dart';
import 'search_screen.dart';
import 'liked_screen.dart';
import 'map_screen.dart';

class NavigatorScreen extends StatefulWidget {
  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const RandomScreen(),
    const SearchScreen(),
    const LikedScreen(),
    const MapScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Add this line
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(Icons.home, 'Home', 0),
          _buildBottomNavigationBarItem(Icons.shuffle, 'Random', 1),
          _buildBottomNavigationBarItem(Icons.search, 'Search', 2),
          _buildBottomNavigationBarItem(Icons.favorite, 'Liked', 3),
          _buildBottomNavigationBarItem(Icons.map, 'Map', 4),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: _selectedIndex == index
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFEEAD),
              ),
              padding: EdgeInsets.all(8.0),
              child: Icon(icon),
            )
          : Icon(icon),
      label: label,
    );
  }
}
