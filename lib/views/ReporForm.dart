import 'package:firesigneler/controlers/scanControler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportForm extends StatelessWidget {
  const ReportForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanControler>(
        id: "ReportForm",
        builder: (controller) {
          return Scaffold(

            body: Center(
              child: Builder(
                builder: (context) {

                  final formkey =  GlobalKey<FormState>();
                  return Form(
                    key: formkey,
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      height: MediaQuery.of(context).size.height/1.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,


                        children: [
                          Text("Report Form" , style:Theme.of(context).textTheme.headlineMedium),

                          Text("All Information  that isn't autofill-ed is optional", style: TextStyle(color: Colors.grey),),
                          TextFormField(
                            readOnly: true,
                            initialValue: controller.isPictureMode ? "Picture" : "Video",
                            decoration: InputDecoration(label: Text("Media Type :")),
                          ),
                          TextFormField(
                            readOnly: true,
                            initialValue:controller.report.reportDate.toString(),
                            decoration: InputDecoration(label: Text("Date :")),


                          ),
                          TextFormField(
                            decoration: InputDecoration(label: Text("Add Description" )
                            , hintText: "Not Required"),
                            validator: (value){
                              if( value!.isNotEmpty && !RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value.toString())) return "Invalid Discription ";
                              controller.report.setDescription(value);
                            },

                          ),
                          TextFormField(
                            decoration: InputDecoration(label: Text("Add Phone Number"),hintText: "Not Required"),
                            validator: (value){
                              if(value!.isNotEmpty &&  !RegExp(r'^\+?\d{1,3}?[0-9]{9}$').hasMatch(value.toString())) return "Invalid Phone Number";
                              controller.report.setPhoneNumber(value);
                              print("\n phobe set \n");

                            },

                          ),


                          GetBuilder<ScanControler>(
                              id: "audioRecorder",
                              builder: (controller) {

                                return Column(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (controller.isVocalRecording) {
                                            controller.stopVocalRecord();
                                          } else {
                                            controller.startVocalRecord();
                                          }
                                        },
                                        child: Text(controller.isVocalRecording? "Stop Recording " : "Record")),
                                    Text(controller.report.audioPath!=null ? "Audio Recorded" : "No Audio Recording"),

                                  ],
                                );
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(onPressed: (){
                                Get.back();
                              }, child: Text("Go Back")),
                              ElevatedButton(onPressed: ()async{
                                if(!formkey.currentState!.validate()) return null;


                                String respons=await controller.sendReport();
                                showDialog(context: context, builder: (context){
                                  return AlertDialog.adaptive(
                                    title: Text(respons),
                                    actions: [
                                      ElevatedButton(onPressed: (){
                                        Get.back() ;
                                        Get.back();
                                  }, child: Text("Return"))
                                    ],
                                  );
                                });
                              }, child: Text("Send Report")),
                            ],
                          )


                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          );
        });
  }
}
