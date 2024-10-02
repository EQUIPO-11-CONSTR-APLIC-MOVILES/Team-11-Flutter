import 'package:flutter/material.dart';
import 'package:restau/viewmodels/log_in_viewmodel.dart';
import 'package:restau/viewmodels/user.dart';
import '../viewmodels/navigator_viewmodel.dart'; 
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
  
  User activeUser = User();
  LogInViewmodel livm = LogInViewmodel();
  NavigatorViewModel vm = NavigatorViewModel();

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const RandomScreen(),
    const SearchScreen(),
    const LikedScreen(),
    const MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Right inset for the avatar
            child: FutureBuilder<String?>(
              future: activeUser.getUserPic(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While loading, show a circular progress indicator
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  // Handle error (could be null if user is not logged in)
                  return const Icon(Icons.error);
                }

                // Get the profile picture URL
                String? profilePicUrl = snapshot.data;

                return GestureDetector(
                  onTap: () => _showLogoutMenu(context),
                  child: CircleAvatar(
                    backgroundImage: profilePicUrl != null
                        ? NetworkImage(profilePicUrl)
                        : null, // Default or placeholder image can be added here
                    radius: 20, // Adjust radius as needed
                    child: profilePicUrl == null
                        ? const Icon(Icons.person) // Default icon if no image
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the bottom border
          child: Container(
            color: Colors.black, // Black color for the bottom line
            height: 1.0, // Thickness of the bottom border
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: List.generate(5, (index) {
          return BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedIndex == index ? const Color(0xFFFFEEAD) : Colors.transparent,
              ),
              padding: const EdgeInsets.all(8.0), 
              child: Icon(
                vm.getIconForIndex(index),
                color: _selectedIndex == index ? Colors.black : Colors.black54,
              ),
            ),
            label: '',
          );
        }),
        currentIndex: _selectedIndex,
        onTap: vm.onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  void _showLogoutMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 80, 0, 0), // Adjust the position as needed
      items: [
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout), // Logout icon
              SizedBox(width: 8), // Space between icon and text
              Text('Log Out'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'logout') {
        livm.logOut();
        // Optionally, navigate to the login screen or show a snackbar
      }
    });
  }
}
