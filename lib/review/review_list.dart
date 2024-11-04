import 'package:flutter/material.dart';
import 'package:restau/widgets/rating_stars.dart';
import 'package:restau/review/review_viewmodel.dart';
import 'package:restau/widgets/star_rating_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewListScreen extends StatefulWidget {
  final String restaurantID;
  final String randomReviewDocumentId;

  const ReviewListScreen({super.key, required this.restaurantID,this.randomReviewDocumentId = ""});

  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final ReviewViewmodel reviewViewmodel = ReviewViewmodel();
  late Future<List<Map<String, dynamic>>> reviewsFuture;

  @override
  void initState() {
    super.initState();
    reviewsFuture = reviewViewmodel.getReviews(widget.restaurantID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rate & Review',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                RatingStars(
                  controller: StarRatingController(),
                  size: 30.0,
                  restaurantID: widget.restaurantID,
                  randomReviewDocumentId: widget.randomReviewDocumentId,
                ),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading reviews'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reviews available.'));
                } else {
                  final reviews = snapshot.data!;
                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      final String userName = review['authorName'] ?? 'Anonymous';
                      final String userPic = review['authorPFP'] ?? '';
                      final String comment = review['description'] ?? '';
                      final int rating = review['rating'] ?? 0;
                      final DateTime date = (review['date'] as Timestamp).toDate();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile picture and username in a row
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(userPic),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                // Stars and date in a row below the username
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RatingStars(
                                      controller: StarRatingController()..rating = rating,
                                      fixed: true,
                                      size: 20.0,
                                    ),
                                    Text(
                                      '${date.day}/${date.month}/${date.year}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                // Review text
                                Text(
                                  comment,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
