import 'package:firesigneler/views/EmergencyCalls.dart';
import 'package:firesigneler/views/cameraView.dart';
import 'package:firesigneler/views/mapView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterfaceControler extends GetxController {

  late Widget mainscreen ;


  @override
  onInit() {
    super.onInit();
    mainscreen =MapView();
  }

  changeScreen(String to) async{
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