import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/Buttons.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/Singleton/DataHolder.dart';

import '../CustomizedObjects/TextFormFields.dart';
import '../Singleton/FirebaseAdmin.dart';
import '../Singleton/PlatformAdmin.dart';
import 'SeleccionarUbicacionView.dart';

class EditaActividadView extends StatefulWidget {
  const EditaActividadView({super.key});

  @override
  _EditaActividadViewState createState() => _EditaActividadViewState();
}

class _EditaActividadViewState extends State<EditaActividadView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();

  late GlobalKey<FormState> _formKey;
  bool _actividadEditada = false;

  TextEditingController tecNombre = TextEditingController();
  TextEditingController tecDescripcion = TextEditingController();
  TextEditingController tecPrecio = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  File? _imagePreview;
  LatLng? _ubicacionSeleccionada;
  bool _imagenCambiada = false;
  late Container containerImage;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    tecNombre.text = DataHolder().selectedActivity!.nombre;
    tecDescripcion.text = DataHolder().selectedActivity!.descripcion;
    tecPrecio.text = DataHolder().selectedActivity!.precio.toString();
    _fechaSeleccionada = DataHolder().selectedActivity!.fecha;
    final geoloc = DataHolder().selectedActivity?.geoloc;
    if (geoloc != null) {
      double? latitud = geoloc.latitude;
      double? longitud = geoloc.longitude;
      _ubicacionSeleccionada = LatLng(latitud, longitud);
    }
    _iniciarContenedorImagen();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = PlatformAdmin.getScreenWidth(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
      appBar: AppBar(
        title: const Text(
          "EDITAR ACTIVIDAD",
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
                                title: const Text('IMAGEN DE ACTIVIDAD'),
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
                                        containerImage = Container(
                                          width: 140,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20),
                                            image: _imagePreview != null
                                                ? DecorationImage(image: FileImage(_imagePreview!), fit: BoxFit.cover)
                                                : null,
                                          ),
                                          child: _imagePreview == null ? const Icon(Icons.image, size: 70, color: Colors.white) : null,
                                        );
                                        _imagenCambiada = true;
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
                              containerImage,
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
                            mensajeError: "Introduzca el nombre de la actividad",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: OnBoardingFormField(
                            tec: tecDescripcion,
                            label: "Descripción",
                            isPassword: false,
                            mensajeError: "Introduzca la descipción de la actividad",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: OnBoardingFormField(
                            tec: tecPrecio,
                            label: "Precio",
                            isPassword: false,
                            mensajeError: "Introduzca el precio (número) de la actividad",
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
                        ElevatedButton(
                          onPressed: () async {
                            _ubicacionSeleccionada = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SeleccionarUbicacionView(),
                              ),
                            );
                          },
                          child: const Text('Seleccionar Ubicación en el Mapa'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null && pickedDate != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = pickedDate;
      });
    }
  }

  Future<void> _guardarActividad() async {
    if (_formKey.currentState!.validate()) {
      String nombre = tecNombre.text.trim();
      String descripcion = tecDescripcion.text.trim();
      String precioText = tecPrecio.text.trim();

      if (nombre.isNotEmpty && descripcion.isNotEmpty &&
          precioText.isNotEmpty) {
        if (double.tryParse(precioText) == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El precio debe ser un número válido'),
            ),
          );
          return;
        }

        double precio = double.parse(precioText);

        String? rutaDescarga = DataHolder().selectedActivity?.imagenUrl;

        if (_imagenCambiada){
          String rutaNube = "Actividades/${fbAdmin.auth.currentUser
              ?.uid}/${DateTime
              .now()
              .millisecondsSinceEpoch}/image.jpg";
          if (_imagePreview != null) {
            rutaDescarga = await fbAdmin.uploadImageToStorage(rutaNube, _imagePreview!);
          } else {
            rutaDescarga = "";
          }
        }

        FActividad fActividad;
        String idActividad = DataHolder().selectedActivity?.id ?? "";

        final ubicacionSeleccionada = _ubicacionSeleccionada;
        if (ubicacionSeleccionada != null) {
          double latitud = ubicacionSeleccionada.latitude;
          double longitud = ubicacionSeleccionada.longitude;

          fActividad = FActividad(
            id: idActividad,
            nombre: nombre,
            descripcion: descripcion,
            precio: precio,
            fecha: _fechaSeleccionada,
            imagenUrl: rutaDescarga!,
            geoloc: GeoPoint(latitud, longitud),
          );
        } else {
          fActividad = FActividad(
            id: idActividad,
            nombre: nombre,
            descripcion: descripcion,
            precio: precio,
            fecha: _fechaSeleccionada,
            imagenUrl: rutaDescarga!,
          );
        }

        await fbAdmin.actualizarActividad(fActividad);
        _actividadEditada = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Actividad Editada exitosamente'),
          ),
        );
        Navigator.of(context).pop(_actividadEditada);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, rellena todos los campos'),
          ),
        );
      }
    }
  }

  void onPressedCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
        containerImage = Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            image: _imagePreview != null
                ? DecorationImage(image: FileImage(_imagePreview!), fit: BoxFit.cover)
                : null,
          ),
          child: _imagePreview == null ? const Icon(Icons.image, size: 70, color: Colors.white) : null,
        );
        _imagenCambiada = true;
      });
    }
  }

  void onPressedGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
        containerImage = Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            image: _imagePreview != null
                ? DecorationImage(image: FileImage(_imagePreview!), fit: BoxFit.cover)
                : null,
          ),
          child: _imagePreview == null ? const Icon(Icons.image, size: 70, color: Colors.white) : null,
        );
        _imagenCambiada = true;
      });
    }
  }

  void _iniciarContenedorImagen() {
    containerImage = Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        image: DataHolder().selectedActivity!.imagenUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(DataHolder().selectedActivity!.imagenUrl), fit: BoxFit.cover)
            : _imagePreview != null
            ? DecorationImage(image: FileImage(_imagePreview!), fit: BoxFit.cover)
            : null,
      ),
      child: (_imagePreview == null && DataHolder().selectedActivity!.imagenUrl.isEmpty) ? const Icon(Icons.image, size: 70, color: Colors.white) : null,
    );
  }
}
