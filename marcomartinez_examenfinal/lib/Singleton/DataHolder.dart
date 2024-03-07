import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/Singleton/GeolocAdmin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../FirestoreObjects/FProfile.dart';
import 'FirebaseAdmin.dart';

class DataHolder {

  static final DataHolder _dataHolder = DataHolder._internal();
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  GeolocAdmin geolocAdmin = GeolocAdmin();
  User? usuarioActual;
  FProfile? perfil;
  FActividad? selectedActivity;

  DataHolder._internal();

  factory DataHolder() {
    return _dataHolder;
  }

  void initDataHolder() {

  }

  Future<void> getProfile() async {
    perfil = (await fbAdmin.descargarPerfil())!;
  }

  void saveSelectedActivityInCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('factivity_id', selectedActivity!.id);
    prefs.setString('factivity_nombre', selectedActivity!.nombre);
    prefs.setString('factivity_descripcion', selectedActivity!.descripcion);
    prefs.setString('factivity_imagen', selectedActivity!.imagenUrl);
    prefs.setString('factivity_fecha', selectedActivity!.fecha.toString());
    prefs.setDouble('factivity_precio', selectedActivity!.precio);
  }

  Future<FActividad?> loadCachedFActivity() async {
    if(selectedActivity != null) return selectedActivity;

    await Future.delayed(const Duration(seconds: 5));
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? fActivityId = prefs.getString('factivity_id');
    fActivityId ??= "";

    String? fActivityNombre = prefs.getString('factivity_nombre');
    fActivityNombre ??= "";

    String? fActivityDescripcion = prefs.getString('factivity_descripcion');
    fActivityDescripcion ??= "";

    String? fActivityImagen = prefs.getString('factivity_imagen');
    fActivityImagen ??= "";

    String? fActivityFecha = prefs.getString('factivity_fecha');
    fActivityFecha ??= "";

    double? fActivityPrecio = prefs.getDouble('factivity_precio');
    fActivityPrecio ?? 0;

    selectedActivity = FActividad(
        id: fActivityId,
        nombre: fActivityNombre,
        descripcion: fActivityDescripcion,
        fecha: DateTime.parse(fActivityFecha),
        imagenUrl: fActivityImagen,
        precio: fActivityPrecio ?? 0
    );

    return selectedActivity;
  }

  void suscribeACambiosGPSUsuario(){
    geolocAdmin.registrarCambiosLoc(posicionDelMovilCambio);
  }

  void posicionDelMovilCambio(Position? position) {
    if (perfil != null && position != null) {
      perfil!.geoloc = GeoPoint(position.latitude, position.longitude);
      fbAdmin.actualizarPerfilUsuario(perfil!);
    } else {
      print("Error: Usuario o posición es null. No se puede actualizar la ubicación.");
    }
  }

}