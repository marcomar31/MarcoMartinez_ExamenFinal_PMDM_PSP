import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/Drawers.dart';
import 'package:marcomartinez_examenfinal/Main/NotificacionesView.dart';

import '../Singleton/FirebaseAdmin.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();

  @override
  Widget build(BuildContext context) {
    Column column = const Column(
      children: [

      ],
    );

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
      body: SingleChildScrollView(child: Center(child: column)),
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
}