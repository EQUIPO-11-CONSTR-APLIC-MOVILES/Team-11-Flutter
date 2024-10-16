import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restau/map/map_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restau/map/restaurant_marker_adapter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  late MapViewModel viewModel;
  BitmapDescriptor? newRestaurantIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer to listen for app state changes
    _loadMarkerIcons();
  }

  Future<void> _loadMarkerIcons() async {
    final icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'lib/assets/drawable/marker_new.png',
    );
    setState(() {
      newRestaurantIcon = icon;  // Store the preloaded icon
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up the observer when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the app resumes, check for permissions again
      _checkPermissions();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      viewModel.requestPermission(); // Update the viewModel when permissions are granted
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        viewModel = MapViewModel();
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<MapViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.state.isCheckingPermissions) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!viewModel.state.permissionsGranted) {
              return _buildPermissionsDeniedView(viewModel);
            }
            return Stack(
              children: [
                _googleMap(viewModel, context),
                _slider(viewModel),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionsDeniedView(MapViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'lib/assets/drawable/no_permissions.svg',
            width: 65,
            height: 65,
            color: Colors.grey,
          ),
          const Text(
            "RestaU's Map needs precise location permissions",
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Poppins',
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: viewModel.openAppSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9534F), // Set the background color here
            ),
            child: const Text(
              "Give Permissions",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
          ),
        ],
      ),
    );
  }

  Widget _googleMap(MapViewModel viewModel, BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: viewModel.state.userLocation,
        zoom: 15.0,
      ),
      myLocationEnabled: viewModel.state.permissionsGranted,
      myLocationButtonEnabled: viewModel.state.permissionsGranted,
      circles: {
        Circle(
          circleId: const CircleId('circle'),
          center: viewModel.state.circleLocation,
          radius: viewModel.state.circleRadius * 1000,
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      },
      markers: viewModel.state.nearRestaurants.map((restaurant) {
        RestaurantMarkerAdapter adapter = RestaurantMarkerAdapter(restaurant: restaurant, context: context, newRestaurantIcon: newRestaurantIcon);
        return adapter.toMarker();
      }).toSet(),
    );
  }

  Widget _slider(MapViewModel viewModel) {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Search range:'),
                  Text('${viewModel.state.circleRadius.toStringAsFixed(1)} km'),
                ],
              ),
            ),
            Slider(
              value: viewModel.state.circleRadius,
              min: 0,
              max: 1.5,
              divisions: 99,
              label: viewModel.state.circleRadius.toStringAsFixed(1),
              onChanged: (value) {
                viewModel.updateCircleRadius(value);
              },
              activeColor: const Color(0xFFD9534F),
              inactiveColor: const Color(0xFFFFEEAD),
            ),
          ],
        ),
      ),
    );
  }
}
