import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/MQTT/Repo/mqttRepo.dart';
import 'package:iot_device_simulator/logic/MQTT/randomDataCubit.dart';
import 'Data/MqttAPI.dart';
part 'MqttState.dart';

class MqttBloc extends Bloc<MqttEvents,MqttState>{

  final MqttRepo mqttRepo;
  late StreamSubscription subscription;
  late StreamSubscription connectionSubscription;
  late String response="";
  late String responseTopic;
  bool isLogWrite = false;
  bool isResponse = false;
  MqttBloc(this.mqttRepo) : super(MqttClientNotClickState()) {

    subscription = MqttAPI.responeTopicController.stream.listen((data) async {
      if(isResponse){
        List words = data.split('/');
        String id=words[0];
        String pubTopic=responseTopic.replaceAll("+",id);
        RandomDataState randomDataState = RandomDataState(dataString: response);
        randomDataState.setData();
       await mqttRepo.publish(pubTopic,randomDataState.dataString);
        responseSend(randomDataState.dataString);
        print('mqtttsubresponse...............');

      }
      else{
        notResponseSend();
      }

    });
    connectionSubscription = MqttAPI.connectionController.stream.listen((event) {
      if(event.toString() =="Disconnected"){
        print("diconnected>>>>>>>>>>>>");
        disconnected();
      }

    });

  }

  void responseSend(response) {
    emit(MqttSubscribeResponsedState(response));
  }

  void notResponseSend() {

    emit(MqttSubscribeNotResponsedState());
  }

  void disconnected(){
    emit(MqttDisconnectedState());
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
      bool response = await mqttRepo.connect(event.con,event.qos);
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
      isResponse=false;
      await mqttRepo.subscribe(event.topic,false);
      yield MqttSubscribeTopicState();

    }
    if(event is MqttSubscribeAndResponseEvent){
      response=event.response;
      responseTopic = event.responseTopic;
      isResponse=true;
      await mqttRepo.subscribe(event.topic,true);
      yield MqttSubscribeTopicState();

    }

    if(event is MqttUnsubscribeEvent){
      await mqttRepo.Unsubscribe(event.topic);
      yield MqttUnSubscribedState();

    }
    if(event is MqttClientDeleteEvent){
      if(event.connection.protocol=="MQTT")
        if(event.connection.connectionName==event.conName)
             yield MqttClientNotClickState();
    }

  }

  @override
  Future<void> close() {
    subscription.cancel();
    connectionSubscription.cancel();
    return super.close();
  }

}