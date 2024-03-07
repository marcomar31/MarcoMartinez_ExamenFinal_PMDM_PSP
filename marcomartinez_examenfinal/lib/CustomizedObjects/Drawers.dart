import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/Singleton/DataHolder.dart';

import '../Singleton/FirebaseAdmin.dart';
import '../Singleton/PlatformAdmin.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: fbAdmin.auth.currentUser?.photoURL != null
                          ? NetworkImage(fbAdmin.auth.currentUser?.photoURL ?? "")
                          : null,
                      child: fbAdmin.auth.currentUser?.photoURL == null
                          ? const Icon(
                        Icons.person_rounded,
                        size: 30,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ],
                ),
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

              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/home_view");
            },
          ),
          if (!PlatformAdmin.isWebPlatform())
          ListTile(
            leading: const Icon(Icons.map_rounded),
            title: const Text('Mapa'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/mapa_view");
            },
          ),
          ListTile(
            leading: const Icon(Icons.tag_faces_rounded),
            title: const Text('BoredAPI'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/boredapi_view");
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/configuracion_view");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Cerrar sesión'),
            onTap: () async {
                await fbAdmin.signOutUsuario(context);
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/onboarding_view");
            },
          ),
        ],
      ),
    );
  }

}