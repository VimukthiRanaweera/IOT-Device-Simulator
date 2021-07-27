
import 'package:flutter_bloc/flutter_bloc.dart';

class MqttPublishCubit extends Cubit<MqttPublishState>{
  MqttPublishCubit() : super(MqttPublishState(topic:'', message:'',publishIsSelected:true));

  void setPublishDetails(topic,message,publishIsSelected)=>emit(MqttPublishState(topic:topic,message:message,publishIsSelected: publishIsSelected));
}

class MqttPublishState{
  late String topic;
  late String message;
  bool publishIsSelected;

  MqttPublishState({required this.topic, required this.message,required this.publishIsSelected});
}