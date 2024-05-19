import 'package:firesigneler/controlers/scanControler.dart';
import 'package:firesigneler/modules/Styler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportForm extends StatelessWidget {
  ReportForm({super.key});
  final Styler styler = Styler();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanControler>(
        id: "ReportForm",
        builder: (controller) {
          return Scaffold(

            body: Container(
              decoration: styler.orangeBlueBackground(),
              child: Center(
                child: Builder(builder: (context) {
                  final formkey = GlobalKey<FormState>();
                  return Form(
                    key: formkey,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 1.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Report Form",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: styler.primaryColor),
                            ),
                          ),
                          Center(
                            child: Text(
                              "All information that isn't autofilled is optional",
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            initialValue:
                            controller.isPictureMode ? "Picture" : "Video",
                            decoration: InputDecoration(
                              labelText: "Media Type",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            initialValue: controller.report.reportDate.toString(),
                            decoration: InputDecoration(
                              labelText: "Date",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Add Description",
                              hintText: "Not Required",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty &&
                                  !RegExp(r'^[a-zA-Z0-9 ]+$')
                                      .hasMatch(value.toString())) {
                                return "Invalid Description";
                              }
                              controller.report.setDescription(value);
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Add Phone Number",
                              hintText: "Not Required",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty &&
                                  !RegExp(r'^\+?\d{1,3}?[0-9]{9}$')
                                      .hasMatch(value.toString())) {
                                return "Invalid Phone Number";
                              }
                              controller.report.setPhoneNumber(value);
                              print("\n phone set \n");
                            },
                          ),
                          GetBuilder<ScanControler>(
                              id: "audioRecorder",
                              builder: (controller) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (controller.isVocalRecording) {
                                          controller.stopVocalRecord();
                                        } else {
                                          controller.startVocalRecord();
                                        }
                                      },
                                      child: Text(
                                          controller.isVocalRecording
                                              ? "Stop Recording"
                                              : "Record",
                                          style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        primary: styler.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      controller.report.audioPath != null
                                          ? "Audio Recorded"
                                          : "No Audio Recording",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                );
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("Go Back"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (!formkey.currentState!.validate()) return;

                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return PopScope(
                                          canPop: false,
                                          child: FutureBuilder(
                                              future: controller.sendReport(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting)
                                                  return styler.returnDialog(
                                                      title: "Sending Report",
                                                      content: LinearProgressIndicator(),
                                                      actions: []
                                                  );
                                                if (snapshot.hasError)
                                                  return styler.returnDialog(
                                                    title: "Error",
                                                    content: Text(
                                                        "Report did not get sent "),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("Close"),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                return styler.returnDialog(
                                                  title: snapshot.data!,
                                                  content: Container(),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Get.back();
                                                      },
                                                      child: Text("Return"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: styler
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        );
                                      });
                                },
                                child: Text("Send Report"),
                                style: ElevatedButton.styleFrom(
                                  primary: styler.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        });
  }
}
