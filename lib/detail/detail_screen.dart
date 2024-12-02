import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/models/restaurant_viewmodel.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/widgets/detail_options.dart';
import 'package:restau/widgets/restaurant_tags.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location_pkg;

class DetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  final bool isRandom;
  final String randomReviewDocumentId;

  const DetailScreen({super.key, required this.restaurant, required this.isRandom, this.randomReviewDocumentId=""});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLiked = false;
  late UserViewModel vm;
  late RestaurantViewmodel rvm;
  List<String> likedRestaurantIds = [];
  Text? distanceText;

  @override
  void initState() {
    super.initState();
    vm = UserViewModel();
    rvm = RestaurantViewmodel();
    fetchLikedRestaurants();
    checkAndFetchDistance();
  }

  Future<void> fetchLikedRestaurants() async {
    // Fetch liked restaurant IDs and check if this restaurant is in the liked list
    likedRestaurantIds = await vm.getLikedRestaurants();
    setState(() {
      isLiked = likedRestaurantIds.contains(widget.restaurant.getId());
    });
  }

  Future<void> checkAndFetchDistance() async {
    if (await Permission.location.isGranted) {
      final userLocation = await fetchUserLocation();
      if (userLocation != null) {
        widget.restaurant.calculateDistance(
            LatLng(userLocation.latitude!, userLocation.longitude!));
        setState(() {
          final distance = widget.restaurant.distance;
          String message;
          Color color;

          if (distance > 3) {
            message = "Far";
            color = Colors.red;
          } else if (distance > 1) {
            message = "Moderate";
            color = Colors.orange;
          } else {
            message = "Near";
            color = Colors.green;
          }

          distanceText = Text(
            '${distance.toStringAsFixed(1)} km - $message',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: color,
            ),
          );
        });
      }
    } else {
      setState(() {
        distanceText = null; // Don't display distance
      });
    }
  }


  Future<location_pkg.LocationData?> fetchUserLocation() async {
    final location_pkg.Location location = location_pkg.Location();
    return await location.getLocation();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        vm.likeRestaurant(widget.restaurant.getId());
      } else {
        vm.unlikeRestaurant(widget.restaurant.getId());
      }
    });
  }

  Future<void> _launchMapsUrl(double latitude, double longitude) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _showNoConnectionDialog();
      return;
    }

    rvm.registerMapSearch();

    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isRandom ? null : AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD9534F),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.location_on),
                color: Colors.white,
                onPressed: () {
                  _launchMapsUrl(
                      widget.restaurant.latitude, widget.restaurant.longitude);
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2, // Max height 1/3 of screen
              child: CachedNetworkImage(
                imageUrl: widget.restaurant.imageUrl,
                placeholder: (context, url) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 40, color: Colors.grey), // Placeholder icon
                    SizedBox(height: 8),
                    Text(
                      "Connect to the internet to load this image",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover, // Ensures image covers the width
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (distanceText != null) distanceText!,
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        widget.restaurant.averageRating.toString(),
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      const SizedBox(width: 8.0),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.restaurant.averageRating
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color.fromARGB(252, 255, 215, 173),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  IconsRow(restaurant: widget.restaurant, randomReviewDocumentId: widget.randomReviewDocumentId),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.restaurant.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color.fromARGB(222, 130, 126, 126),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16.0),
                  TagSection(tags: widget.restaurant.categories),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleLike,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        backgroundColor: const Color(0xFFD9534F),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border, // Toggle icon
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
