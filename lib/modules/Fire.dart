import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

class Fire {
 late double longitude , latitude ;
 late String flag="proccecing";
 Uint8List? image;
 Uint8List? audiobits;




 Fire(double long,double lat,String flag  ) {
  this.latitude=lat;
  this.longitude=long;
  this.flag=flag;


 }
 void setImage(CameraImage img) async{

  image = await cameraImageToUint8List(img);
 }
 void setImage8(Uint8List img) {
  image = img;
 }

 Image getImage( ) {
 return Image.memory(image!);

 }
 void setAudio(Uint8List? audio)=>this.audiobits=audio ;


 Uint8List cameraImageToUint8List(CameraImage image) {
  // Calculate the total number of bytes
  return image.planes[0].bytes;

  }

Fire.fromMap(Map<String, Object?> map ){
 this.longitude=double.parse(map["locationLong"].toString());
 this.latitude=double.parse(map["locationLat"].toString());
 //this.flag=double.parse(map["flag"].toString());

 /*if(map["audio"]!=null){
  List<String>  a=map["audio"].toString().replaceAll('[', '').replaceAll(']', '').split(',');
  this.audiobits=Uint8List.fromList(a.map((e) => int.parse(e)).toList());
 }else this.audiobits=null;
*/
 this.audiobits=null;
List<String>  p=map["image"].toString().replaceAll('[', '').replaceAll(']', '').split(',');

this.image=Uint8List.fromList(p.map((e) => int.parse(e)).toList());
 }








}