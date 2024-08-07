import 'dart:async';

import 'package:firesigneler/modules/DatabaseManeger.dart';
import 'package:firesigneler/modules/Styler.dart';
import 'package:firesigneler/views/EmergencyCalls.dart';
import 'package:firesigneler/views/cameraView.dart';
import 'package:firesigneler/views/mapView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterfaceControler extends GetxController {

  late Widget mainscreen ;
  late DatabaseManeger db;
   bool isConnected=true;
   Styler styler=Styler();
   int index=1;


  @override
  onInit() {
    super.onInit();
    mainscreen =MapView();
    db=DatabaseManeger();
  }
  Future<void> cnx() async {
    bool t = await db.connectionStatus();




    Timer.periodic(Duration(milliseconds: 400), (Timer timer) async {
      t = await db.connectionStatus();

      if (isConnected != t) {
        isConnected = t;
        if (!isConnected) {
          styler.showSnackBar("No Connection to the server", "You Are Limited to this page ");
          mainscreen=EmergencyCalls();

        }
        update(["Screen"]);
      }
    });
  }
  changeScreen(String to) async{
    if(!isConnected) {
      styler.showSnackBar("No Connection", "Try again late");
      return;
    }
    if( to=="camera" && mainscreen is  CameraView)return ;
    if(to=="Calls" && mainscreen is EmergencyCalls) return;
    if( to=="map" && mainscreen is  MapView)return ;
    if( to=="test" && mainscreen is  MapView)return ;
    if(to=="map") {
      index=0;
      mainscreen = new MapView();
    }
    if(to=="camera") {
      index=1;
      mainscreen = new CameraView();
    }
    if(to=="Calls") {
      index=2;
      mainscreen = new EmergencyCalls();
    }

    update(["Screen"]);

  }





}