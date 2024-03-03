import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FProfile.dart';

class MapaView extends StatefulWidget {
  const MapaView({Key? key}) : super(key: key);

  @override
  State<MapaView> createState() => MapaViewState();
}

class MapaViewState extends State<MapaView> {
  Position? _ubicacionActual;
  late GoogleMapController _controller;
  Set<Marker> marcadores = {};
  FirebaseFirestore db = FirebaseFirestore.instance;
  final Map<String, FProfile> tablaUsuarios = {};
  MapType _tipoMapa = MapType.normal;
  CameraPosition? _kUser;

  @override
  void initState() {
    obtenerUbicacionActual();
    suscribirADescargaUsuarios();
    super.initState();
  }

  Future<void> obtenerUbicacionActual() async {
    final posicion = await Geolocator.getCurrentPosition();
    setState(() {
      _ubicacionActual = posicion;
      _kUser = CameraPosition(
        target: LatLng(
          _ubicacionActual!.latitude,
          _ubicacionActual!.longitude,
        ),
        zoom: 15.0,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void suscribirADescargaUsuarios() async {
    CollectionReference<FProfile> ref = db.collection("Usuarios")
        .withConverter(
      fromFirestore: FProfile.fromFirestore,
      toFirestore: (FProfile user, _) => user.toFirestore(),
    );
    ref.snapshots().listen(usuariosDescargados, onError: descargaUsuariosError);
  }

  void usuariosDescargados(QuerySnapshot<FProfile> usuariosDescargados) {
    print("NUMERO DE USUARIOS ACTUALIZADOS>>>> ${usuariosDescargados.docChanges
        .length}");

    Set<Marker> marcTemp = {};

    for (int i = 0; i < usuariosDescargados.docChanges.length; i++) {
      FProfile temp = usuariosDescargados.docChanges[i].doc.data()!;
      tablaUsuarios[usuariosDescargados.docChanges[i].doc.id] = temp;

      if (_ubicacionActual != null &&
          estaEnRadio(temp.geoloc.latitude, temp.geoloc.longitude, 5)) {
        Marker marcadorTemp = Marker(
          markerId: MarkerId(usuariosDescargados.docChanges[i].doc.id),
          position: LatLng(temp.geoloc.latitude, temp.geoloc.longitude),
          infoWindow: InfoWindow(
            title: temp.nombre,
            snippet: "Fecha nacimiento: ${temp.fechaNacimiento}",
          ),
        );
        marcTemp.add(marcadorTemp);
      }
    }

    if (mounted) {
      setState(() {
        marcadores.addAll(marcTemp);
      });
    }
  }

  void descargaUsuariosError(error) {
    print("Listen failed: $error");
  }

  bool estaEnRadio(double latitud, double longitud, double radio) {
    if (_ubicacionActual == null) {
      return false;
    }

    double distancia = Geolocator.distanceBetween(
      _ubicacionActual!.latitude,
      _ubicacionActual!.longitude,
      latitud,
      longitud,
    );

    double distanciaEnKilometros = distancia / 1000;

    return distanciaEnKilometros <= radio;
  }

  void cambiarTipoMapa(MapType nuevoTipoMapa) {
    setState(() {
      _tipoMapa = nuevoTipoMapa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MAPA",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton(
            onSelected: (caso) {
              switch (caso) {
                case 'mapaNormal':
                  cambiarTipoMapa(MapType.normal);
                  break;
                case 'mapa2':
                  cambiarTipoMapa(MapType.satellite);
                  break;
                case 'mapa3':
                  cambiarTipoMapa(MapType.hybrid);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'mapaNormal',
                child: ListTile(
                  title: Text('Mapa normal'),
                ),
              ),
              const PopupMenuItem(
                value: 'mapa2',
                child: ListTile(
                  title: Text('Mapa satélite'),
                ),
              ),
              const PopupMenuItem(
                value: 'mapa3',
                child: ListTile(
                  title: Text('Mapa híbrido'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(10, 35, 65, 1.0),
        child: Center(
          child: _ubicacionActual != null
              ? GoogleMap(
            mapType: _tipoMapa,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _ubicacionActual!.latitude,
                _ubicacionActual!.longitude,
              ),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: marcadores,
          )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}