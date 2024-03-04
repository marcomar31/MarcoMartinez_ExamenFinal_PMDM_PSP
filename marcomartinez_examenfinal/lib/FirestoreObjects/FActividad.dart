import 'package:cloud_firestore/cloud_firestore.dart';

class FActividad {
  final String nombre;
  final String descripcion;
  final DateTime fecha;
  final double precio;
  final String imagenUrl;
  GeoPoint? geoloc;

  FActividad({
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.precio,
    required this.imagenUrl,
    this.geoloc,
  });

  factory FActividad.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    final fechaTimestamp = data?['fecha'] as Timestamp?;
    final fecha = fechaTimestamp != null ? fechaTimestamp.toDate() : DateTime.now();

    final geoloc = data?['geoloc'];
    final geoPoint = geoloc is GeoPoint ? geoloc : null;

    return FActividad(
      nombre: data?['nombre'] ?? "",
      descripcion: data?['descripcion'] ?? "",
      fecha: fecha,
      precio: (data?['precio'] ?? 0.0).toDouble(),
      imagenUrl: data?['imagenUrl'] ?? "",
      geoloc: geoPoint,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "nombre": nombre,
      "descripcion": descripcion,
      "fecha": fecha,
      "precio": precio,
      "imagenUrl": imagenUrl, 
      "geoloc": geoloc,
    };
  }
}
