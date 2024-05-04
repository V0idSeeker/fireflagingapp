


class Fire {
  late int fireId;
  late String city ,optimalAddr,fireStatus="active";
  late double optimalPositionLong , optimalPositionLat;
  DateTime? initialDate=DateTime.now() ,finalDate;



  Fire.fromMap(Map<String,dynamic> map){

    fireId=int.tryParse(map["fireId"].toString())!;

    city=map["city"];

    fireStatus=map["fireStatus"];

    initialDate=DateTime.parse(map["initialDate"].toString());

    finalDate=DateTime.tryParse(map["finalDate"].toString());

    optimalPositionLong=double.parse(map["optimalPositionLong"].toString());

    optimalPositionLat=double.parse(map["optimalPositionLat"].toString());

    optimalAddr=map["optimalAddr"];

  }
  Map<String,dynamic> toMap(){
    return {
      "fireId" : fireId.toString(),
      "city" : city,
      "fireStatus" : fireStatus,
      "optimalPositionLong" : optimalPositionLong.toString(),
      "optimalPositionLat" : optimalPositionLat.toString(),
      "optimalAddr" : optimalAddr,
      "initialDate" : initialDate.toString(),
      "finalDate" : finalDate.toString(),
    };

  }



  @override
  String toString() {

    return """ Fire :{
    fireId: $fireId,city: $city,
    fireStatus: $fireStatus,
    optimalPositionLong: $optimalPositionLong,
    optimalPositionLat: $optimalPositionLat,
    optimalAddr: $optimalAddr,
    initialDate: $initialDate, finalDate: $finalDate,
    }""";
  }

}