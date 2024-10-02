import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all preferences
  Future<List<Map<String, dynamic>>> getAllPreferences() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('Preference Tags').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

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

  Future<void> registerUserInAuth(String mail, String pass) async {
    print('si');
    try {
      print("Attempting to create user with email: $mail and password: $pass");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: pass,
      );
    } catch (e) {
      print("Error registering user: $e");
      if (e is FirebaseException) {
        print("FirebaseException: ${e.message}");
      }
    }
  }

  Future<void> registerUserInDB(String mail, String pass, String name, String picture, List<String> preferences) async{
    try {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    print("User ID: $uid");
    
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': mail,
      'profilePic': picture,
      'preferences': preferences
    });
    } catch (e) {
      print("Error registering user: $e");
      if (e is FirebaseException) {
        print("FirebaseException: ${e.message}");
      }
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      // Query the 'users' collection for the given email
      QuerySnapshot querySnapshot = await _db.collection('users')
          .where('email', isEqualTo: email)
          .get();

      // If any documents are returned, the email is already registered
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email registration: $e");
      return false; // Consider email unregistered if there's an error
    }
  }
  
  Future<Map<String, dynamic>?> getUserInfoByEmail(String email) async {
    try {
      // Query the 'users' collection for the given email
      QuerySnapshot querySnapshot = await _db.collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Check if any documents were returned
      if (querySnapshot.docs.isNotEmpty) {
        // Return the data of the first user found
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        print('No user found with email: $email');
        return null; // Return null if no user was found
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return null; // Return null in case of an error
    }
  }
}
