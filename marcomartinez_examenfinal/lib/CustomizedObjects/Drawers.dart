import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/Singleton/DataHolder.dart';

import '../Singleton/FirebaseAdmin.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final FirebaseAdmin fbAdmin = FirebaseAdmin();
  late User usuarioActual;

  @override
  void initState() {
    super.initState();
    usuarioActual = DataHolder().usuarioActual!;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(2, 25, 52, 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  fbAdmin.auth.currentUser?.displayName ?? "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                if (usuarioActual.email != null)
                  Text(
                    usuarioActual.email ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: usuarioActual.photoURL != null
                          ? NetworkImage(usuarioActual.photoURL!)
                          : null,
                      child: usuarioActual.photoURL == null
                          ? const Icon(
                        Icons.person_rounded,
                        size: 30,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home'),
            onTap: () {

            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Configuración'),
            onTap: () {

            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Cerrar sesión'),
            onTap: () async {
                await fbAdmin.signOutUsuario();
                Navigator.of(context).pop();
                Navigator.of(context).popAndPushNamed("/onboarding_view");
            },
          ),
        ],
      ),

    );
  }

}