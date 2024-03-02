import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAdmin {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage fbStorage = FirebaseStorage.instance;

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

  Future<void> verificarTelefono(String numTelefono, void Function(PhoneAuthCredential) whenCompleted, void Function(FirebaseAuthException) whenFailed, void Function(String verificationId, int? forceResendingToken) codeSent, void Function(String verificacionId) codeAutoRetrievalTimeout) async {
    await auth.verifyPhoneNumber(
      phoneNumber: numTelefono,
      verificationCompleted: whenCompleted,
      verificationFailed: whenFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<bool> signInWithPhoneNumber(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Excepción: $e');
      return false;
    }
  }

  Future<void> creaPerfilUsuario(Map<String, dynamic> user) async {
    db.collection("Perfiles").doc(auth.currentUser?.uid).set(user);
  }

  Future<String> uploadImageToStorage(String rutaNube, File rutaLocal) async {
    final storageRef = fbStorage.ref();
    final rutaAFicheroEnNube = storageRef.child(rutaNube);

    try {
      UploadTask uploadTask = rutaAFicheroEnNube.putFile(rutaLocal);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("ERROR AL SUBIR IMAGEN: $e");
      return "";
    }
  }
}