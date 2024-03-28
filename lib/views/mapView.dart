import 'package:firesigneler/controlers/mapViewControler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MapViewController(),
        builder: (controller) {

          return Scaffold(
            body: FutureBuilder(
              future: controller.setUpMap(),
              builder: (context , snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                if(snapshot.hasError) return Center(child: Text("Error"),);
                return FlutterMap(
                  mapController: controller.mapControler,
                  options: controller.initialOptions,
                  children: [
                    TileLayer(
                      urlTemplate: 'http://mt1.google.com/vt/lyrs=h&x={x}&y={y}&z={z}',
                    ),
                  //  MarkerLayer(markers: controller.markersList.toList() )
                  ]

                  ,
                );
              }
            ),
            drawer: Drawer(
              child: FutureBuilder(
                future: controller.getMarkers(),
                builder: (context , snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                  if(snapshot.hasError) return Text(snapshot.error.toString());
                  return ListView.separated(
                    separatorBuilder: (context , index)=> Divider(),
                    itemCount: controller.markersList.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        hoverColor: Colors.red,
                        title: Text(controller.markersList.elementAt(index).point.toString()),
                        onLongPress:() {controller.updateCenter(controller.markersList.elementAt(index).point) ;},
                      );
                    },);
                }
              ),
            ),
          );
        });
  }
}
