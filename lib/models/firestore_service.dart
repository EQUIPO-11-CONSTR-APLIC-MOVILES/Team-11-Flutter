import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all restaurants
  Future<List<Map<String, dynamic>>> getAllRestaurants() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('restaurants').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}