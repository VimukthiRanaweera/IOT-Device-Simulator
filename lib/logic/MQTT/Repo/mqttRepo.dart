
import 'package:iot_device_simulator/logic/MQTT/MqttAPI.dart';

import '../randomDataCubit.dart';

class MqttRepo{
  late MqttAPI api;

  Future<bool> connect(username, password, brokerAddress, port) async {
    api=MqttAPI();
    bool res=await api.connectDevice(username, password, brokerAddress, port);
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

   void publish(pubTopic, message){
    api.Publish(pubTopic, message);
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

   Future<String> subscribe(subTopic) async {
      String message=await api.subscribe(subTopic);
      return message;
   }

}