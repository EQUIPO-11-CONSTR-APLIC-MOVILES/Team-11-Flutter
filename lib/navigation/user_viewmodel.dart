import 'package:firebase_auth/firebase_auth.dart';
import 'package:restau/auth/auth_repository.dart';

class UserViewModel {
  final AuthRepository repo = AuthRepository();

  UserViewModel._privateConstructor();

  static final UserViewModel _instance = UserViewModel._privateConstructor();

  factory UserViewModel() {
    return _instance;
  }

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
