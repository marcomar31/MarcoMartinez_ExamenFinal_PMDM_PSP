import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/ActividadesGridView.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/ActividadesListView.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/Drawers.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/Singleton/DataHolder.dart';
import 'package:marcomartinez_examenfinal/Singleton/GeolocAdmin.dart';

import '../Singleton/FirebaseAdmin.dart';
import '../Singleton/PlatformAdmin.dart';

class ResultadosBuscarActividadView extends StatefulWidget {
  final List<FActividad> matches;

  const ResultadosBuscarActividadView({
    super.key,
    required this.matches,
  });

  @override
  State<StatefulWidget> createState() => _ResultadosBuscarActividadViewState();
}

class _ResultadosBuscarActividadViewState extends State<ResultadosBuscarActividadView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  GeolocAdmin geolocAdmin = GeolocAdmin();
  final List<FActividad> actividades = [];
  bool blIsList = true;
  late Position position;
  bool _actividadEditada = false;

  @override
  void initState() {
    super.initState();
    inicializarDatos();
  }

  Future<void> inicializarDatos() async {
    descargarActividades();
    if (!PlatformAdmin.isWebPlatform()) {
      await determinarPosicionActual();
      DataHolder().suscribeACambiosGPSUsuario();
    }
  }

  Future<void> determinarPosicionActual() async {
    final positionTemp = await DataHolder().geolocAdmin.determinePosition();
    setState(() {
      position = positionTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text(
        "RESULTADOS BÚSQUEDA",
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
    );

    return Scaffold(
      body: Center(child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: celdasOLista(blIsList),
        ),
      ),
      ),
      drawer: const MainDrawer(),
      appBar: appBar,
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
    );
  }

  Widget? creadorDeItemLista(BuildContext context, int index) {
    if (actividades[index].imagenUrl != "") {
      return ActividadesListView(
          sText: actividades[index].nombre,
          dFontSize: 20,
          iPosicion: index,
          imageUrl: actividades[index].imagenUrl,
          onPressed: onPressedItemList
      );
    } else {
      return ActividadesListView(
          sText: actividades[index].nombre,
          dFontSize: 20,
          iPosicion: index,
          onPressed: onPressedItemList
      );
    }
  }

  Widget creadorDeSeparadorLista(BuildContext context, int index) {
    return const Divider(
      color: Color.fromRGBO(37, 77, 152, 1.0), thickness: 2,);
  }

  Widget? creadorDeItemMatriz(BuildContext context, int index) {
    return ActividadesGridView(
      actividades: actividades,
      iPosicion: index,
      onPressed: onPressedItemList,
      numActividadesFila: 3,);
  }

  Widget? celdasOLista(bool isList) {
    if (isList) {
      return SizedBox(
        child: ListView.separated(
          itemCount: actividades.length,
          itemBuilder: creadorDeItemLista,
          separatorBuilder: creadorDeSeparadorLista,
        ),
      );
    } else {
      return creadorDeItemMatriz(context, actividades.length);
    }
  }

  void onPressedItemList(int index) async {
    DataHolder().selectedActivity = actividades[index];
    DataHolder().saveSelectedActivityInCache();
    bool resultado = await Navigator.of(context).pushNamed(
        "/actividad_view") as bool? ?? false;
    if (resultado) {
      Navigator.of(context).pop(_actividadEditada);
    }
  }

  void descargarActividades() async {
      setState(() {
        actividades.addAll(widget.matches);
      });
  }
}