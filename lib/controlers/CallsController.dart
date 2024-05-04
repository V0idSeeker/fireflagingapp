import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CallsController extends GetxController{


  EmergencyCall(String type)async{
    switch (type) {
      case "FireFighter":
        await _call(14.toString());
        break;
      case "Gendarme":
        await _call(112.toString());
        break;
      case "Police":
        await _call(17.toString());
        break;
      case "Forest Service":
        await _call(1070.toString());
        break;
      case "Civil protection (Emergency)":
        await _call(1021.toString());
        break;
    }
  }


  Future<void> _call(String number) async {
    var url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

/*
https://www.okbob.net/article-27754149.html
 */