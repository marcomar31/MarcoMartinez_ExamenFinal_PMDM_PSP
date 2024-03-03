
import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GeolocAdmin{

  late StreamSubscription<Position> positionStream;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    print(await Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }

  void registrarCambiosLoc(Function(Position? position) funCambioPos){
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(funCambioPos);
  }

}