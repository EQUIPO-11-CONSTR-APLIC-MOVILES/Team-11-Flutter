import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/navigator_viewmodel.dart';
import 'home_screen.dart';
import 'random_screen.dart';
import 'search_screen.dart';
import 'liked_screen.dart';
import 'map_screen.dart';

class NavigatorScreen extends StatelessWidget {
  const NavigatorScreen({super.key});

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const RandomScreen(),
    const SearchScreen(),
    const LikedScreen(),
    const MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigatorViewModel(),
      child: Consumer<NavigatorViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: _widgetOptions.elementAt(viewModel.selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                _buildBottomNavigationBarItem(Icons.home, 'Home', 0, viewModel),
                _buildBottomNavigationBarItem(Icons.shuffle, 'Random', 1, viewModel),
                _buildBottomNavigationBarItem(Icons.search, 'Search', 2, viewModel),
                _buildBottomNavigationBarItem(Icons.favorite, 'Liked', 3, viewModel),
                _buildBottomNavigationBarItem(Icons.map, 'Map', 4, viewModel),
              ],
              currentIndex: viewModel.selectedIndex,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black,
              onTap: viewModel.onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label, int index, NavigatorViewModel viewModel) {
    return BottomNavigationBarItem(
      icon: viewModel.selectedIndex == index
          ? Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFEEAD),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon),
            )
          : Icon(icon),
      label: label,
    );
  }
}