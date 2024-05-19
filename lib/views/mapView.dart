import 'package:firesigneler/controlers/mapViewController.dart';
import 'package:firesigneler/modules/Styler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:latlong2/latlong.dart';

import '../modules/Fire.dart';

class MapView extends StatelessWidget {
  final styler = Styler();
   MapView({super.key});

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
                        return  FlutterMap(
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
                                  return MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: controller.currentPosition,
                                        builder: (context) => Icon(
                                            Icons.pin_drop,
                                            color: Colors.blue),
                                      )
                                    ],
                                  );
                                }),
                            CircleLayer(
                              circles: controller.activeFiresList == null
                                  ? []
                                  : controller.activeFiresList!
                                  .map((e) => CircleMarker(
                                point: LatLng(e.optimalPositionLat,
                                    e.optimalPositionLong),
                                radius: 80,
                                color: Colors.red.withOpacity(0.6),
                                useRadiusInMeter: true,
                              ))
                                  .toList(),
                            )
                          ],
                        );

                  }),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(

                        onPressed: () {
                          controller.moveMap(controller.currentPosition);
                        },
                        icon: Icon(Icons.pin_drop_rounded)),
                  ),
                  GetBuilder<MapViewController>(
                      id: "FiresList",
                      builder: (controller) {
                        return AnimatedContainer(
                          height: MediaQuery.of(context).size.height *
                              0.9 *
                              controller.listSlider,
                          color: Colors.white,
                          duration: Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                color: styler.primaryColor,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/logo.png',
                                      height: 30,
                                    ),
                                    ElevatedButton(
                                        style: styler.editButtonStyle(),
                                        onPressed: () =>
                                            controller.listController(),
                                        child: Icon(
                                          controller.listSlider == 0.4
                                              ? Icons.arrow_drop_down_outlined
                                              : Icons.arrow_drop_up_outlined,
                                          size: 20,
                                          color: styler.primaryColor,
                                        )),
                                    Text(
                                      " Fires ",
                                      style: TextStyle(
                                        color: Styler().backgroundColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: controller.activeFiresList == null ||
                                    controller.activeFiresList!.isEmpty
                                    ? Text("No Fires",
                                    style: styler
                                        .themeData.textTheme.bodyLarge)
                                    : ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(color: Colors.grey),
                                    itemCount:
                                    controller.activeFiresList!.length,
                                    itemBuilder: (context, index) {
                                      Fire fire = controller
                                          .activeFiresList![index];
                                      return ListTile(
                                        title: Text(fire.optimalAddr,
                                            style: styler.themeData
                                                .textTheme.bodyLarge),
                                        subtitle: Text(
                                          "${fire.initialDate?.year}-${fire.initialDate?.month}-${fire.initialDate?.day}",
                                          style: styler.themeData.textTheme
                                              .bodySmall,
                                        ),
                                        onTap: () {
                                          controller.moveMap(LatLng(
                                              fire.optimalPositionLat,
                                              fire.optimalPositionLong));
                                        },

                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      }),

                ],
              ),
            ),
          );

        });
  }
}
