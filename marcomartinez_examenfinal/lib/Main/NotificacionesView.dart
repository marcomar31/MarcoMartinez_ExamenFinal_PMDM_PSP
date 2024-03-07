import 'package:flutter/material.dart';

class NotificacionesView extends StatelessWidget {
  const NotificacionesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notificaciones",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No hay notificaciones disponibles",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
          ),
          ),
        ],
        ),
      ),
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
    );
  }
}
