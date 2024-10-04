import 'package:firebase_auth/firebase_auth.dart';
import 'package:restau/navigation/user_repository.dart';

class UserViewModel {
  final UserRepository repo = UserRepository();

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

  Future<List<String>> getLikedRestaurants() async {
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) {
      print('No user is currently logged in.');
      return [];
    }

    List<String>? restaurants = await repo.getLikedRestaurants(email);
    return restaurants;
  }

  Future<void> likeRestaurant(String restaurant) async{
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) {
      print('No user is currently logged in.');
    } else {
      await repo.likeRestaurant(email, restaurant);
    }
  }

  Future<void> unlikeRestaurant(String restaurant) async{
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) {
      print('No user is currently logged in.');
    } else {
      await repo.unlikeRestaurant(email, restaurant);
    }
  }

  void logOut(){
    repo.logOut();
  }
}
