import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/Buttons.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';

import '../CustomizedObjects/TextFormFields.dart';
import '../Singleton/FirebaseAdmin.dart';
import '../Singleton/PlatformAdmin.dart';

class CreaActividadView extends StatefulWidget {
  const CreaActividadView({Key? key}) : super(key: key);

  @override
  _CreaActividadViewState createState() => _CreaActividadViewState();
}

class _CreaActividadViewState extends State<CreaActividadView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();

  TextEditingController tecNombre = TextEditingController();
  TextEditingController tecDescripcion = TextEditingController();
  TextEditingController tecPrecio = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  File? _imagePreview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
      appBar: AppBar(
        title: const Text(
          "CREAR ACTIVIDAD",
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
                width: MediaQuery.of(context).size.width - 50,
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
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                                image: _imagePreview != null ? DecorationImage(image: FileImage(_imagePreview!), fit: BoxFit.cover) : null,
                              ),
                              child: _imagePreview == null ? const Icon(Icons.image, size: 70, color: Colors.white) : null,
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
                        child: OnBoardingFormField(
                          tec: tecNombre,
                          label: "Nombre de la actividad",
                          isPassword: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: OnBoardingFormField(
                          tec: tecDescripcion,
                          label: "Descripción",
                          isPassword: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: OnBoardingFormField(
                          tec: tecPrecio,
                          label: "Precio",
                          isPassword: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: InkWell(
                          onTap: _seleccionarFecha,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Fecha',
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
                            child: RoundedGreenButton(
                              function: _guardarActividad,
                              text: 'Guardar Actividad',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  Future<void> _guardarActividad() async {
    String nombre = tecNombre.text.trim();
    String descripcion = tecDescripcion.text.trim();
    String precioText = tecPrecio.text.trim();

    if (nombre.isNotEmpty && descripcion.isNotEmpty && precioText.isNotEmpty) {
      double precio = double.tryParse(precioText) ?? 0.0;

      String rutaNube = "Actividades/${fbAdmin.auth.currentUser?.uid}/${DateTime.now().millisecondsSinceEpoch}/image.jpg";
      String rutaDescarga = "";
      if (_imagePreview != null ) {
        rutaDescarga = await fbAdmin.uploadImageToStorage(rutaNube, _imagePreview!);
      }
          FActividad fActividad = FActividad(
            nombre: nombre,
            descripcion: descripcion,
            precio: precio,
            fecha: _fechaSeleccionada,
            imagenUrl: rutaDescarga,
          );

        await fbAdmin.subirActividad(fActividad);
        Navigator.pop(context);
    } else {
      print('Por favor rellena todos los campos');
    }
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
