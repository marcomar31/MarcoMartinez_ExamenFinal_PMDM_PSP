import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/ActividadesGridView.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/ActividadesListView.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/Drawers.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/Main/NotificacionesView.dart';
import 'package:marcomartinez_examenfinal/Singleton/DataHolder.dart';
import 'package:marcomartinez_examenfinal/Singleton/GeolocAdmin.dart';

import '../Singleton/FirebaseAdmin.dart';
import '../Singleton/PlatformAdmin.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  GeolocAdmin geolocAdmin = GeolocAdmin();
  final List<FActividad> actividades = [];
  bool blIsList = true;
  late Position position;

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
        "HOME",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            actualizarActividades();
          },
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {

          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_rounded),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificacionesView())).then((_)  {
              actualizarActividades();
            });
          },
        ),
      ],
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed("/creaactividad_view").then((_) {
              actualizarActividades();
            });
          } else if (index == 1) {
            setState(() {
              blIsList = true;
            });
          } else if (index == 2) {
            setState(() {
              blIsList = false;
            });
          } else if (index == 3) {
            Navigator.of(context).pushNamed("/perfil_view").then((_) {
              actualizarActividades();
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Crear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Vista de lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on_rounded),
            label: 'Vista de celdas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
      ),
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
    return const Divider(color: Color.fromRGBO(37, 77, 152, 1.0), thickness: 2,);
  }

  Widget? creadorDeItemMatriz(BuildContext context, int index){
    return ActividadesGridView(actividades: actividades, iPosicion: index, onPressed: onPressedItemList, numActividadesFila: 3,);
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
    bool resultado = await Navigator.of(context).pushNamed("/actividad_view") as bool? ?? false;
    if (resultado) {
      actualizarActividades();
    }
  }

  void descargarActividades() async {
    CollectionReference<FActividad> reference = fbAdmin.db
        .collection("Actividades")
        .withConverter(fromFirestore: FActividad.fromFirestore,
        toFirestore: (FActividad actividad, _) => actividad.toFirestore());

    QuerySnapshot<FActividad> querySnap = await reference.get();
    for (int i = 0; i < querySnap.docs.length; i++) {
      setState(() {
        actividades.add(querySnap.docs[i].data());
      });
    }
  }

  void actualizarActividades() async {
    setState(() {
      actividades.clear();
    });
    descargarActividades();
  }

}