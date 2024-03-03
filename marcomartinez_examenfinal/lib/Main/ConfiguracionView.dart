import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/Drawers.dart';

class ConfiguracionView extends StatelessWidget {
  const ConfiguracionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CONFIGURACIÓN",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: MainDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aquí va el contenido de la configuración',
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
