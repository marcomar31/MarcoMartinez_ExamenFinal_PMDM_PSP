import 'package:firebase_auth/firebase_auth.dart';

import '../FirestoreObjects/FProfile.dart';
import 'FirebaseAdmin.dart';

class DataHolder {

  static final DataHolder _dataHolder = DataHolder._internal();
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  User? usuarioActual;
  FProfile? perfil;

  DataHolder._internal();

  factory DataHolder() {
    return _dataHolder;
  }

  void initDataHolder() {

  }

}