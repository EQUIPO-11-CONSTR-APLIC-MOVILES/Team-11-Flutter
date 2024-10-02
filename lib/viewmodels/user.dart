import 'package:firebase_auth/firebase_auth.dart';
import 'package:restau/models/auth_repository.dart';

class User {
  final AuthRepository repo = AuthRepository();

  Future<String?> getUserPic() async {
    String? email = FirebaseAuth.instance.currentUser?.email;

    // Check if the email is null
    if (email == null) {
      print('No user is currently logged in.');
      return null; // Or handle the case appropriately
    }

    // Fetch user information using the email
    Map<String, dynamic>? userInfo = await repo.getUserInfoByEmail(email);

    // Check if userInfo is null
    if (userInfo != null) {
      // Return the profile picture URL
      return userInfo['profilePic'] as String?;
    } else {
      print('User info not found for email: $email');
      return null; // Or handle the case appropriately
    }
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    String? email = FirebaseAuth.instance.currentUser?.email;

    // Check if the email is null
    if (email == null) {
      print('No user is currently logged in.');
      return null; // Or handle the case appropriately
    }

    // Fetch user information using the email
    Map<String, dynamic>? userInfo = await repo.getUserInfoByEmail(email);

    // Check if userInfo is null
    if (userInfo != null) {
      // Return the user information
      return userInfo;
    } else {
      print('User info not found for email: $email');
      return null; // Or handle the case appropriately
    }
  }
}
