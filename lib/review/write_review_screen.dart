import 'package:flutter/material.dart';
import 'package:restau/widgets/rating_stars.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key, required this.restaurant});

  final String restaurant;

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RatingStars()
    );
  }
}