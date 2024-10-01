import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'random_screen.dart';
import 'search_screen.dart';
import 'liked_screen.dart';
import 'map_screen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _selectedIndex = 0;
    
  final user = FirebaseAuth.instance.currentUser!;

  static final List<Widget> _widgetOptions = <Widget>[
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

  void attemptLogOut(){
    FirebaseAuth.instance.signOut();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: attemptLogOut, icon: const Icon(Icons.logout)),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: List.generate(5, (index) {
          return BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedIndex == index ? const Color(0xFFFFEEAD) : Colors.transparent,
              ),
              padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
              child: Icon(
                _getIconForIndex(index),
                color: _selectedIndex == index ? Colors.black : Colors.black54,
              ),
            ),
            label: '',
          );
        }),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  IconData _getIconForIndex(int index) {
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
