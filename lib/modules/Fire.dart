import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';


class Fire {
 late double longitude , latitude ;
 late String flag="proccecing";
 late DateTime flagDate;
 Uint8List? image;
 Uint8List? audiobits;




 Fire(double long,double lat,String flag ,DateTime fireDate ) {
  this.latitude=lat;
  this.longitude=long;
  this.flag=flag;
  this.flagDate=fireDate;


 }

 void setImage(Uint8List img) {
  image = img;
 }

 Image getImage( ) {
  return Image.memory(image!);

 }
 void setAudio(Uint8List? audio)=>this.audiobits=audio ;




 Fire.fromMap(Map<String, dynamic> map ){
  this.longitude=double.parse(map["locationLong"].toString());
  this.latitude=double.parse(map["locationLat"].toString());
  this.flag=map["flag"].toString();
  this.flagDate=DateTime.parse(map["flagDate"].toString());

   this.image = base64Decode(map["image"]);



  this.audiobits=null;

 }

 Map<String , dynamic>toMap(){
  return {
   "locationLat":latitude.toString(),
   "locationLong":longitude.toString(),
   "image":image.toString(),
   "flag":flag,
   "flagDate":flagDate.toString(),

  };
 }






 @override
 String toString() {

  return """
    [ Longtitude :$longitude , Latitude :$latitude ,  flag :$flag ,
    date $flagDate,
    
    ]
    """;
 }

}