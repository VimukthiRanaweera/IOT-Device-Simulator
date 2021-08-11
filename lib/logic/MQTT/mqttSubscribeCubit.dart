
import 'package:bloc/bloc.dart';


class MqttSubscribeCubit extends Cubit<MqttSubscribeState>{
  MqttSubscribeCubit() : super(MqttSubscribeState(message:"", count:0));

  void callSub(message,count)=>emit(state.copyWith(message:message,count:count));
  void setSub(count)=>emit(state.copyWith(count:count));


}
class MqttSubscribeState {
  final  String message;
  final int count;

  MqttSubscribeState({required this.message, required this.count});

  MqttSubscribeState copyWith({
    String? message,
    int? count,
}) {
    return MqttSubscribeState(
        message: message?? this.message,
        count: count?? this.count
    );
  }

}
