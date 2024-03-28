import 'package:firesigneler/views/cameraView.dart';
import 'package:firesigneler/views/mapView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterfaceControler extends GetxController {

  late Widget mainscreen ;


  @override
  onInit() {
    super.onInit();
    mainscreen =CameraView();
  }

  changeScreen(String to) async{
    if( to=="camera" && mainscreen is  CameraView)return ;
    if( to=="maps" && mainscreen is  MapView)return ;
    if(to=="camera") mainscreen=CameraView();
    else mainscreen=MapView();
    update();

  }





}