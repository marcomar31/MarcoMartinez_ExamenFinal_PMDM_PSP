import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/ActividadesListView.dart';

import '../FirestoreObjects/FActividad.dart';

class ActividadesGridView extends StatelessWidget {

  final List<FActividad> actividades;

  const ActividadesGridView({
    super.key,
    required this.actividades,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
      itemCount: actividades.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(color: const Color.fromRGBO(60, 101, 145, 1.0),
          alignment: Alignment.center,child:
          ActividadesListView(
            sText: actividades[index].nombre,
            dFontSize: 20,
          ),
        );
      },
    );

  }
}