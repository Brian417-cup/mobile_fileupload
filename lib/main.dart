import 'package:flutter/material.dart';
import 'package:flutterfileupload/provider/file_provider.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FileProvider()),
      ],
      child: MyApp(),
    ),
  );
}
