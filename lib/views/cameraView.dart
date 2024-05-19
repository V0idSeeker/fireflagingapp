import 'package:camera/camera.dart';
import 'package:firesigneler/controlers/scanControler.dart';
import 'package:firesigneler/modules/Styler.dart';
import 'package:firesigneler/views/ReporForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CameraView extends StatelessWidget {
   CameraView({super.key});
  final Styler styler = Styler();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanControler>(
        init: ScanControler(),
        builder: (controller) {
          if (!controller.isCameraInitialised)
            return Center(child: CircularProgressIndicator());
          return Scaffold(
            body: Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: GetBuilder<ScanControler>(
                      id: "CameraPreview",
                      builder: (controller) {
                        return GestureDetector(
                          onScaleUpdate: (details) {
                            controller.setZoomLevel(details.scale);
                          },
                          onTapDown: (details) {
                            final RenderBox renderBox = context.findRenderObject() as RenderBox;
                            final Offset localOffset = renderBox.globalToLocal(details.globalPosition);
                            controller.focusOnPoint(localOffset, renderBox.constraints);
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 10 / 12,
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: CameraPreview(controller.cameraController!),
                                ),
                              ),

                              GetBuilder<ScanControler>(
                                  id:"CameraBorder",
                                  builder: (controller) {
                                    if(!controller.detect)
                                      return Container();
                                    return Container(

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 3,
                                          ),
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.red.withOpacity(0.6),
                                              Colors.transparent,
                                            ],
                                            stops: [0.0, 1.0],
                                            center: Alignment.center,
                                            radius: 0.5,
                                          ),
                                        ),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * 10 / 12,
                                          child: AspectRatio(
                                            aspectRatio: 9/16,
                                          ),
                                        )
                                    );
                                  }
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
                                // Flash control
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.flashController();
                                      },
                                      icon: Icon(
                                        controller.flashOn ? Icons.flash_on : Icons.flash_off,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      "Flash",
                                      style: styler.themeData.textTheme.bodySmall!.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                                // Report button
                                controller.detect || controller.isVideoRecording
                                    ? ElevatedButton(
                                  onPressed: () async {
                                    if (controller.isPictureMode) {
                                      controller.takePicture();
                                      Get.to(() => ReportForm());
                                    } else if (!controller.isPictureMode && !controller.isVideoRecording) {
                                      controller.startVideoRecord();
                                    } else if (!controller.isPictureMode && controller.isVideoRecording) {
                                      await controller.stopVideoRecord();
                                      Get.to(() => ReportForm());
                                    }
                                  },
                                  child: Text(
                                    controller.isPictureMode ? "Take a Picture" : !controller.isVideoRecording ? "Start Recording" : "End Recording",
                                    style: styler.themeData.textTheme.bodyLarge,
                                  ),
                                  style: styler.elevatedButtonStyle(),
                                )
                                    : Text(""),
                                // Camera mode control
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (!controller.isVideoRecording) controller.modeController();
                                      },
                                      icon: Icon(
                                        controller.isPictureMode ? Icons.camera_enhance_rounded : Icons.videocam_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      controller.isPictureMode ? "Picture Mode" : "Video Mode",
                                      style: styler.themeData.textTheme.bodySmall!.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
