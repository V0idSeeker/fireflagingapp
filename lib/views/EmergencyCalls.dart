import 'package:firesigneler/controlers/CallsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyCalls extends StatelessWidget {
  const EmergencyCalls({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallsController>(
        init: CallsController(),
        id: "EmergencyList",
        builder: (controller){
          return Scaffold(
            body: Center(
              child: Container(


                height: MediaQuery.of(context).size.height/2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Emergency Numbers" , style: Theme.of(context).textTheme.titleMedium),
                    ),

                    ElevatedButton(onPressed: ()async =>controller.EmergencyCall("FireFighter"), child: Text("Firefighters")),
                    ElevatedButton(onPressed: ()async =>controller.EmergencyCall("Forest Service"), child: Text("Forest Service")),
                    ElevatedButton(onPressed: ()async =>controller.EmergencyCall("Civil protection (Emergency)"), child: Text("Civil Protection")),
                    ElevatedButton(onPressed: ()async =>controller.EmergencyCall("Police"), child: Text("Police")),

                  ],
                ) ,
              )),
            floatingActionButton: ElevatedButton(
              onPressed: () {
                String val=controller.getIp();
                Get.dialog(AlertDialog(
                  title: Text("Change Ip address"),
                  content: TextFormField(
                    initialValue: val,
                    onChanged: (value){
                      val=value;

                    },
                  ),
                  actions: [
                    ElevatedButton(onPressed: ()=>Get.back(), child: Text("Cancel")),
                    ElevatedButton(onPressed: (){
                      bool changed=controller.changeIp(val);
                      if(!changed){
                        Get.snackbar("invalid Ip" ,"Ip Not Valid", snackPosition: SnackPosition.BOTTOM);
                      }else{
                        Get.back();
                        Get.snackbar("Ip Changed",'' );


                      }

                    },
                        child: Text("Submit")),
                  ],

                ));
              },
              child: Text("Change Ip"),


            ),
          );
          
        });
  }
}
