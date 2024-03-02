import 'package:flutter/material.dart';

import '../Singleton/FirebaseAdmin.dart';

class MainDrawer extends StatelessWidget {
  final FirebaseAdmin fbAdmin = FirebaseAdmin();

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
                if (fbAdmin.auth.currentUser?.email != null)
                    Text(
                      fbAdmin.auth.currentUser?.email ?? '',
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

            },
          ),
          ListTile(
            leading: const Icon(Icons.message_rounded),
            title: const Text('Mensajes'),
            onTap: () {

            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Configuración'),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }
}