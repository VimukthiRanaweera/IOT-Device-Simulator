
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/MQTT/mqttConnectionManager.dart';

class MqttConnectionCubit extends Cubit<MqttConnState>{
  MqttConnectionCubit() : super(MqttConnState(mqttConnectionManager: new MqttConnectionManager("",0,'','')));

  void setPublishDetails(connectManager)=>emit(MqttConnState(mqttConnectionManager:connectManager));

}

class MqttConnState{
  late MqttConnectionManager mqttConnectionManager;

  MqttConnState({required this.mqttConnectionManager});

}

