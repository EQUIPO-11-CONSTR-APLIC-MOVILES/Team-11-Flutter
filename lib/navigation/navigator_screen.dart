import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider package
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/search/search_view.dart';
import 'navigator_viewmodel.dart';
import '../home/home_screen.dart';
import '../views/random_screen.dart';
import '../liked/liked_screen.dart';
import '../map/map_screen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  NavigatorScreenState createState() => NavigatorScreenState();
}

class NavigatorScreenState extends State<NavigatorScreen> {
  UserViewModel activeUser = UserViewModel();

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const RandomScreen(),
    const SearchScreen(),
    const LikedScreen(),
    const MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Wrap the whole widget with ChangeNotifierProvider if not already done at a higher level
    return ChangeNotifierProvider(
      create: (context) => NavigatorViewModel(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FutureBuilder<String?>(
                future: activeUser.getUserPic(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  }

                  String? profilePicUrl = snapshot.data;

                  return GestureDetector(
                    onTap: () => _showLogoutMenu(context),
                    child: CircleAvatar(
                      backgroundImage: profilePicUrl != null
                          ? NetworkImage(profilePicUrl)
                          : null,
                      radius: 20,
                      child: profilePicUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          // Listen to changes in the selectedIndex from the NavigatorViewModel
          child: Consumer<NavigatorViewModel>(
            builder: (context, vm, child) {
              // Check if apiMessage is not empty and show a popup
              if (vm.apiMessage.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showApiMessagePopup(context, vm);
                });
              }
              return _widgetOptions.elementAt(vm.selectedIndex);
            },
          ),
        ),
        bottomNavigationBar: Consumer<NavigatorViewModel>(
          builder: (context, vm, child) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: List.generate(5, (index) {
                return BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: vm.selectedIndex == index
                          ? const Color(0xFFFFEEAD)
                          : Colors.transparent,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      vm.getIconForIndex(index),
                      color: Colors.black,
                    ),
                  ),
                  label: '',
                );
              }),
              currentIndex: vm.selectedIndex,
              onTap: vm.onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            );
          },
        ),
      ),
    );
  }

  void _showLogoutMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(width: 8),
              Text('Log Out'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'logout') {
        activeUser.logOut();
        // Optionally, navigate to the login screen or show a snackbar
      }
    });
  }

  void _showApiMessagePopup(BuildContext context, NavigatorViewModel vm) {
    String message = vm.apiMessage;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(
              24.0, 24.0, 24.0, 24.0), // Adjusts the padding
          content: Padding(
            padding: const EdgeInsets.only(
                top: 20.0), // Custom top padding for the message
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF2F2F2F),
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () {
                vm.apiMessage = '';
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Let's go!",
                  style: TextStyle(
                    color: Color(0xFFD9534F),
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () {
                vm.apiMessage = '';
                Navigator.of(context).pop();
                vm.onItemTapped(4);
              },
            ),
          ],
        );
      },
    );
  }
}
