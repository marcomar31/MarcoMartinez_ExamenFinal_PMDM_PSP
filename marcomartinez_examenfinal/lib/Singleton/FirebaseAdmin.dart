import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAdmin {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createUser(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      if (email.contains("@")) {
        auth.createUserWithEmailAndPassword(email: email, password: password);
      } else {
        print("El email debe contener el caracter \"@\"");
      }
    } else {
      print("Email y contraseña tienen que tener contenido");
    }
  }

  Future<bool> logInWithEmail(String email, String password) async  {
    if (email.isNotEmpty && password.isNotEmpty) {
      if (email.contains("@")) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password
          );
          return true;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
          return false;
        }
      } else {
        print("El email debe contener el caracter \"@\"");
        return false;
      }
    } else {
      print("Email y contraseña tienen que tener contenido");
      return false;
    }
  }
}