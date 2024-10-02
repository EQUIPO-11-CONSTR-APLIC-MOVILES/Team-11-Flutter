import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> logIn(String username, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Wrong password provided for that user.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        default:
          throw Exception('Failed to sign in: ${e.message}');
      }
    } catch (e) {
      // Handle other errors (like network issues)
      throw Exception('An unexpected error occurred: $e');
    }
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  String? getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  Future<void> registerUser(String email, String password, String name, String picture, List<String> preferences) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'picture': picture,
        'preferences': preferences,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error registering user: $e");
    }
  }
}
