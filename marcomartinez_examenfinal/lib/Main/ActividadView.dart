import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/Singleton/DataHolder.dart';

class ActividadView extends StatefulWidget {
  const ActividadView({super.key,});

  @override
  _ActividadViewState createState() => _ActividadViewState();
}

class _ActividadViewState extends State<ActividadView> {
  FActividad? actividad = DataHolder().selectedActivity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(actividad?.nombre ?? ""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mostrar información de la actividad
              const Text(
                'Descripción:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                actividad?.descripcion ?? "",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Fecha:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                actividad?.fecha.toString() ?? "",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
