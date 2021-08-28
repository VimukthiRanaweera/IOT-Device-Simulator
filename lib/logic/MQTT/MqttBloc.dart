import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/MQTT/Repo/mqttRepo.dart';

import 'Data/MqttAPI.dart';

part 'MqttState.dart';

class MqttBloc extends Bloc<MqttEvents,MqttState>{

  final MqttRepo mqttRepo;
  late StreamSubscription subscription;
  late String response;
  MqttBloc(this.mqttRepo) : super(MqttClientNotClickState()) {

    subscription = MqttAPI.responeTopicController.stream.listen((data) {

      List words = data.split('/');
      words[words.length-1]="pub";
      String pubTopic=words[0];
      for(int i=1;i<words.length;i++){
        pubTopic="$pubTopic/${words[i]}";
      }
     mqttRepo.api.Publish(pubTopic,response);
    responseSend();
      print('mqtttsubresponse...............');

    });

  }

  void responseSend() {
    emit(MqttSubscribeResponsedState());
  }

  @override
  Stream<MqttState> mapEventToState(MqttEvents event) async* {

    if( event is MqttClientClickedEvent) {
      yield MqttClientClickedState();
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
      await mqttRepo.subscribe(event.topic,false);
      yield MqttSubscribeTopicState();

    }
    if(event is MqttSubscribeAndResponseEvent){
      response=event.response;
      await mqttRepo.subscribe(event.topic,true);
      yield MqttSubscribeTopicState();

    }

    if(event is MqttUnsubscribeEvent){
      await mqttRepo.Unsubscribe(event.topic);
      yield MqttUnSubscribedState();

    }
    if(event is MqttClientDeleteEvent){
      if(event.connection.protocol=="MQTT")
        if(event.connection.protocol==event.conName)
             yield MqttClientNotClickState();
    }

  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

}