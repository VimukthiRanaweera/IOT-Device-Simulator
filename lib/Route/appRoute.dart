import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/presentation/HomePage.dart';
import 'package:iot_device_simulator/presentation/NewConnectionPage.dart';

class AppRouter{
  Route? onGenerateRoute(RouteSettings routeSettings){
    switch(routeSettings.name){
      case'/':
        return MaterialPageRoute(
          builder: (_)=>HomePage()
        );
      case '/newConnection':
        return MaterialPageRoute(
            builder:(_)=>NewConnectionPage(
              title: 'logic.MQTT',
            )
        );
    }
  }
}