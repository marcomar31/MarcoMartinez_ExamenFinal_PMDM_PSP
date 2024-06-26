import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/TextFormFields.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FProfile.dart';
import 'package:marcomartinez_examenfinal/Singleton/FirebaseAdmin.dart';

import '../CustomizedObjects/Buttons.dart';
import '../Singleton/DataHolder.dart';
import '../Singleton/PlatformAdmin.dart';

class CreaPerfilView extends StatefulWidget {
  const CreaPerfilView({super.key});

  @override
  State<StatefulWidget> createState() => _CreaPerfilViewState();
}

class _CreaPerfilViewState extends State<CreaPerfilView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  late User usuarioActual;

  late GlobalKey<FormState> _formKey;

  TextEditingController tecNombreUsuario = TextEditingController();
  TextEditingController tecNombre = TextEditingController();
  TextEditingController tecApellidos = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  File? _imagePreview;

  @override
  void initState() {
    super.initState();
    usuarioActual = DataHolder().usuarioActual!;
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = PlatformAdmin.getScreenWidth(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
      appBar: AppBar(
        title: const Text(
          "CONFIGURA TU PERFIL",
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
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('AVATAR DE USUARIO'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if(!PlatformAdmin.isWebPlatform())
                                  ElevatedButton(
                                    onPressed: () {
                                      onPressedCamera();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Tomar foto"),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      onPressedGallery();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Seleccionar de la galería"),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _imagePreview = null;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Eliminar"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey,
                              backgroundImage: _imagePreview != null
                                  ? FileImage(_imagePreview!)
                                  : null,
                              child: _imagePreview == null
                                  ? const Icon(
                                Icons.person_rounded,
                                size: 70,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 26,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: OnBoardingFormField(tec: tecNombreUsuario, label: 'Nombre de usuario', isPassword: false, mensajeError: "Introduzca su nombre de usuario"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: OnBoardingFormField(tec: tecNombre, label: 'Nombre', isPassword: false, mensajeError: "Introduzca su nombre real",),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: OnBoardingFormField(tec: tecApellidos, label: 'Apellidos', isPassword: false, mensajeError: "Introduzca sus apellidos"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: InkWell(
                          onTap: _seleccionarFecha,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Fecha de nacimiento',
                              icon: Icon(Icons.calendar_today_rounded,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: RoundedGreenButton(function: _guardarPerfil, text: 'Guardar Perfil',),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaSeleccionada = fechaSeleccionada;
      });
    }
  }

  Future<void> _guardarPerfil() async {
    if (_formKey.currentState!.validate()) {
      String nombreUsuario = tecNombreUsuario.text.trim();
      String nombre = tecNombre.text.trim();
      String apellidos = tecApellidos.text.trim();
      if (nombreUsuario.isNotEmpty &&
          nombre.isNotEmpty &&
          apellidos.isNotEmpty) {
        print('Nombre de usuario: $nombreUsuario');
        print('Fecha de nacimiento: $_fechaSeleccionada');
        usuarioActual.updateDisplayName(nombreUsuario);

        if (_imagePreview != null) {
          subeFotoPerfil();
        }

        FProfile perfil = FProfile(
          nombre: nombre,
          apellidos: apellidos,
          fechaNacimiento: _fechaSeleccionada,
          geoloc: const GeoPoint(0, 0),
        );

        await fbAdmin.creaPerfilUsuario(perfil);
        await DataHolder().getProfile();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Perfil creado exitosamente"),
          ),
        );
        Navigator.of(context).popAndPushNamed("/home_view");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Por favor, rellenetodos los campos"),
          ),
        );
      }
    }
  }

  Future<void> subeFotoPerfil() async {
    String rutaNube = "ProfilePictures/${usuarioActual.uid}/profilePicture.jpg";
    String rutaDescarga = await fbAdmin.uploadImageToStorage(rutaNube, _imagePreview!);
    usuarioActual.updatePhotoURL(rutaDescarga);
  }

  void onPressedCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }

  void onPressedGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }
}
