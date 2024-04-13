import 'package:firesigneler/controlers/mapViewController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapViewController>(
        init: MapViewController(),
        builder: (controller) {
          return Scaffold(

           

              body: FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
                maxZoom: 18, center: LatLng(36.7631187, 3.47637), zoom: 18),
            children: [


              TileLayer(
                urlTemplate:
                    'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
              ),
              FutureBuilder(
                future: controller.getPoints(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return CircleLayer();
                  if (snapshot.hasError) print("error");

                  return CircleLayer(circles: controller.markersList);
                },
              ),
              Builder(builder: (context){
                return Padding(padding: EdgeInsets.all(20),
                child: Container(

                    color: Colors.white,
                    child:IconButton(

                      onPressed: (){
                        Scaffold.of(context).openDrawer();
                        controller.update();
                      }, icon: Icon(Icons.list),)),)
                  ;

              })

            ],
          ),
            drawer: Drawer(
              child:FutureBuilder(
                future: controller.getFires(),
                builder: (context , snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
                  return  ListView.separated(itemBuilder: (context , index){
                    return ListTile(
                      leading: controller.fires[index].getImage(),
                      title: Text(controller.fires[index].longitude.toString()),
                      onTap: (){
                        controller.moveMap(index);
                      },
                    );
                  }, separatorBuilder: (context , index)=>Divider(), itemCount: controller.fires.length);
                },
              )
            ),
          );

        });
  }
}
