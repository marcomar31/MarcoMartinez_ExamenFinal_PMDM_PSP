import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FProfile.dart';
import 'package:marcomartinez_examenfinal/Singleton/FirebaseAdmin.dart';

class MapaView extends StatefulWidget {
  const MapaView({super.key});

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
  final Map<String, FProfile> tablaPerfiles = {};

  @override
  void initState() {
    obtenerUbicacionActual();
    suscribirADescargaUsuarioActual();
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

  void suscribirADescargaUsuarioActual() async {
    String userId = fbAdmin.auth.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      DocumentReference<FProfile> userRef = fbAdmin.db.collection("Perfiles").doc(userId)
          .withConverter(fromFirestore: FProfile.fromFirestore, toFirestore: (FProfile user, _) => user.toFirestore());

      userRef.snapshots().listen((DocumentSnapshot<FProfile> snapshot) {
        if (snapshot.exists) {
          FProfile user = snapshot.data()!;
          actualizarMarcadorUsuario(user);
        }
      }, onError: (error) {
        print("Error al descargar el perfil del usuario actual: $error");
      });
    }

    CollectionReference<FActividad> actividadesRef = fbAdmin.db.collection("Actividades")
        .withConverter(fromFirestore: FActividad.fromFirestore, toFirestore: (FActividad actividad, _) => actividad.toFirestore());

    actividadesRef.snapshots().listen((QuerySnapshot<FActividad> snapshot) async {
      List<Marker> nuevosMarcadores = [];
      for (var doc in snapshot.docs) {
        FActividad actividad = doc.data();
        if (actividad.geoloc != null) {
          Marker marker = Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(actividad.geoloc!.latitude, actividad.geoloc!.longitude),
            infoWindow: InfoWindow(
              title: actividad.nombre,
              snippet: "${actividad.precio} €",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          );
          nuevosMarcadores.add(marker);
        }
      }

      setState(() {
        marcadores.clear();
        marcadores.addAll(nuevosMarcadores);
        print("Marcadores de actividades agregados: $nuevosMarcadores");
      });
    }, onError: (error) {
      print("Error al descargar las actividades: $error");
    });
  }

  void actualizarMarcadorUsuario(FProfile user) {
    String? userId = fbAdmin.auth.currentUser?.uid;
    if (userId != null && mounted) {
      Marker marker = Marker(
        markerId: MarkerId(userId),
        position: LatLng(user.geoloc.latitude, user.geoloc.longitude),
        infoWindow: InfoWindow(
          title: fbAdmin.auth.currentUser?.displayName ?? "NOMBRE DE USUARIO",
          snippet: fbAdmin.auth.currentUser?.email ?? fbAdmin.auth.currentUser?.phoneNumber,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      setState(() {
        marcadores.add(marker);
        print("Marcador de usuario agregado: $marker");
      });
    } else {
      print("Error: No se pudo obtener el ID de usuario o el widget no está montado");
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
