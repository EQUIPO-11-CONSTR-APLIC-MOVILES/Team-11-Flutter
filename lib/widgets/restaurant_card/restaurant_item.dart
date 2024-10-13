import 'package:flutter/material.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/navigation/user_viewmodel.dart';

class RestaurantItem extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantItem({super.key, required this.restaurant});

  @override
  State<RestaurantItem> createState() => _RestaurantItemState();
}

class _RestaurantItemState extends State<RestaurantItem> {
  bool isLiked = false; // Track whether the restaurant is liked
  late UserViewModel vm; // ViewModel instance
  List<String> likedRestaurantIds = []; // Store liked restaurant IDs

  @override
  void initState() {
    super.initState();
    vm = UserViewModel();
    fetchLikedRestaurants();
  }

  Future<void> fetchLikedRestaurants() async {
    // Fetch liked restaurant IDs and check if this restaurant is in the liked list
    likedRestaurantIds = await vm.getLikedRestaurants();
    setState(() {
      isLiked = likedRestaurantIds.contains(widget.restaurant.id);
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked; 
      if (isLiked) {
        vm.likeRestaurant(widget.restaurant.id); 
      } else {
        vm.unlikeRestaurant(widget.restaurant.id); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime openingDate = widget.restaurant.openingDate.toDate();
    final bool isNew = now.difference(openingDate).inDays <= 30;

    return Center(
      child: Stack(
        children: [
          // Image container
          Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(
                    widget.restaurant.imageUrl), // Use NetworkImage for Firebase URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Favorite icon in top-left corner
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: toggleLike, // Call toggleLike on tap
              child: CircleAvatar(
                backgroundColor: const Color(0xFFD9534F),
                radius: 18,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border, // Toggle icon
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // "New" label in top-right corner
          if (isNew)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9534F),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'New',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          // Restaurant information card
          Positioned(
            bottom: 30, // Align it to the bottom of the image
            left: 60, // Extend to the full width of the image container
            right: 60,
            height: 80,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xE6FFEEAD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    blurRadius: 10, // Shadow blur radius
                    offset: Offset(0, 4), // Shadow offset
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating Row
                  Row(
                    children: [
                      Text(
                        widget.restaurant.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Set your desired font size here
                            ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.black, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.restaurant.averageRating.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Set your desired font size here
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Location Row
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.black54, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.restaurant.placeName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: 16, // Set your desired font size here
                              ),
                          overflow: TextOverflow.ellipsis, // To handle overflow gracefully
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
