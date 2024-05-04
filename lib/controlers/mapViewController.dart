import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../modules/DatabaseManeger.dart';
import '../modules/Fire.dart';

class MapViewController extends GetxController {
  LatLng currentPosition =LatLng(0, 0);
  double listSlider=0.1;
  MapOptions mapOptions=MapOptions(center: LatLng(0,0) ,zoom: 4);
  MapController mapController=new MapController();
  List<Fire>? activeFiresList=null ;
  late DatabaseManeger db;


  @override
  void onInit() {
    db = new DatabaseManeger();

    super.onInit();
  }

  listController(){
    listSlider = listSlider==0.1? 0.4 :0.1;
    update(["FiresList","FiresMap"]);

  }

  Future<void> setupFireMap()async{
    await markRespondent();
    Map<String , dynamic> loc=await db.latLongToCity(currentPosition.latitude, currentPosition.longitude);
    activeFiresList=await db.getActiveLocalFires(loc["city"]);
    update(["FiresList","FiresMap"]);

    mapController.move(currentPosition, 15);

  }

  Future<void> markRespondent() async {

    if(currentPosition==LatLng(0,0)) {
      LocationPermission locationPermission = await Geolocator.checkPermission();
      print("permission : $locationPermission");
      if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever)

        await Geolocator.requestPermission();

      Position currentPossion = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      currentPosition=LatLng(currentPossion.latitude, currentPossion.longitude);
      update(["respondentPosition"]);
    }
    else mapOptions=MapOptions(initialCenter: currentPosition, initialZoom: 15);
  }
  moveMap(LatLng pos){
    mapController.move(pos, 15  );
  }


}
