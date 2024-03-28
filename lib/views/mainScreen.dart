import 'package:firesigneler/controlers/interfaceControler.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class MainScrean extends StatelessWidget {
  const MainScrean({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<InterfaceControler>(
      init: InterfaceControler(),
      builder: (controler) {
        return Scaffold(
            body: controler.mainscreen,
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index){
                if(index==0) controler.changeScreen("camera");
                else controler.changeScreen("maps");
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.camera), label: "Camera"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.map), label: "Fire Map"),
              ],
            ));
      },
    );
  }
}
