
import 'dart:convert';

import 'package:http/http.dart';


import 'Fire.dart';
import 'Report.dart';
class DatabaseManeger {
 static late  Uri url;
  static String ip="192.168.1.111";

  DatabaseManeger() {
    //for local

    url = Uri.http(ip, "api/index.php");


  }
  Future<bool> connectionStatus()async{

    bool f;

    try {
      print("dcfsdfsdf $url");
      var response =await  post(url , body: {
        "command": "connectionStatus",
      }).timeout(Duration(milliseconds: 500));
      print(response.statusCode);
      if (response.statusCode == 200) f= true;
      else f=false;
    }catch(e){
      f=false;
    }

    return f;


  }
  void setIp(String newIp) {
    print("old ip is : $url");
    ip=newIp;
    url = Uri.http(ip,"api/index.php");
    print("new ip is : $url");

  }

  String getIp()=>ip;



  //fire section

  Future<List<Fire>> getActiveLocalFires(String  city) async {

    var response=await post(url,body: {
      "command": "getActiveLocalFires",
      "city": city
    });
    List<dynamic> decodedResponse = jsonDecode(response.body);
    List<Fire> listOfActiveFires = decodedResponse.map((item) {
      return Fire.fromMap(item);
    }).toList();
    return listOfActiveFires;
  }



  //reports section

Future<bool> sendReport(Report report)async{


  var request = MultipartRequest(
    'POST',url
  );
  //attaching data to the request
  report.toMap().forEach((key, value) async {
    request.fields["command"] = "addReport";
    //if its a file
    if (key == "resourcePath" || key == "audioPath"){
      if (value != null)
        request.files.add(
          await MultipartFile.fromPath(
            key,
            value,
          ),
        );
  }
    //if its normal data

    else request.fields[key]=value.toString();

  });
  // Add the image file to the request


  try {
    // Send the request
    var streamedResponse = await request.send();

    // Get the response
    var response = await Response.fromStream(streamedResponse);

    // Check if the upload was successful
    if (response.statusCode == 200) {
      print('Image uploaded successfully');

    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
    

  return true;
}


//geolocator api section
 latLongToCity(double lat, double long) async {

      var response = await post(url, body: {
        "lat": lat.toString(),
        "long": long.toString(),
        "command": "latLongToCity"
      });

      return jsonDecode(response.body);



  }




}
