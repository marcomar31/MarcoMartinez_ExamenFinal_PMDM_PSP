import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FProfile.dart';
import 'package:marcomartinez_examenfinal/Singleton/FirebaseAdmin.dart';

import '../Singleton/DataHolder.dart';
import '../Singleton/PlatformAdmin.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<StatefulWidget> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  late User usuarioActual;
  late FProfile perfilUsuario;

  late GlobalKey<FormState> _formKey;

  File? _imagePreview;
  late String imgUrl = "";
  late CircleAvatar circleAvatar;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    usuarioActual = fbAdmin.auth.currentUser!;
    perfilUsuario = DataHolder().perfil!;
    getProfileImage();
  }

  Future<void> getProfileImage() async {
    try {
      imgUrl = await fbAdmin.downloadUserProfileImage();
      setState(() {
        if (imgUrl.isNotEmpty) {
          circleAvatar = CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(imgUrl),
          );
        }
      });
    } catch (error) {
      print('Error al descargar la imagen del perfil: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = PlatformAdmin.getScreenWidth(context);

    circleAvatar = CircleAvatar(
      radius: 70,
      backgroundColor: Colors.grey,
      backgroundImage: (imgUrl.isNotEmpty && _imagePreview == null)
          ? NetworkImage(imgUrl) as ImageProvider<Object>
          : _imagePreview != null
          ? FileImage(_imagePreview!)
          : null,
      child: imgUrl.isEmpty && _imagePreview == null
          ? const Icon(
        Icons.person_rounded,
        size: 70,
        color: Colors.white,
      )
          : null,
    );


    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
      appBar: AppBar(
        title: const Text(
          "TU PERFIL",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: (screenWidth < 600) ? PlatformAdmin.getScreenWidth(context)-50 : 600,
                child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        circleAvatar,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: InkWell(
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nombre de usuario',
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${usuarioActual.displayName}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: InkWell(
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nombre',
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    perfilUsuario.nombre,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: InkWell(
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Apellidos',
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    perfilUsuario.apellidos,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: InkWell(
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Fecha de nacimiento',
                                icon: Icon(Icons.calendar_today_rounded),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${perfilUsuario.fechaNacimiento.day}/${perfilUsuario.fechaNacimiento.month}/${perfilUsuario.fechaNacimiento.year}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/editaperfil_view");
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_rounded),
              SizedBox(width: 12),
              Text('Editar', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
