import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void logOut() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_profile_pic');
    print("borrao");
    FirebaseAuth.instance.signOut();
  }

  Future<String> getUserId(String email) async{
    try {
      QuerySnapshot querySnapshot =
          await _db.collection('users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        print('No user found with email: $email');
        return "null";
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return "null";
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      // Get the current user's email
      String? email = FirebaseAuth.instance.currentUser?.email;

      if (email == null) {
        throw Exception("User is not logged in.");
      }

      // Query the user's document in Firestore
      QuerySnapshot querySnapshot = await _db.collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the user
        String docId = querySnapshot.docs.first.id;

        // Update the name in Firestore
        await _db.collection('users').doc(docId).update({'name': newName});

        // Optionally update SharedPreferences if needed
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', newName);

        print("User name updated successfully.");
      } else {
        print('No user found with email: $email');
      }
    } catch (e) {
      print("Error updating user name: $e");
    }
  }
  Future<Map<String, dynamic>?> getUserInfoByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection('users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        print('No user found with email: $email');
        return null;
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return null;
    }
  }

  Future<List<String>> getLikedRestaurants(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection('users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        List<String> likedRestaurants = List<String>.from(userData['likes'] ?? []);
        return likedRestaurants;
      } else {
        print('No user found with email: $email');
        return [];
      }
    } catch (e) {
      print("Error fetching liked restaurants: $e");
      return [];
    }
  }

  Future<void> likeRestaurant(String email, String restaurantId) async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection('users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        List<String> likedRestaurants = List<String>.from(userData['likes'] ?? []);

        if (!likedRestaurants.contains(restaurantId)) {
          likedRestaurants.add(restaurantId);

          await _db.collection('users').doc(userDoc.id).update({'likes': likedRestaurants});
        } 
      } else {
        print('No user found with email: $email');
      }
    } catch (e) {
      print("Error liking restaurant: $e");
    }
  }

  Future<void> unlikeRestaurant(String email, String restaurantId) async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection('users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        List<String> likedRestaurants = List<String>.from(userData['likes'] ?? []);

        if (likedRestaurants.contains(restaurantId)) {
          likedRestaurants.remove(restaurantId);

          await _db.collection('users').doc(userDoc.id).update({'likes': likedRestaurants});
        } 
      } else {
        print('No user found with email: $email');
      }
    } catch (e) {
      print("Error unliking restaurant: $e");
    }
  }

  Future<bool> isLiked(String email, String restaurantId) async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection('users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        List<String> likedRestaurants = List<String>.from(userData['likes'] ?? []);

        // Check if the restaurant ID is in the list of likes
        return likedRestaurants.contains(restaurantId);
      } else {
        print('No user found with email: $email');
        return false;
      }
    } catch (e) {
      print("Error checking if restaurant is liked: $e");
      return false;
    }
  }
}
