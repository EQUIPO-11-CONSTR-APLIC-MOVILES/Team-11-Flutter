import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restau/auth/profile_screen.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/search/search_view.dart';
import 'navigator_viewmodel.dart';
import '../home/home_screen.dart';
import '../random/random_screen.dart';
import '../liked/liked_screen.dart';
import '../map/map_screen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  NavigatorScreenState createState() => NavigatorScreenState();
}

class NavigatorScreenState extends State<NavigatorScreen> {
  final UserViewModel _activeUser = UserViewModel();
  final GlobalKey<RandomScreenState> _randomScreenKey = GlobalKey<RandomScreenState>();
  
  late final List<Widget> _screens;
  
  static const double _avatarRadius = 20.0;
  static const double _navigationIconPadding = 8.0;
  static const Color _selectedIconColor = Color(0xFFFFEEAD);
  
  bool _isProfileVisible = false;
  
  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }
  
  void _initializeScreens() {
    _screens = [
      const HomeScreen(),
      RandomScreen(key: _randomScreenKey),
      const SearchScreen(),
      const LikedScreen(),
      const MapScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigatorViewModel(),
      child: Stack(
        children: [
          Scaffold(
            appBar: _isProfileVisible ? null : _buildAppBar(),
            body: _buildBody(),
            bottomNavigationBar: _buildBottomNav(),
          ),
          if (_isProfileVisible)
            ProfileScreen(
              onBack: () => setState(() => _isProfileVisible = false),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [_buildProfileAvatar()],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(
          color: Colors.black,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FutureBuilder<String?>(
        future: _activeUser.getUserPic(),
        builder: (context, snapshot) => _buildAvatarFromSnapshot(snapshot, context),
      ),
    );
  }

  Widget _buildAvatarFromSnapshot(AsyncSnapshot<String?> snapshot, BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox(
        width: _avatarRadius * 2,
        height: _avatarRadius * 2,
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _isProfileVisible = true),
      child: CircleAvatar(
        backgroundImage: snapshot.data != null 
            ? CachedNetworkImageProvider(snapshot.data!)
            : null,
        radius: _avatarRadius,
        child: snapshot.data == null ? const Icon(Icons.person) : null,
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Consumer<NavigatorViewModel>(
        builder: (context, vm, child) {
          _handleApiMessage(context, vm);
          _handleRandomScreen(vm);
          return _screens.elementAt(vm.selectedIndex);
        },
      ),
    );
  }

  void _handleApiMessage(BuildContext context, NavigatorViewModel vm) {
    if (vm.apiMessage.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showApiMessagePopup(context, vm);
      });
    }
  }

  void _handleRandomScreen(NavigatorViewModel vm) {
    if (vm.selectedIndex == 1) {
      _randomScreenKey.currentState?.fetchRandomRestaurant();
    }
  }

  Widget _buildBottomNav() {
    return Consumer<NavigatorViewModel>(
      builder: (context, vm, child) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _buildNavigationItems(vm),
        currentIndex: vm.selectedIndex,
        onTap: (index) {
          if (_isProfileVisible) {
            setState(() => _isProfileVisible = false);
          }
          vm.onItemTapped(index);
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems(NavigatorViewModel vm) {
    return List.generate(
      5,
      (index) => BottomNavigationBarItem(
        icon: _buildNavigationIcon(index, vm),
        label: '',
      ),
    );
  }

  Widget _buildNavigationIcon(int index, NavigatorViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: vm.selectedIndex == index 
            ? _selectedIconColor
            : Colors.transparent,
      ),
      padding: const EdgeInsets.all(_navigationIconPadding),
      child: Icon(
        vm.getIconForIndex(index),
        color: Colors.black,
      ),
    );
  }

  void _showApiMessagePopup(BuildContext context, NavigatorViewModel vm) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(24.0),
        content: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            vm.apiMessage,
            style: const TextStyle(
              color: Color(0xFF2F2F2F),
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          _buildDismissButton(context, vm),
          _buildLetsGoButton(context, vm),
        ],
      ),
    );
  }

  Widget _buildDismissButton(BuildContext context, NavigatorViewModel vm) {
    return TextButton(
      onPressed: () {
        vm.apiMessage = '';
        Navigator.of(context).pop();
      },
      child: const Text(
        'Dismiss',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLetsGoButton(BuildContext context, NavigatorViewModel vm) {
    return TextButton(
      onPressed: () {
        vm.apiMessage = '';
        Navigator.of(context).pop();
        vm.onItemTapped(4);
      },
      child: const Text(
        "Let's go!",
        style: TextStyle(
          color: Color(0xFFD9534F),
          fontSize: 16,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}