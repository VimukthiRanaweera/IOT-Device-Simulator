import 'package:flutter/material.dart';
import 'package:iot_device_simulator/presentation/HomePage.dart';
import 'package:iot_device_simulator/constants/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        appBarTheme:AppBarTheme(backgroundColor:appbarColor),
        canvasColor:primaryColor,
        backgroundColor: bgColor,
        elevatedButtonTheme:ElevatedButtonThemeData(
          style:ElevatedButton.styleFrom(
            primary:buttonColor,

          )
        ),
        visualDensity:VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}


