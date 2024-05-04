import 'dart:io';

class Report {

  //attributes
late int reportId  ;
int? fireId;
String reportStatus="onReview";
late String city,addr,resourceType,resourcePath;
String? audioPath , description , phoneNumber;
late double positionLat , positionLong;
late DateTime reportDate;

Report(){
  reportId=0;
  this.city="";
  this.addr="";
  this.resourceType="";
  this.resourcePath="";
  this.positionLat=0;
  this.positionLong=0;
  this.reportDate=DateTime.now();
}

setCity(String city )=>this.city=city.replaceAll("\"", "").replaceAll("'", "");
setAddr(String addr )=>this.addr=addr.replaceAll("\"", "").replaceAll("'", "");
setResourceType(String resourceType )=>this.resourceType=resourceType;
setResourcePath(String resourcePath )=>this.resourcePath=resourcePath;
setAudioPath(String? audioPath )=>this.audioPath=audioPath;
setDescription(String? description )=>this.description= description==null ? description : description.replaceAll(RegExp(r'^(?![a-zA-Z0-9_\s]+$).*'), "");
setPhoneNumber(String? phoneNumber )=>this.phoneNumber=phoneNumber;
setPositionLat(double positionLat )=>this.positionLat=positionLat;
setPositionLong(double positionLong )=>this.positionLong=positionLong;
setReportDate(DateTime reportDate )=>this.reportDate=reportDate;


deleteFiles()async{
  File(resourcePath).delete();
  if(audioPath!=null && audioPath!.isNotEmpty)
    File(audioPath!).delete();

}

Map<String , dynamic> toMap(){
  return {
  "reportId" : reportId, "fireId" : fireId, "reportStatus" : reportStatus, "reportDate" : reportDate,
    "positionLat" : positionLat, "positionLong" : positionLong,
  "city" : city, "addr" : addr,
  "resourceType" : resourceType, "resourcePath" : resourcePath, "audioPath" : audioPath,
  "description" : description ,"phoneNumber" :phoneNumber
};

}

Report.fromMap(Map<String , dynamic>map){
  reportId=int.parse(map['reportId']);
  fireId=int.tryParse(map['fireId'].toString());
  reportStatus=map['reportStatus'];
  city=map['city'];
  addr=map['addr'];
  resourceType=map['resourceType'];
  resourcePath=map['resourcePath'];
  audioPath=map['audioPath'];
  description=map['description'];
  phoneNumber=map["phoneNumber"];
  positionLat=double.parse(map['positionLat']);
  positionLong=double.parse(map['positionLong']);
  reportDate=DateTime.parse(map['reportDate']);
}

@override
  String toString() {
    return """ Report: {
    reportId : $reportId, fireId : $fireId, reportStatus : $reportStatus, reportDate : $reportDate,
    , positionLat : $positionLat, positionLong : $positionLong, 
    city : $city, addr : $addr, 
    resourceType : $resourceType, resourcePath : $resourcePath, audioPath : $audioPath,
     description : $description ,phoneNumber :$phoneNumber
    }""";
  }



}