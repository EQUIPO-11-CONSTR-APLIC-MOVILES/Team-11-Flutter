import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:restau/models/restaurant.dart';
import 'package:restau/models/restaurant_viewmodel.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/widgets/detail_options.dart';
import 'package:restau/widgets/restaurant_tags.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const DetailScreen({super.key, required this.restaurant});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLiked = false;
  late UserViewModel vm;
  late RestaurantViewmodel rvm;
  List<String> likedRestaurantIds = [];

  @override
  void initState() {
    super.initState();
    vm = UserViewModel();
    rvm = RestaurantViewmodel();
    fetchLikedRestaurants();
  }

  Future<void> fetchLikedRestaurants() async {
    // Fetch liked restaurant IDs and check if this restaurant is in the liked list
    likedRestaurantIds = await vm.getLikedRestaurants();
    setState(() {
      isLiked = likedRestaurantIds.contains(widget.restaurant.getId());
    });
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
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
      appBar: AppBar(
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
              child: CachedNetworkImage(
                imageUrl: widget.restaurant.imageUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit:
                    BoxFit.cover, // This will ensure the image covers the width
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
                  IconsRow(restaurant: widget.restaurant),
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
