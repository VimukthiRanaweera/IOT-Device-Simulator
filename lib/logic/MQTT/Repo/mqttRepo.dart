
import 'dart:ffi';

import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/MQTT/Data/MqttAPI.dart';

import '../randomDataCubit.dart';

class MqttRepo{
  late MqttAPI api;

  Future<bool> connect(HiveConObject connection) async {
    api=MqttAPI();
    bool res=await api.connectDevice(connection.username, connection.password, connection.brokerAddress,connection.port);
    return res;
  }
   Future<int> disconnect() async {
    try {
      await api.Disconnect();
    }catch(_){
      print("Exception in the disconnect");
    }
    return 0;
   }

   Future<void> publish(pubTopic, message) async {
    await api.Publish(pubTopic, message);
   }

   Future<void> multiplePublish(count,time,pubTopic, message) async {
     for (int i = 0; i < count; i++) {
       await Future.delayed(Duration(seconds: time), () async {
         final randomData=new RandomDataState(dataString:message);
         randomData.setData();
         api.Publish(pubTopic,randomData.dataString);

       });
     }
   }

   Future<void> subscribe(subTopic,isResponse) async {
      await api.subscribe(subTopic,isResponse);
   }
   // Future<void> listenSubscribeMessage() async {
   //   await api.listenSubscribeMessage();
   // }

   Future<void> Unsubscribe(subToic) async {
    await api.unsubscribe(subToic);
   }

}