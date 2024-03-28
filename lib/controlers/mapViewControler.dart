import 'package:firesigneler/databaseManeger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:latlong2/latlong.dart';

class MapViewController extends GetxController {
  late Set<Marker> markersList;
  late MapController mapControler;
  late MapOptions initialOptions;
  late DatabaseManeger db = DatabaseManeger();

  @override
  onInit() async {
    super.onInit();
  }

  Future<void> setUpMap() async {
    Position currentLocation = await getCurrentLocation();
    mapControler = await MapController();
    initialOptions = new MapOptions(
        initialCenter:
            (LatLng(currentLocation.latitude, currentLocation.longitude)),
        initialZoom: 100);
  }

  Future<void> getMarkers() async {
    List<Map<String, Object?>>? result = await db.getCords();
    if (result.isNull || result!.isEmpty) {
      markersList = {};
      return ;
    }
    markersList = {};
    result.forEach((element) async {


      markersList.add(Marker(
          point: LatLng(double.parse(element["locationLat"].toString()),
              double.parse(element["locationLong"].toString())),
          child: Icon(Icons.fireplace_outlined)));
    });

  }

  updateCenter(LatLng newCenter) {
    mapControler.move(newCenter, 20);
    update();
  }

  getCurrentLocation() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == "denied" || locationPermission == "deniedForever")
      ;
    await Geolocator.requestPermission();

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
