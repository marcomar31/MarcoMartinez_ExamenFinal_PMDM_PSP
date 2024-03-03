import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/ActividadesGridView.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/ActividadesListView.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/Drawers.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/Main/NotificacionesView.dart';

import '../Singleton/FirebaseAdmin.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  final List<FActividad> actividades = [];
  bool blIsList = true;

  @override
  void initState() {
    descargarActividades();
    super.initState();
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
          icon: Icon(Icons.search_rounded),
          onPressed: () {

          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificacionesView()),
            );          },
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
      drawer: MainDrawer(),
      appBar: appBar,
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed("/creaactividad_view");
          } else if (index == 1) {
            setState(() {
              blIsList = true;
            });
          } else if (index == 2) {
            setState(() {
              blIsList = false;
            });
          } else if (index == 3) {
            // Navigator.of(context).pushNamed("/perfil_view");
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
    return ActividadesListView(sText: actividades[index].nombre,
        dFontSize: 20);
  }

  Widget creadorDeSeparadorLista(BuildContext context, int index) {
    return const Divider(color: Color.fromRGBO(37, 77, 152, 1.0), thickness: 2,);
  }

  Widget celdasOLista(bool isList) {
    if (isList) {
      return SizedBox(
        child: ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: actividades.length,
          itemBuilder: creadorDeItemLista,
          separatorBuilder: creadorDeSeparadorLista,
        ),
      );
    } else {
      return ActividadesGridView(actividades: actividades);
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
}