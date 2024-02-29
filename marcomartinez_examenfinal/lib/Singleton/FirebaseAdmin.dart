import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAdmin {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> createUser(String email, String password, String rePassword) async {
    if (email.isNotEmpty && password.isNotEmpty && rePassword.isNotEmpty) {
      if (email.contains("@")) {
        if (password == rePassword) {
          try {
            auth.createUserWithEmailAndPassword(email: email, password: password);
            print("Creado");
            return true;
          } catch (e) {
            print(e);
            return false;
          }
        } else {
          print("No creado");
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

  Future<bool> logInWithEmail(String email, String password) async  {
    if (email.isNotEmpty && password.isNotEmpty) {
      if (email.contains("@")) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password
          );
          return true;
        } catch (e) {
          print("Error al iniciar sesión");
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