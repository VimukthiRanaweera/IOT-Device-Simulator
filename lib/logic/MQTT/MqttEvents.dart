import 'package:equatable/equatable.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';

class MqttEvents extends Equatable{
  @override
  List<Object?> get props =>[];

}
class MqttClientClickedEvent extends MqttEvents{}
class MqttUnselectedEvent extends MqttEvents{}

class MqttConnetEvent extends MqttEvents{

  late final HiveConObject con;


  MqttConnetEvent(this.con);

  List<Object?> get props =>[

  ];
}

class MqttDisConnectEvent extends MqttEvents{}

class MqttPublishEvent extends MqttEvents{
  late final String topic;
  late final String message;


  MqttPublishEvent({required this.topic, required this.message});

  List<Object?> get props =>[
    topic,
    message
  ];
}

class MqttMultiplePublishEvent extends MqttEvents{
  late final int count;
  late final int time;
  late final String topic;
  late final String message;


  MqttMultiplePublishEvent({required this.count, required this.time, required this.topic, required this.message});

  List<Object?> get props =>[
    topic,
    message,
    time,
    count,
  ];
}

class MqttSubscribeEvent extends MqttEvents{
  late final String topic;


  MqttSubscribeEvent(this.topic);

  List<Object?> get props =>[
    topic,
  ];

}
class MqttSubscribeAndResponseEvent extends MqttEvents{
  late final String topic;
  late final String response;
  late final String responseTopic;

  MqttSubscribeAndResponseEvent(this.topic, this.response,this.responseTopic);
  List<Object?> get props =>[
    topic,
    response,
    responseTopic
  ];
}



class MqttUnsubscribeEvent extends MqttEvents{

  late final String topic;

  MqttUnsubscribeEvent(this.topic);
  List<Object?> get props =>[
    topic,
  ];
}

class MqttClientDeleteEvent extends MqttEvents{
  late final HiveConObject connection;
  late final String conName;

  MqttClientDeleteEvent(this.connection, this.conName);
  List<Object?> get props =>[
    conName,connection
  ];
}