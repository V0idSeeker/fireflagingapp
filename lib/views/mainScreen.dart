import 'package:firesigneler/controlers/interfaceControler.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class MainScrean extends StatelessWidget {
  const MainScrean({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InterfaceControler>(
      init: InterfaceControler(),
      builder: (controller) {
        controller.cnx();
        return Scaffold(
            body: controller.mainscreen,
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                switch (index) {
                  case 0:
                    {
                      controller.changeScreen("map");

                      break;
                    }

                  case 1:
                    {
                      controller.changeScreen("camera");

                      break;
                    }
                  case 2:
                    {
                      controller.changeScreen("Calls");
                      break;
                    }

                }
                ;
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.map), label: "Fire Map"),
                BottomNavigationBarItem(


                    icon: Icon(Icons.camera), label: "Camera"),


                BottomNavigationBarItem(
                    icon: Icon(Icons.call), label: "Emergency Numbers"),
              ],
            ));
      },
    );
  }
}
