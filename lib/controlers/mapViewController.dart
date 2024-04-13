import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import '../databaseManeger.dart';
import '../modules/Fire.dart';

class MapViewController extends GetxController {
  MapController mapController = MapController();
  late MapOptions mapOptions;
  List<CircleMarker> markersList = [];
  List<Fire> fires = [];

  late DatabaseManeger db;
  @override
  onInit() async {
    db = DatabaseManeger();
    await setupMap();
    await getPoints();
    super.onInit();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<void> setupMap() async {
    Position currentLocation = await getCurrentLocation();
    mapOptions =
        MapOptions(maxZoom: 18, center: LatLng(36.7631187, 3.47637), zoom: 8);
  }

  Future<void> getFires() async {
    if (fires.isNotEmpty) return;
    fires = await db.getFires();
  }

  Future<void> getPoints() async {
    fires = await db.getFires();
    if (fires.length == markersList.length) return;
    fires.forEach((element) {
      markersList.add(new CircleMarker(
          point: LatLng(element.latitude, element.longitude),
          radius: 40,
        color: Colors.redAccent.shade400.withOpacity(0.4)
      ));
    });
  }

  Future<void> moveMap(int index) async {
    mapController.move(markersList[index].point, 15);

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
