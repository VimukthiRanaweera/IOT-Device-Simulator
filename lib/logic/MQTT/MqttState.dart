part of 'MqttBloc.dart';




class MqttState extends Equatable{
  @override
  List<Object?> get props =>[];
}
class MqttClientNotClickState extends MqttState{}

class MqttClientClickedState extends MqttState{}

class MqttConnectedState extends MqttState{}

class MqttConnectingState extends MqttState{}

class MqttDisconnectedState extends MqttState{}

class MqttPublishingState extends MqttState{
  List<Object?> get props =>[];
}

class MqttPublishedState extends MqttState{}

class MqttSubscribeTopicState extends MqttState{}

class MqttSubscribedState extends MqttState{
  static List<String> messages=[];

  MqttSubscribedState(message){
    messages.add(message);
  }
}

class MqttSubscribeResponsedState extends MqttState{
  late String response;

  MqttSubscribeResponsedState(this.response);

  List<Object?> get props =>[response];
}

class MqttSubscribeNotResponsedState extends MqttState{}

class MqttUnSubscribedState extends MqttState{}


