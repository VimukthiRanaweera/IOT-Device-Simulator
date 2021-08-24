import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:iot_device_simulator/logic/MQTT/Data/MqttAPI.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/MQTT/Repo/mqttRepo.dart';

part 'MqttState.dart';

class MqttBloc extends Bloc<MqttEvents,MqttState>{

  final MqttRepo mqttRepo;
  MqttBloc(this.mqttRepo) : super(MqttClientNotClickState()) ;



  @override
  Stream<MqttState> mapEventToState(MqttEvents event) async* {

    if( event is MqttClientClickedEvent) {
      yield MqttClientClickedState();
      yield MqttDisconnectedState();
    }
    if( event is MqttUnselectedEvent)
      yield MqttClientNotClickState();

    if(event is MqttConnetEvent){
      yield MqttConnectingState();
      bool response = await mqttRepo.connect(event.con);
      if(response)
        yield MqttConnectedState();
      else
        yield MqttDisconnectedState();

    }

    if(event is MqttDisConnectEvent){
      int response= await mqttRepo.disconnect();
      yield MqttDisconnectedState();
    }

    if(event is MqttPublishEvent){
      yield MqttPublishingState();
      mqttRepo.publish(event.topic,event.message);
      yield MqttPublishedState();
    }

    if(event is MqttMultiplePublishEvent){
      yield MqttPublishingState();
      await mqttRepo.multiplePublish(event.count, event.time,event.topic,event.message);
      yield MqttPublishedState();
    }

    if(event is MqttSubscribeEvent){
      await mqttRepo.subscribe(event.topic);
      yield MqttSubscribeTopicState();

    }

    if(event is MqttUnsubscribeEvent){
      await mqttRepo.Unsubscribe(event.topic);
      yield MqttUnSubscribedState();

    }

  }


}