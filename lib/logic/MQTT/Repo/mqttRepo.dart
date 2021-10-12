
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/MQTT/Data/MqttAPI.dart';

import '../randomDataCubit.dart';

class MqttRepo{
  late MqttAPI api;
 bool isConnect=false;

  Future<bool> connect(HiveConObject connection,int qos) async {
    api=MqttAPI();
    bool res=await api.connectDevice(connection.username, connection.password, connection.brokerAddress,connection.port,connection.keepAlive,connection.connectionID,qos);
    isConnect=res;
    return res;
  }
   Future<int> disconnect() async {
    try {
      await api.Disconnect();
      isConnect=false;
    }catch(_){
      print("Exception in the disconnect");
    }
    return 0;
   }

   Future<bool> publish(pubTopic, message) async {
     final randomData=new RandomDataState(dataString:message);
     randomData.setData();
      await api.Publish(pubTopic, randomData.dataString);
     await Future.delayed(Duration(seconds: 3), () async {
        print("waiting.....");
     });
     return isConnect;
   }

   Future<bool> multiplePublish(count,time,pubTopic, message) async {
     for (int i = 0; i < count; i++) {
       await Future.delayed(Duration(seconds: time), () async {
         final randomData=new RandomDataState(dataString:message);
         randomData.setData();
         isConnect=await api.Publish(pubTopic,randomData.dataString);
       });
       if(!isConnect)
         break;
     }
     return isConnect;
   }

   Future<void> subscribe(subTopic,isResponse) async {
      await api.subscribe(subTopic,isResponse);
   }

   Future<void> Unsubscribe(subTopic) async {
    await api.unsubscribe(subTopic);
   }

}