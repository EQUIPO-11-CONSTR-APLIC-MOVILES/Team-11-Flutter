import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewRepository {
  Future<void> registerReview(Map<String, dynamic> review) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    try {
      await _db.collection('reviews').add(review);
    } catch (e) {
      print("Error registering user: $e");
      if (e is FirebaseException) {
        print("FirebaseException: ${e.message}");
      }
    }
  }
}