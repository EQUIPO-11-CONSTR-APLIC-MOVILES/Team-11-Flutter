import 'package:restau/models/auth_repository.dart';

class LogInViewmodel {
  AuthRepository repo = AuthRepository();

  void logIn(username, password){
    repo.logIn(username, password);
  }

  void logOut(){
    repo.logOut();
  }

}