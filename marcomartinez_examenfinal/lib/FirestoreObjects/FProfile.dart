import 'package:cloud_firestore/cloud_firestore.dart';

class FProfile {
  final String nombre;
  final String apellidos;
  final DateTime fechaNacimiento;
  GeoPoint geoloc;

  FProfile({
    required this.nombre,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.geoloc,
  });

  factory FProfile.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    final fechaNacimientoTimestamp = data?['fechaNacimiento'] as Timestamp?;
    final fechaNacimiento = fechaNacimientoTimestamp != null
        ? fechaNacimientoTimestamp.toDate()
        : DateTime.now();

    return FProfile(
      nombre: data?['nombre'] ?? "",
      apellidos: data?['apellidos'] ?? "",
      fechaNacimiento: fechaNacimiento,
      geoloc:data?['geoloc'] != null ? data!['geoloc'] : const GeoPoint(0, 0)
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "nombre": nombre,
      "apellidos": apellidos,
      "fechaNacimiento": fechaNacimiento,
      "geoloc": geoloc,
    };
  }
}