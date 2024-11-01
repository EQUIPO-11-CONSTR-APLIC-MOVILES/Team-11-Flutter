import 'package:flutter/material.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/review/review_viewmodel.dart';
import 'package:restau/widgets/restaurant_card/restaurant_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({
    super.key,
    required this.restaurants,
    this.showReviewPercentage = false,
  });

  final List<Restaurant> restaurants;
  final bool showReviewPercentage;

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  late final ReviewViewmodel reviews;
  bool _showReviewPercentage = false;
  int? _reviewedPercentage;
  var connectivityResult;

  @override
  void initState() {
    super.initState();
    reviews = ReviewViewmodel();
    _checkConnectivityAndFetchPercentage();
  }

  Future<void> _checkConnectivityAndFetchPercentage() async {
    connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _fetchReviewPercentage();
    } else {
      setState(() {
        _showReviewPercentage = false;
      });
    }
  }

  Future<void> _fetchReviewPercentage() async {
    if (widget.showReviewPercentage) {
      final reviewedPercentage = await reviews.getReviewedPercentage();
      setState(() {
        _showReviewPercentage = reviewedPercentage > 0;
        _reviewedPercentage = reviewedPercentage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.restaurants.length,
                itemBuilder: (ctx, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RestaurantItem(
                    restaurant: widget.restaurants[index],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          if (_showReviewPercentage && _reviewedPercentage != null)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.grey),
                    Text(
                      "You've reviewed $_reviewedPercentage% of restaurants",
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.grey,
                        fontSize: 15,
                      ),
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