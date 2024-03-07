
import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/FirestoreObjects/FActividad.dart';
import 'package:marcomartinez_examenfinal/Singleton/DataHolder.dart';
import 'package:marcomartinez_examenfinal/Singleton/PlatformAdmin.dart';

class ActividadView extends StatefulWidget {
  const ActividadView({super.key});

  @override
  _ActividadViewState createState() => _ActividadViewState();
}

class _ActividadViewState extends State<ActividadView> {
  FActividad? actividad = DataHolder().selectedActivity;
  bool _actividadEditada = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          actividad?.nombre ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (actividad?.imagenUrl != "")
                Container(
                  width: PlatformAdmin.isWebPlatform() ? 600 : PlatformAdmin.getScreenWidth(context)-40,
                  height: PlatformAdmin.isWebPlatform() ? 600 : PlatformAdmin.getScreenWidth(context)-40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    image: actividad!.imagenUrl.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(actividad!.imagenUrl),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: actividad!.imagenUrl.isEmpty
                      ? Icon(Icons.image, size: PlatformAdmin.isWebPlatform() ? 600 : PlatformAdmin.getScreenWidth(context)-40/2, color: Colors.white)
                      : null,
                ),
                if (actividad?.imagenUrl != "")
                const SizedBox(height: 30,),
                const Text(
                  'Descripción:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  actividad?.descripcion ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fecha:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${actividad?.fecha.day.toString().padLeft(2, '0')}/${actividad?.fecha.month.toString().padLeft(2, '0')}/${actividad?.fecha.year.toString()}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Precio:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${actividad?.precio.toString() ?? ""} €",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                if (actividad?.geoloc != null)
                const SizedBox(height: 20),
                if (actividad?.geoloc != null)
                  const Text(
                  'Ubicación:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (actividad?.geoloc != null)
                  Text(
                  "${actividad?.geoloc?.longitude ?? ""}, ${actividad?.geoloc?.latitude ?? ""}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/editaactividad_view").then((result) {
                      if (result != null && result is bool) {
                        setState(() {
                          _actividadEditada = result;
                        });
                      }
                      Navigator.of(context).pop(_actividadEditada);
                    });
                  },
                  child: const Icon(Icons.edit_rounded),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
