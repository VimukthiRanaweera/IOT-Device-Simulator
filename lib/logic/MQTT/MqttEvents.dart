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

class MqttUnsubscribeEvent extends MqttEvents{

  late String topic;

  MqttUnsubscribeEvent(this.topic);
  List<Object?> get props =>[
    topic,
  ];
}