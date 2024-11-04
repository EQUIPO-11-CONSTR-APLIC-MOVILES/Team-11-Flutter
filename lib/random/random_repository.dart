import 'package:cloud_firestore/cloud_firestore.dart';

class RandomRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addRandomReview() async {
    try {
      DocumentReference docRef = await _db.collection('random_review').add({
        'left_review': false,
      });
      return docRef.id;
    } catch (e) {
      return "";
    }
  }

  Future<void> updateRandomReview(String documentId) async {
    try {
      await _db.collection('random_review').doc(documentId).update({
        'left_review': true,
      });
    } catch (e) {
      return;
    }
  }
}
