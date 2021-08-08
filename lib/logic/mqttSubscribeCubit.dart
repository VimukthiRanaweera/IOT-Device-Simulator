
import 'package:bloc/bloc.dart';


class MqttSubscribeCubit extends Cubit<MqttSubscribeState>{
  MqttSubscribeCubit() : super(MqttSubscribeState(message:"", checkSubscribe:false));
  void setMessage(message,checkSubscribe)=>emit(MqttSubscribeState(message: message, checkSubscribe:checkSubscribe));

}
class MqttSubscribeState {
  late String message;
  bool checkSubscribe;

  MqttSubscribeState({required this.message, required this.checkSubscribe});
}
