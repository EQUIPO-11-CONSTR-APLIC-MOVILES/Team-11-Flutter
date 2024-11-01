import 'package:cloud_firestore/cloud_firestore.dart';

class NavigationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addNavigationPath(String path) async {
    try {
      DocumentReference docRef = await _db.collection('navigation_paths').add({
        'path': path,
      });
      return docRef.id;
    } catch (e) {
      return "";
    }
  }

  Future<void> updateNavigationPath(String documentId, String newPath) async {
    try {
      await _db.collection('navigation_paths').doc(documentId).update({
        'path': newPath,
      });
    } catch (e) {
      return;
    }
  }
}
