import 'package:camera/camera.dart';
import 'package:firesigneler/controlers/scanControler.dart';
import 'package:firesigneler/views/ReporForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanControler>(
        init: ScanControler(),
        builder: (controller) {
          if (!controller.isCameraInitialised)
            return Center(child: CircularProgressIndicator());
          return Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,

              children: [
                Positioned(
                  top: 0,
                  child: GetBuilder<ScanControler>(
                      id: "CameraPreview",
                      builder: (controller) {
                        return Stack(children: [
                          Container(
                            height:MediaQuery.of(context).size.height*10/12,
                            child: AspectRatio(

                              aspectRatio: 9 / 16,
                              child: CameraPreview(
                                controller.cameraController,
                              ),
                            ),
                          ),
                          Positioned(
                            top: controller.y,
                            left: controller.x,
                            child: Container(
                              width: controller.w,
                              height: controller.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.red, width: 3)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      color: Colors.transparent,
                                      child: Text(
                                        controller.label,
                                        style: TextStyle(fontSize: 22),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ]);
                      }),
                ),
                Positioned(
                  bottom: 0,
                  child: GetBuilder<ScanControler>(
                      id: "CameraControls",
                      builder: (controller) {
                        return Container(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 11,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //flash
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          controller.flashController();
                                        },
                                        icon: Icon(
                                          controller.flashOn
                                              ? Icons.flash_on
                                              : Icons.flash_off,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                    Text(
                                      "flash",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),

                                // report button
                                controller.detect || controller.isVideoRecording
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          //Get.to(() => ReportForm());
                                          if (controller.isPictureMode) {
                                            controller.takePicture();
                                            Get.to(()=>ReportForm());
                                          }
                                          if(!controller.isPictureMode && !controller.isVideoRecording)
                                            controller.startVideoRecord();
                                          if(!controller.isPictureMode && controller.isVideoRecording) {
                                           await  controller.stopVideoRecord();
                                            Get.to(()=>ReportForm());
                                          }
                                        },
                                        child: Text(controller.isPictureMode ?
                                        "Take a Picure":
                                        !controller.isVideoRecording ? "Start Recording":
                                            "End Recording"
                                        ))
                                    : Text(""),
                                //camera mode
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(

                                      onPressed: () {
                                        if(!controller.isVideoRecording)
                                        controller.modeController();
                                      },
                                      icon: Icon(
                                        controller.isPictureMode
                                            ? Icons.camera_enhance_rounded
                                            : Icons.emergency_recording_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      controller.isPictureMode
                                          ? "Picture Mode"
                                          : "  Video Mode",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ));
                      }),
                )
              ],
            ),
          );
        });
  }
}
