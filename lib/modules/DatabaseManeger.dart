
import 'dart:convert';

import 'package:http/http.dart';


import 'Fire.dart';
import 'Report.dart';
class DatabaseManeger {
  late Uri url;
  String authgeo="741499549589927466382x105731";

  DatabaseManeger() {
    //for local
    url = Uri.http("192.168.1.111", "api/index.php");
    //for partage
    url=Uri.http("192.168.214.111", "api/index.php");
  }

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
      print(response.body);
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
    

  return true;
}


//geolocator api section
latLongToCity(double lat , double long)async{
  Uri geo = Uri.http("geocode.xyz","${lat},$long",{
    "geoit":"json",
    "auth":authgeo
  });
  var response = await get(geo);
  dynamic decodedResponse = jsonDecode(response.body);
  return {
    "city":decodedResponse["city"],
    "addr":decodedResponse["staddress"]
    };



}




}
