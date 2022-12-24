import 'package:flutter/material.dart';
import 'package:flutterfileupload/view/file_up_load_main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileUpLoadMain(),
      debugShowCheckedModeBanner: false,
    );
  }
}
