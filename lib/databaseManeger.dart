import 'dart:convert';
import 'package:firesigneler/modules/Fire.dart';
import 'package:http/http.dart';

class DatabaseManeger {
  late Uri url;

  DatabaseManeger() {
    url = Uri.http("192.168.1.111","api/index.php");
  }
  Future<List<Fire>> getFires() async {
    var response = await post(url, body: {
      "command":"getAllFires"
    });

    List<dynamic> decodedResponse = jsonDecode(response.body);

    List<Fire> listOfFires = decodedResponse.map((item) {
      return Fire.fromMap(item);
    }).toList();

    return listOfFires;

  }

  Future<void> addFire(Fire fire)async {
    Map<String ,dynamic> data=fire.toMap();
    data["command"]="addFire";
    var response = await post(url, body: data);
    print("data \n${response.body}");


  }






}