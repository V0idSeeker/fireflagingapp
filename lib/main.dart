import 'package:firesigneler/modules/Styler.dart';
import 'package:firesigneler/views/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(home: MyApp(),) );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Styler styler = Styler();
    return MaterialApp(
      title: 'Wildfire Watch',
      theme: styler.themeData,
      home: MainScrean(),
    );
  }
}
