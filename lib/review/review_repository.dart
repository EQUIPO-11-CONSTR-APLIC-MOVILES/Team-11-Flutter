import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

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

  Future<int> getReviewedPercentage(String? userID) async {
  final url = Uri.parse('http://35.239.202.192:8000/reviewed_restaurant_percent?userID=$userID');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return int.parse(response.body.trim()); // Parse the response directly as an integer
    } else {
      throw Exception('Failed to load percentage');
    }
  } catch (e) {
    print('Error: $e');
    return 0;
  }
}
}