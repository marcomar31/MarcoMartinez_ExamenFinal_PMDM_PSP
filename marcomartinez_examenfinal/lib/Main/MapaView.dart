import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FProfile.dart';
import 'package:marcomartinez_examenfinal/Singleton/FirebaseAdmin.dart';

class MapaView extends StatefulWidget {
  const MapaView({Key? key}) : super(key: key);

  @override
  State<MapaView> createState() => MapaViewState();
}

class MapaViewState extends State<MapaView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  Position? _ubicacionActual;
  late GoogleMapController _controller;
  Set<Marker> marcadores = {};
  late CameraPosition _kUser;
  MapType _tipoMapa = MapType.normal;
  final Map<String, FProfile> tablaPerfiles = Map();

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

  void suscribirADescargaUsuarios() async{
    CollectionReference<FProfile> ref = fbAdmin.db.collection("Perfiles")
        .withConverter(fromFirestore: FProfile
        .fromFirestore,
      toFirestore: (FProfile user, _) => user.toFirestore(),);
    ref.snapshots().listen(usuariosDescargados, onError: descargaUsuariosError,);
  }

  void usuariosDescargados(QuerySnapshot<FProfile> perfilesDescargados) {
    print("NUMERO DE USUARIOS ACTUALIZADOS>>>> " +
        perfilesDescargados.docChanges.length.toString());

    Set<Marker> marcTemp = Set();

    for (int i = 0; i < perfilesDescargados.docChanges.length; i++) {
      FProfile temp = perfilesDescargados.docChanges[i].doc.data()!;
      tablaPerfiles[perfilesDescargados.docChanges[i].doc.id] = temp;

      Marker marcadorTemp = Marker(
        markerId: MarkerId(perfilesDescargados.docChanges[i].doc.id),
        position: LatLng(temp.geoloc.latitude, temp.geoloc.longitude),
        infoWindow: InfoWindow(
          title: fbAdmin.auth.currentUser?.displayName,
          snippet: fbAdmin.auth.currentUser?.email ?? fbAdmin.auth.currentUser?.phoneNumber,
        ),
      );
      marcTemp.add(marcadorTemp);
    }

    // Verificar si el widget está montado antes de llamar a setState
    if (mounted) {
      setState(() {
        marcadores.addAll(marcTemp);
      });
    }
  }

  void descargaUsuariosError(error){
    print("Listen failed: $error");
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
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
            initialCameraPosition: _kUser,
            onMapCreated: _onMapCreated,
            markers: marcadores,
          )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
