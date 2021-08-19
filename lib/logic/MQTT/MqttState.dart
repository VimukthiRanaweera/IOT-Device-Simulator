part of 'MqttBloc.dart';




class MqttState extends Equatable{
  @override
  List<Object?> get props =>[];
}

class MqttConnectedState extends MqttState{}

class MqttConnectingState extends MqttState{}

class MqttDisconnectedState extends MqttState{}

class MqttPublishingState extends MqttState{
  List<Object?> get props =>[];
}

class MqttPublishedState extends MqttState{}

class MqttSubscribedState extends MqttState{}

class MqttUnSubscribedState extends MqttState{}

