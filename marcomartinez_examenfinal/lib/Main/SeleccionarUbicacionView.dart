import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SeleccionarUbicacionView extends StatefulWidget {
  @override
  _SeleccionarUbicacionViewState createState() => _SeleccionarUbicacionViewState();
}

class _SeleccionarUbicacionViewState extends State<SeleccionarUbicacionView> {
  late GoogleMapController _controller;
  LatLng? _ubicacionSeleccionada;
  Position? _posicionActual;

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionActual();
  }

  Future<void> _obtenerUbicacionActual() async {
    try {
      Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _posicionActual = posicion;
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SELECCIONAR UBICACIÓN",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _posicionActual != null
          ? GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _posicionActual!.latitude,
            _posicionActual!.longitude,
          ),
          zoom: 15,
        ),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        onTap: (LatLng ubicacion) {
          setState(() {
            _ubicacionSeleccionada = ubicacion;
          });
        },
        markers: _ubicacionSeleccionada != null
            ? <Marker>{
          Marker(
            markerId: const MarkerId('ubicacion'),
            position: _ubicacionSeleccionada!,
            draggable: true,
            onDragEnd: (LatLng posicion) {
              setState(() {
                _ubicacionSeleccionada = posicion;
              });
            },
          ),
        }
            : {},
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 20.0),
          child: FloatingActionButton(
            onPressed: () {
              if (_ubicacionSeleccionada != null) {
                Navigator.pop(context, _ubicacionSeleccionada);
              }
            },
            child: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}
