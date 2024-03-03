import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';

class ActividadesGridView extends StatelessWidget {
  final List<FActividad> actividades;
  final int iPosicion;
  final Function(int indice)? onPressed;
  final int numActividadesFila;

  const ActividadesGridView({
    super.key,
    required this.actividades,
    required this.iPosicion,
    required this.onPressed,
    required this.numActividadesFila
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numActividadesFila,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: actividades.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            onPressed!(index);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              color: const Color.fromRGBO(22, 36, 71, 1),
              child: Stack(
                children: [
                  if (actividades[index].imagenUrl.isNotEmpty) ...[
                    SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        actividades[index].imagenUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          actividades[index].nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  if (!actividades[index].imagenUrl.isNotEmpty)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          actividades[index].nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
