import 'dart:math';
import 'package:restau/models/auth_repository.dart';
import 'user.dart'; // Assuming this is a model representing the user

class LogInViewmodel {
  AuthRepository repo = AuthRepository();

  final List<String> _profilePics = [
    "https://firebasestorage.googleapis.com/v0/b/restau-5dba7.appspot.com/o/profilePics%2Falien.png?alt=media&token=741eaac3-c4a5-4753-9293-9f40826dbc0d",
    "https://firebasestorage.googleapis.com/v0/b/restau-5dba7.appspot.com/o/profilePics%2Fant.png?alt=media&token=183f90eb-5ef3-4206-a863-738c64235cef",
    "https://firebasestorage.googleapis.com/v0/b/restau-5dba7.appspot.com/o/profilePics%2Fastronaut.png?alt=media&token=d4eb4a0f-0205-4d78-9edb-3fbcab8181de",
    "https://firebasestorage.googleapis.com/v0/b/restau-5dba7.appspot.com/o/profilePics%2Fbee.png?alt=media&token=7a934c3e-a0bd-4557-b64d-200aec680bf2",
    "https://firebasestorage.googleapis.com/v0/b/restau-5dba7.appspot.com/o/profilePics%2Fcat.png?alt=media&token=ec0c9822-0446-453d-92de-d67620be6008"
  ];

  void logIn(String username, String password) {
    repo.logIn(username, password);
  }

  void logOut() {
    repo.logOut();
  }

  void registerUser(String email, String user, String password, List<String> preferences) {
    String randomProfilePic = _profilePics[Random().nextInt(_profilePics.length)];
    repo.registerUser(email, user, password, randomProfilePic, preferences);
  }

  String checkValidUser(String email, String password, String name) {
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  final validCharsRegex = RegExp(r'^[a-zA-Z0-9._-]+$');

  if (password.isEmpty || name.isEmpty || email.isEmpty){
    return "empty";
  }

  if (email.length > 320 || !emailRegex.hasMatch(email)) {
    return "email";
  }
  if (name.length < 3 || name.length > 32 || !validCharsRegex.hasMatch(name)) {
    return "name";
  }
  if (password.length < 6 || password.length > 32 || !validCharsRegex.hasMatch(password)) {
    return "password";
  }
  return "valid";
}

String checkValidLog(String password, String email) {
  if (password.isEmpty || email.isEmpty){
    return "empty";
  }
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final validCharsRegex = RegExp(r'^[a-zA-Z0-9._-]+$');
  if (email.length > 320 || !emailRegex.hasMatch(email)) {
    return "email";
  }
  if (password.length < 6 || password.length > 32 || !validCharsRegex.hasMatch(password)) {
    return "password";
  }
  return "valid";
}

}
