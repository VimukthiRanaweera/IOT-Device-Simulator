import 'package:equatable/equatable.dart';

class MqttEvents extends Equatable{
  @override
  List<Object?> get props =>[];

}

class MqttConnetEvent extends MqttEvents{

  late final String brokerAddress;
  late final int port;
  late final String username;
  late final String password;

  MqttConnetEvent({required this.brokerAddress, required this.port, required this.username, required this.password});

  List<Object?> get props =>[
    brokerAddress,
    port,
    username,
    password,
  ];
}

class MqttDisConnectEvent extends MqttEvents{}

class MqttPublishEvent extends MqttEvents{
  late String topic;
  late String message;


  MqttPublishEvent({required this.topic, required this.message});

  List<Object?> get props =>[
    topic,
    message
  ];
}

class MqttMultiplePublishEvent extends MqttEvents{
  late int count;
  late int time;
  late String topic;
  late String message;


  MqttMultiplePublishEvent({required this.count, required this.time, required this.topic, required this.message});

  List<Object?> get props =>[
    topic,
    message,
    time,
    count,
  ];
}

class MqttSubscribeEvent extends MqttEvents{
  late String topic;


  MqttSubscribeEvent(this.topic);

  List<Object?> get props =>[
    topic,
  ];

}

class MqttUnsubscribeEvent extends MqttEvents{}