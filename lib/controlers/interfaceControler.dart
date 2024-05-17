import 'dart:async';

import 'package:firesigneler/modules/DatabaseManeger.dart';
import 'package:firesigneler/views/EmergencyCalls.dart';
import 'package:firesigneler/views/cameraView.dart';
import 'package:firesigneler/views/mapView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterfaceControler extends GetxController {

  late Widget mainscreen ;
  late DatabaseManeger db;
   bool isConnected=true;


  @override
  onInit() {
    super.onInit();
    mainscreen =MapView();
    db=DatabaseManeger();
  }
  Future<void> cnx() async {
    bool t = await db.connectionStatus();

    if (isConnected != t) {
      isConnected = t;
      Get.snackbar("No Connection to the server", "You Are Limited to this page ");
      mainscreen=EmergencyCalls();
      update();
    }
    Timer.periodic(Duration(milliseconds: 400), (Timer timer) async {
      t = await db.connectionStatus();



      if (isConnected != t) {

        isConnected = t;
        if (!isConnected) {
          Get.snackbar("No Connection to the server", "You Are Limited to this page ");
          mainscreen=EmergencyCalls();
          update();
        }
      }
    });
  }
  changeScreen(String to) async{
    if(!isConnected) return ;
    if( to=="camera" && mainscreen is  CameraView)return ;
    if(to=="Calls" && mainscreen is EmergencyCalls) return;
    if( to=="map" && mainscreen is  MapView)return ;
    if( to=="test" && mainscreen is  MapView)return ;
    if(to=="map") mainscreen=new MapView();
    if(to=="Calls") mainscreen=new EmergencyCalls();
     if(to=="camera") mainscreen=new CameraView();

    update();

  }





}