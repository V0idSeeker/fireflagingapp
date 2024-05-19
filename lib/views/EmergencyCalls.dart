import 'package:firesigneler/controlers/CallsController.dart';
import 'package:firesigneler/modules/Styler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyCalls extends StatelessWidget {
   EmergencyCalls({super.key});
  final styler = Styler();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallsController>(
      init: CallsController(),
      id: "EmergencyList",
      builder: (controller) {
        return Scaffold(
          
          body: Container(
            decoration: styler.orangeBlueBackground(),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                  color: styler.themeData.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png",height: 200,),
                    Text(
                      "Emergency Numbers",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    ElevatedButton(
                      onPressed: () async => controller.EmergencyCall("FireFighter"),
                      child: Text("Firefighters"),
                      style: styler.elevatedButtonStyle(),
                    ),
                    ElevatedButton(
                      onPressed: () async => controller.EmergencyCall("Forest Service"),
                      child: Text("Forest Service"),
                      style: styler.elevatedButtonStyle(),
                    ),
                    ElevatedButton(
                      onPressed: () async => controller.EmergencyCall("Civil protection (Emergency)"),
                      child: Text("Civil Protection"),
                      style: styler.elevatedButtonStyle(),
                    ),
                    ElevatedButton(
                      onPressed: () async => controller.EmergencyCall("Police"),
                      child: Text("Police"),
                      style: styler.elevatedButtonStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: ElevatedButton(
            style: styler.dialogButtonStyle(),

            onPressed: () {
              String val=controller.getIp();
              styler.showDialogUnRemoved(title:"Change Ip address",
                  content:TextFormField(
                    decoration:styler.inputFormTextFieldDecoration("Ip address"),
                    style: TextStyle(color: Get.theme.textTheme.bodyText1?.color),
                    initialValue: val,
                    onChanged: (value){
                      val=value;
                    },
                  ),
                  actions :[
                    ElevatedButton(
                        style: styler.dialogButtonStyle(),
                        onPressed: ()=>Get.back(),
                        child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: (){
                          bool changed=controller.changeIp(val);
                          if(!changed){
                            styler.showSnackBar("invalid Ip" ,"Ip Not Valid");
                          }else{
                            Get.back();
                            styler.showSnackBar("Ip Changed",'');


                          }

                        },
                        style: styler.dialogButtonStyle(),
                        child: Text("Submit")),
                  ]
              );

            },
            child: Text("Change Ip"),


          ),
        );
      },
    );

  }
}
