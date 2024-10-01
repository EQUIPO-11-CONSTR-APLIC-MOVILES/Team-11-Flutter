import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final num averageRating;
  final List<String> categories;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String name;
  final Timestamp openingDate;
  final String placeName;
  final Map<String, Map<String, dynamic>> schedule;

  Restaurant({
    required this.averageRating,
    required this.categories,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.openingDate,
    required this.placeName,
    required this.schedule,
  });
}
