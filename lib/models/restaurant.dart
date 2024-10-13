import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final String id;

  double distance;

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
    required this.id,

    this.distance = 0.0,
  });

  factory Restaurant.fromMap(Map<String, dynamic> data) {

    return Restaurant(
      name: data['name'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      averageRating: data['averageRating'],
      imageUrl: data['imageUrl'],
      categories: List<String>.from(data['categories']),
      openingDate: data['openingDate'],
      placeName: data['placeName'],
      schedule: Map<String, Map<String, dynamic>>.from(data['schedule']),
      id: data['id']
    );
  }

  void calculateDistance(LatLng userLocation) {
    const double earthRadius = 6371; // km
    final double dLat = _degToRad(latitude - userLocation.latitude);
    final double dLon = _degToRad(longitude - userLocation.longitude);
    final double a = 
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(userLocation.latitude)) * cos(_degToRad(latitude)) *
      sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    distance = earthRadius * c;
  }

  String getId(){
    return id;
  }


  double _degToRad(double deg) {
    return deg * (pi / 180);
  }
}
