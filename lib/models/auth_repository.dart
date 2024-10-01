import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  void logIn(username, password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: username, 
      password: password,
    );
  }

  void logOut(){
    FirebaseAuth.instance.signOut();
  }

  String? getUserEmail(){
    return FirebaseAuth.instance.currentUser!.email;
  }

}