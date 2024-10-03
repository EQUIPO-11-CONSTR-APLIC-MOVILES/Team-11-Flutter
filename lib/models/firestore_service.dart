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

  Future<String> addNavigationPath(String path) async {
    try {
      DocumentReference docRef = await _db.collection('navigation_paths').add({
        'path': path,
      });
      return docRef.id;
    } catch (e) {
      // TODO: No imprimir
      print(e.toString());
      return "";
    }
  }

  Future<void> updateNavigationPath(String documentId, String newPath) async {
    try {
      await _db.collection('navigation_paths').doc(documentId).update({
        'path': newPath,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}