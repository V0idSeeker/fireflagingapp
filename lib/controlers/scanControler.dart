import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firesigneler/databaseManeger.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../modules/Fire.dart';

class ScanControler extends GetxController {
  DatabaseManeger db = DatabaseManeger();
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  RxBool isCameraInitialised = false.obs;
  int cameraCount = 0;
  double x = 0, y = 0, w = 0, h = 00;
  String label = "";
  final recorder = FlutterSoundRecorder();
  Uint8List? audioBytes , img;
  RxBool isRecording=false.obs;
  int timer = 0;
  bool detect = false;
  late FlutterVision vision;
  late Fire fire;

  @override
  onInit() {
    super.onInit();
    _initCamera();
    _initTFLite();
    _initRecorder();
  }

  @override
  dispose() {

    cameraController.dispose();
    vision.closeYoloModel();
    recorder.closeRecorder();
    super.dispose();
  }

   Future<void> _initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.medium,
          enableAudio: false);

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;

          if (cameraCount %10 == 0) {
            cameraCount = 0;

            fireDetector(image);
          }
          update();
        });
      });
      isCameraInitialised(true);
      update();
    } else
      print("Permission Denied");
  }

  Future<void> _initTFLite() async {

    vision = FlutterVision();
    await vision.loadYoloModel(
        modelPath: "assets/firesmoke32.tflite",
        labels: "assets/firesmoke.txt",
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: false);
  }

  Future<void> _initRecorder() async{
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted)

      throw("microphon permission not granted");

    await recorder.openRecorder();
    recorder.setSubscriptionDuration(Duration(minutes: 1));

  }

  Future startRecord() async{
    await recorder.startRecorder(toFile: 'audio');
    isRecording.value=true;
    update();
  }
  Future stopRecord() async{
    isRecording.value=false;

    final path = await recorder.stopRecorder();
    if(path.isNull) return ;
     audioBytes = await File(path!).readAsBytes();
    update();

  }


  fireDetector(CameraImage image) async {
    var detector = await vision.yoloOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: 0.4,
        confThreshold: 0.2,
        classThreshold: 0.5);

    if (detector != null) {

      if (detector.length != 0 && detector.first["box"][4] * 100 > 20) {
        var firstValue = detector.first;
        label = detector.first["tag"].toString();
        timer = 0;
        detect = true;

        double x1 = double.parse(firstValue['box'][0].toString());
        double x2 = double.parse(firstValue['box'][1].toString());
        double y1 = double.parse(firstValue['box'][2].toString());
        double y2 = double.parse(firstValue['box'][3].toString());

        h = y2;
        w = x2;
        x = x1;
        y = y1;
      } else {

        timer++;
      }

      if (timer >= 5) {

        timer = 0;
        detect = false;
        w = 0;
        h = 0;
      }

      update();
    }
  }
   getImage()async{

     XFile f=await cameraController.takePicture();
     img=await f.readAsBytes();


     return img;
  }

  Future<void> signalFire() async {

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == "denied" || locationPermission == "deniedForever")

    await Geolocator.requestPermission();

    Position currentPossion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    fire= new Fire(currentPossion.longitude,currentPossion.latitude,"Undiffined",DateTime.now());
    fire.setAudio(audioBytes);

     fire.setImage(img!);
    await db.addFire(fire);
  }



}
