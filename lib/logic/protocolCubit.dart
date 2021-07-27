
import 'package:bloc/bloc.dart';

class ProtocolCubit extends Cubit<ProtocolState>{
  ProtocolCubit() : super(ProtocolState(protocol:"MQTT"));

  void SetProtocol(DropDownValue) =>emit(ProtocolState(protocol:DropDownValue));

}

class ProtocolState{
  late String protocol;

  ProtocolState({required this.protocol});
}