import 'package:cloud_firestore/cloud_firestore.dart';

class FActividad {
  final String nombre;
  final String descripcion;
  final DateTime fecha;
  final double precio;

  FActividad({
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.precio,
  });

  factory FActividad.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    final fechaTimestamp = data?['fecha'] as Timestamp?;
    final fecha = fechaTimestamp != null ? fechaTimestamp.toDate() : DateTime.now();

    return FActividad(
      nombre: data?['nombre'] ?? "",
      descripcion: data?['descripcion'] ?? "",
      fecha: fecha,
      precio: (data?['precio'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "nombre": nombre,
      "descripcion": descripcion,
      "fecha": fecha,
      "precio": precio,
    };
  }
}
