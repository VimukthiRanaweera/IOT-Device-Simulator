import 'package:equatable/equatable.dart';
import 'package:iot_device_simulator/MODEL/tcpControllers.dart';
import 'package:iot_device_simulator/MODEL/tcpMessages.dart';

class TcpState extends Equatable{
  static List<TcpMessages> messageAndResponse = [];
  TcpState();

  TcpState.addList(){
    messageAndResponse.add(new TcpMessages());
  }

  TcpState.addMessage(int index,String message){
    messageAndResponse[index].message=message;
  }


  TcpState.addResponse(int index,String response){
    messageAndResponse[index].response=response;
  }


  TcpState.clearList(){
    messageAndResponse.clear();
  }

  @override
  List<Object?> get props => [messageAndResponse];
}

class TcpConnectState extends TcpState{}

class TcpConnectingState extends TcpState{}

class TcpConnectedState extends TcpState{}

class TcpDisconnectedState extends TcpState{}

class TcpAddListState extends TcpState{
  TcpAddListState.addList() : super.addList();
}

class TcpMessageSendState extends TcpState{
  TcpMessageSendState.addMessage(int index, String message) : super.addMessage(index, message);
}

class TcpResponseAddState extends TcpState{
  TcpResponseAddState.addResponse(int index, String response) : super.addResponse(index, response);

}
class TcpListClearState extends TcpState{
  TcpListClearState.clearList() : super.clearList();
}

class TcpMessageSendingState extends TcpState{}



