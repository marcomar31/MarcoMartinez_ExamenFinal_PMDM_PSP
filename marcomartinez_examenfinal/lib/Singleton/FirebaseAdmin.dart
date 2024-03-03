import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FProfile.dart';

import 'DataHolder.dart';

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
          DataHolder().usuarioActual = auth.currentUser;
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
      DataHolder().usuarioActual = auth.currentUser;
      return true;
    } catch (e) {
      print('Excepción: $e');
      return false;
    }
  }

  Future<void> signOutUsuario() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> creaPerfilUsuario(FProfile profile) async {
    await db.collection("Perfiles").doc(auth.currentUser?.uid).set(profile.toFirestore());
  }

  void actualizarPerfilUsuario(FProfile perfil) async{
    await db.collection("Perfiles").doc(auth.currentUser?.uid).set(perfil.toFirestore());
  }

  Future<FProfile?> descargarPerfil() async {
    if (auth.currentUser != null) {
      String? uid = DataHolder().usuarioActual?.uid;
      DocumentReference<FProfile> ref = db.collection("Perfiles")
          .doc(uid)
          .withConverter(
        fromFirestore: FProfile.fromFirestore,
        toFirestore: (FProfile perfil, _) => perfil.toFirestore(),
      );

      DocumentSnapshot<FProfile> docSnap = await ref.get();
      DataHolder().perfil = docSnap.data();
      return DataHolder().perfil;
    } else {
      print("Usuario no autenticado");
      return null;
    }
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

  Future<String> downloadUserProfileImage() async {
    if (auth.currentUser?.photoURL != null) {
      Reference ref = FirebaseStorage.instance.refFromURL(auth.currentUser!.photoURL ?? "");
      try {
        return await ref.getDownloadURL();
      } catch (e) {
        print("Error al descargar la imagen de perfil: $e");
        return "";
      }
    }
    else {
      return "";
    }
  }

  Future<void> subirActividad(FActividad actividadNueva) async {
    CollectionReference<FActividad> postsRef = db.collection("Actividades")
        .withConverter(
      fromFirestore: FActividad.fromFirestore,
      toFirestore: (FActividad actividad, _) => actividad.toFirestore(),
    );

    postsRef.add(actividadNueva);
  }
}