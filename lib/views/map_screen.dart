import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restau/viewmodels/map_viewmodel.dart';

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
        body: Stack(
          children: [
            Consumer<MapViewModel>(
              builder: (context, viewModel, child) {
                if (!viewModel.state.permissionsGranted) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Access to location has not been granted.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: viewModel.openAppSettings, // Call ViewModel method
                          child: const Text('Open App Settings'),
                        ),
                      ],
                    ),
                  );
                }
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: viewModel.state.startLocation,
                    zoom: 15.0,
                  ),
                  myLocationEnabled: viewModel.state.permissionsGranted,
                  myLocationButtonEnabled: viewModel.state.permissionsGranted,
                  circles: {
                    Circle(
                      circleId: const CircleId('circle'),
                      center: viewModel.state.circleLocation,
                      radius: viewModel.state.circleRadius * 1000, // Convert km to meters
                      fillColor: Colors.blue.withOpacity(0.5),
                      strokeColor: Colors.blue,
                      strokeWidth: 1,
                    ),
                  },
                  // TODO Add markers for each restaurant
                );
              },
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Consumer<MapViewModel>(
                builder: (context, viewModel, child) {
                  return Container(
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
                          min: 0.1,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}