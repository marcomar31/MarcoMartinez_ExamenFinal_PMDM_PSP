import 'package:firebase_auth/firebase_auth.dart';

import 'FirebaseAdmin.dart';

class DataHolder {

  static final DataHolder _dataHolder = DataHolder._internal();
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  User? usuarioActual;

  DataHolder._internal();

  factory DataHolder() {
    return _dataHolder;
  }

  void initDataHolder() {

  }

}