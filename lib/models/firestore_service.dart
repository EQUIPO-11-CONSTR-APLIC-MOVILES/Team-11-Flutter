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

  // Add a new navigation path
  Future<void> addNavigationPath(String originScreen, String destinyScreen) async {
    try {
      await _db.collection('navigation_paths').add({
        'originScreen': originScreen,
        'destinyScreen': destinyScreen,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}