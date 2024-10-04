import 'package:restau/models/auth_repository.dart';

class LogInViewmodel {
  AuthRepository repo = AuthRepository();

  void logIn(String username, String password) {
    repo.logIn(username, password);
  }

  void logOut() {
    repo.logOut();
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

  Future<List<Map<String, dynamic>>> getAllPreferences() async {
    return repo.getAllPreferences();
  }
}
