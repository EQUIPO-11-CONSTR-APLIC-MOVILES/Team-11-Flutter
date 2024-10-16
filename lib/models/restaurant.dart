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
        name: data['name'] as String,
        latitude: data['latitude'] as double,
        longitude: data['longitude'] as double,
        averageRating: data['averageRating'] as num,
        imageUrl: data['imageUrl'] as String,
        categories: List<String>.from(data['categories'] as List<dynamic>),
        openingDate:
            Timestamp.fromMillisecondsSinceEpoch(data['openingDate'] as int),
        placeName: data['placeName'] as String,
        schedule: Map<String, Map<String, dynamic>>.from(
          (data['schedule'] as Map<String, dynamic>).map((key, value) =>
              MapEntry(key, Map<String, dynamic>.from(value as Map))),
        ),
        id: data['id'] as String);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'averageRating': averageRating,
      'imageUrl': imageUrl,
      'categories': categories,
      'openingDate': openingDate.millisecondsSinceEpoch,
      'placeName': placeName,
      'schedule': schedule,
      'id': id,
    };
  }

  // Cálculo de la distancia a partir de la ubicación del usuario
  void calculateDistance(LatLng userLocation) {
    const double earthRadius = 6371; // km
    final double dLat = _degToRad(latitude - userLocation.latitude);
    final double dLon = _degToRad(longitude - userLocation.longitude);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(userLocation.latitude)) *
            cos(_degToRad(latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    distance = earthRadius * c;
  }

  String getId() {
    return id;
  }

  List<String> getTypes() {
    return categories;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }
}
