import 'package:flutter/material.dart';
import 'package:restau/models/map_state.dart';

class CustomInfoWindow extends StatelessWidget {
  final Restaurant restaurant;

  const CustomInfoWindow({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Restaurant name
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200), // Set the maximum width
            child: Text(
              restaurant.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center the text
            ),
          ),
          const SizedBox(height: 8),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: 200, // Set the desired width
              height: 200, // Set the desired height
              child: Image.network(
                restaurant.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset('lib/assets/drawable/default_restaurant.png');
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              if (index < restaurant.averageRating.floor()) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                );
              } else if (index + 0.5 <= restaurant.averageRating) {
                return const Icon(
                  Icons.star_half,
                  color: Colors.amber,
                );
              } else {
                return const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                );
              }
            }),
          ),
          Text('(${restaurant.averageRating.toString()})'),
          const SizedBox(height: 8),
          // Check out button
          ElevatedButton(
            onPressed: () {
              // Add button logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9534F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Check out',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
          ),
        ],
      ),
    );
  }
}