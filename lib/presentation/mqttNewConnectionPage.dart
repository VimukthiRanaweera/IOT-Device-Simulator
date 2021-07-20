import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/presentation/MobileMqttNewConnection.dart';
import 'package:iot_device_simulator/presentation/windowMqttNewConnection.dart';

class MqttNewConnectionPage extends StatefulWidget {
  // const MqttNewConnectionPage({Key key}) : super(key: key);

  @override
  _MqttNewConnectionPageState createState() => _MqttNewConnectionPageState();
}

class _MqttNewConnectionPageState extends State<MqttNewConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('MQTT Connection'),
      ),
      body:LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint){
          if(constraint.maxWidth<700) {
            return MobileNewMqttConnection();
          }
          else{
            return WindowMqttNewConnection();

          }
        }
      ),
    );
  }
}
