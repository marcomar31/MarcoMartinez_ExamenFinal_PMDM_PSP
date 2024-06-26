import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FProfile.dart';

import 'DataHolder.dart';

class FirebaseAdmin {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage fbStorage = FirebaseStorage.instance;

  Future<bool> createUser(String email, String password, String rePassword, BuildContext context) async {
    if (email.isNotEmpty && password.isNotEmpty && rePassword.isNotEmpty) {
      if (email.contains("@")) {
        if (password == rePassword) {
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
            DataHolder().usuarioActual = FirebaseAuth.instance.currentUser;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Usuario registrado exitosamente"),
              ),
            );
            return true;
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error al crear el usuario, el email ya está en uso"),
              ),
            );
            return false;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Las contraseñas no coinciden"),
            ),
          );
          return false;
        }
      } else {
        // Mostrar mensaje de error utilizando Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("El email debe contener el caracter \"@\""),
          ),
        );
        return false;
      }
    } else {
      // Mostrar mensaje de error utilizando Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email y contraseña tienen que tener contenido"),
        ),
      );
      return false;
    }
  }

  Future<bool> logInWithEmail(String email, String password, BuildContext context) async  {
    if (email.isNotEmpty && password.isNotEmpty) {
      if (email.contains("@")) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password
          );
          DataHolder().usuarioActual = FirebaseAuth.instance.currentUser;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Ha iniciado sesión exitosamente"),
            ),
          );
          return true;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error al iniciar sesión, compruebe que sus credenciales son correctas"),
            ),
          );
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("El email debe contener el caracter \"@\""),
          ),
        );
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email y contraseña tienen que tener contenido"),
        ),
      );
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

  Future<void> signOutUsuario(BuildContext context) async {
    await auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ha cerrado sesión exitosamente"),
      ),
    );
  }

  Future<void> creaPerfilUsuario(FProfile profile) async {
    await db.collection("Perfiles").doc(auth.currentUser?.uid).set(profile.toFirestore());
  }

  Future<void> actualizarPerfilUsuario(FProfile perfil) async {
        await db.collection("Perfiles").doc(auth.currentUser?.uid).update(perfil.toFirestore());
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
  Future<String> updateImageStorage(String rutaNubeAnterior, String rutaNubeNueva, File rutaLocal) async {
    final storageRef = fbStorage.ref();
    final rutaAFicheroEnNubeAnterior = storageRef.child(rutaNubeAnterior);
    final rutaAFicheroEnNubeNueva = storageRef.child(rutaNubeNueva);

    rutaAFicheroEnNubeAnterior.delete();

    try {
      UploadTask uploadTask = rutaAFicheroEnNubeNueva.putFile(rutaLocal);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("ERROR AL ACTUALIZAR IMAGEN: $e");
      return "";
    }
  }

  Future<String> downloadUserProfileImage() async {
    if (auth.currentUser?.photoURL != null) {
      Reference ref = fbStorage.refFromURL(auth.currentUser!.photoURL ?? "");
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

  Future<String> downloadActivityImage() async {
    if (DataHolder().selectedActivity!.imagenUrl.isNotEmpty) {
      Reference ref = fbStorage.refFromURL(DataHolder().selectedActivity!.imagenUrl);
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

  Future<void> subirActividadCustomId(FActividad actividadNueva) async {
    CollectionReference<Map<String, dynamic>> postsRef = db.collection("Actividades");

    await postsRef.doc(actividadNueva.id).set(
      actividadNueva.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<void> actualizarActividad(FActividad actividad) async {
    String? selectedActivity = DataHolder().selectedActivity?.id ?? "";
    await db.collection("Actividades").doc(selectedActivity).update(actividad.toFirestore());
  }

  Future<List<FActividad>> buscarActividadesPorTitulo(String searchValue, List<FActividad> coleccionActividades) async {
    List<FActividad> matches = [];
    for (var actividad in coleccionActividades) {
      if (actividad.nombre.toLowerCase().contains(
          searchValue.toLowerCase())) {
        matches.add(actividad);
      }
    }

    return matches;
  }
}