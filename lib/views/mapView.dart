import 'package:firesigneler/controlers/mapViewController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:latlong2/latlong.dart';

import '../modules/Fire.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapViewController>(
        id:"Interface",
        init: MapViewController(),
        builder: (controller) {
          controller.setupFireMap();
          return Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GetBuilder<MapViewController>(
                      id: "FiresMap",
                      builder: (controller){
                        return FlutterMap(
                          mapController: controller.mapController,
                          options: controller.mapOptions,
                          children: [
                            TileLayer(
                              urlTemplate:
                              'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
                            ),
                            GetBuilder<MapViewController>(
                                id: "respondentPosition",
                                builder: (controller) {
                                  return MarkerLayer(markers: [
                                    Marker(
                                        point: controller.currentPosition,
                                        builder: (context)=>Icon(Icons.pin_drop,color: Colors.blue,))
                                  ]);
                                }),
                            CircleLayer(
                              circles: controller.activeFiresList == null
                                  ? []
                                  : controller.activeFiresList!
                                  .map((e) => CircleMarker(
                                  point: LatLng(e.optimalPositionLat,
                                      e.optimalPositionLong),
                                  radius: 80,
                                  color:  Colors.red.withOpacity(0.6),

                                  useRadiusInMeter: true))
                                  .toList(),
                            )
                          ],
                        );

                  }),
                  GetBuilder<MapViewController>(
                      id: "FiresList",
                      builder: (controller) {
                        return AnimatedContainer(
                          height: MediaQuery.of(context).size.height*0.9*controller.listSlider,
                          color: Colors.white,

                          duration: Duration(milliseconds: 300),
                          child: Column(children: [
                            Center(child: ElevatedButton(onPressed: ()=>controller.listController(),child: Text("Fires"))),
                            Expanded(

                              child: controller.activeFiresList== null ||
                                  controller.activeFiresList!.isEmpty
                                  ? Text("No Fires")
                                  : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Divider(color: Colors.grey,),
                                  itemCount:
                                  controller.activeFiresList!.length,
                                  itemBuilder: (context, index) {
                                    Fire rep =
                                    controller.activeFiresList![index];
                                    return ListTile(
                                      title: Text(rep.optimalAddr),
                                      subtitle: Text(
                                        "${rep.initialDate?.year}-${rep.initialDate?.month}-${rep.initialDate?.day} "
                                          ),
                                      onTap: () {
                                        controller.moveMap(LatLng(
                                            rep.optimalPositionLat,
                                            rep.optimalPositionLong));
                                      },


                                    );
                                  }),
                            ),

                          ]),
                        );
                      }),

                ],
              ),
            ),
          );

        });
  }
}
