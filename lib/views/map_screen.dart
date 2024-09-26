import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restau/viewmodels/map_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MapScreen'),
        ),
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
                _googleMap(viewModel),
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

  Widget _googleMap(MapViewModel viewModel) {
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
        return Marker(
          markerId: MarkerId(restaurant.name),
          position: restaurant.location,
          infoWindow: InfoWindow(title: restaurant.name),
        );
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
