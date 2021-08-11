
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

part 'mqttConState.dart';
class MqttConCubit extends Cubit<MqttConState>{
  MqttConCubit() : super(MqttConState(brokerAddress: "", port: 0, username: "", password: "", keepAlive:60));

  void setConnection(address, port, username, password, keepAlive) =>emit(MqttConState(brokerAddress: address, port: port,
      username: username, password: password, keepAlive: keepAlive));




}