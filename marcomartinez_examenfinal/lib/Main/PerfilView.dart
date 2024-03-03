import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/TextFormFields.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FProfile.dart';
import 'package:marcomartinez_examenfinal/Singleton/FirebaseAdmin.dart';

import '../CustomizedObjects/Buttons.dart';
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

  TextEditingController tecNombreUsuario = TextEditingController();
  TextEditingController tecNombre = TextEditingController();
  TextEditingController tecApellidos = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  File? _imagePreview;
  late String imgUrl = "";
  late CircleAvatar circleAvatar;

  @override
  void initState() {
    super.initState();
    usuarioActual = fbAdmin.auth.currentUser!;
    perfilUsuario = DataHolder().perfil!;
    tecNombreUsuario.text = usuarioActual.displayName ?? "";
    tecNombre.text = perfilUsuario.nombre;
    tecApellidos.text = perfilUsuario.apellidos;
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

    if (imgUrl.isNotEmpty) {
      if (_imagePreview == null) {
        circleAvatar = CircleAvatar(
          radius: 70,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(imgUrl),
        );
      } else {
        circleAvatar = CircleAvatar(
          radius: 70,
          backgroundColor: Colors.grey,
          backgroundImage: FileImage(_imagePreview!),
        );
      }
    } else {
      circleAvatar = const CircleAvatar(
        radius: 70,
        backgroundColor: Colors.grey,
        backgroundImage: null,
        child: Icon(
          Icons.person_rounded,
          size: 70,
          color: Colors.white,
        )
      );
    }

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
                                      circleAvatar = const CircleAvatar(
                                          radius: 70,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: null,
                                          child: Icon(
                                            Icons.person_rounded,
                                            size: 70,
                                            color: Colors.white,
                                          )
                                      );
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
                            circleAvatar,
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
                        child: OnBoardingFormField(tec: tecNombreUsuario, label: 'Nombre de usuario', isPassword: false,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: OnBoardingFormField(tec: tecNombre, label: 'Nombre', isPassword: false,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: OnBoardingFormField(tec: tecApellidos, label: 'Apellidos', isPassword: false,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: InkWell(
                          onTap: _seleccionarFecha,
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
                            child: RoundedGreenButton(function: _guardarPerfil, text: 'Guardar Cambios',),
                          ),
                        ],
                      ),
                    ],
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
    String nombreUsuario = tecNombreUsuario.text.trim();
    String nombre = tecNombre.text.trim();
    String apellidos = tecApellidos.text.trim();
    if (nombreUsuario.isNotEmpty && nombre.isNotEmpty && apellidos.isNotEmpty) {
      print('Nombre de usuario: $nombreUsuario');
      print('Fecha de nacimiento: $_fechaSeleccionada');
      usuarioActual.updateDisplayName(nombreUsuario);
      if (_imagePreview != null) {
        subeFotoPerfil();
      }

      Position posicion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double latitud = posicion.latitude;
      double longitud = posicion.longitude;

      GeoPoint geoPoint = GeoPoint(latitud, longitud);

      FProfile perfil = FProfile(nombre: nombre, apellidos: apellidos, fechaNacimiento: _fechaSeleccionada, geoloc: geoPoint);
      await fbAdmin.creaPerfilUsuario(perfil);
      DataHolder().getProfile();
      Navigator.of(context).popAndPushNamed("/home_view");
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor rellene todos los campos.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
