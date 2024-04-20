import 'package:camera/camera.dart';
import 'package:firesigneler/controlers/scanControler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanControler>(
        init: ScanControler(),
        builder: (controler) {
          if (!controler.isCameraInitialised.value)
            return Center(child: CircularProgressIndicator());

          return Column(
            children: [
              Stack(alignment: Alignment.center, children: [
                CameraPreview(
                  controler.cameraController,
                ),
                Positioned(
                  top: controler.y,
                  left: controler.x,
                  child: Container(
                    width: controler.w,
                    height: controler.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red, width: 3)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            color: Colors.transparent,
                            child: Text(
                              controler.label,
                              style: TextStyle(fontSize: 22),
                            ))
                      ],
                    ),
                  ),
                )
              ]),
              Center(
                child: Builder(
                  builder: (context) {
                    Widget recordingStatus;
                    if (!controler.detect) return Container();
                    recordingStatus = controler.isRecording.isTrue
                        ? Text("Stop recording")
                        : Text("Record");

                    return Container(
                      child: Column(
                        children: [
                          MaterialButton(
                              onPressed: () {
                                if (controler.isRecording.isTrue) {
                                  controler.stopRecord();
                                } else {
                                  controler.startRecord();
                                }
                              },
                              child: recordingStatus),
                          ElevatedButton(
                            child: Center(child: Text('Flag Fire')),
                            onPressed: () async {
                              if (controler.isRecording.isFalse) {
                                var f=await controler.getImage();
                                await controler.signalFire();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        title: Center(
                                            child:
                                                Text("Fire Have Been Flagged")),
                                        content:
                                          Image.memory(f)
                                        //Text("thank you for your help"),
                                      );
                                    });
                              }
                            },
                          ),
                        ],
                      ),
                    );

                  },
                ),
              )
            ],
          );
        });
  }
}
