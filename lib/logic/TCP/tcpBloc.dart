import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:iot_device_simulator/logic/MQTT/randomDataCubit.dart';
import 'package:iot_device_simulator/logic/TCP/TcpApi.dart';
import 'package:iot_device_simulator/logic/TCP/tcpEvents.dart';
import 'package:iot_device_simulator/logic/TCP/tcpState.dart';
import 'package:iot_device_simulator/presentation/component/tcp.dart';

class TcpBloc extends Bloc<TcpEvents, TcpState> {
  late TcpApi tcpApi;
  late int messageIndex;
  late int responseIndex;
  late StreamSubscription subscription;
  TcpBloc() : super(TcpDisconnectedState()){

    subscription = TcpApi.responseController.stream.listen((data) {
     setResponse(data);
      print("in the listener $data");
    });
  }

  void setResponse(String response){
    emit(TcpResponseAddState.addResponse(responseIndex, response));
    responseIndex++;
  }

  @override
  Stream<TcpState> mapEventToState(TcpEvents event) async* {
    if (event is TcpConnectEvent) {
      messageIndex=0;
      responseIndex=0;
      yield TcpConnectState();
      yield TcpConnectingState();
      tcpApi = TcpApi();
      bool isConnect = await tcpApi.startConnection(event.host, event.port);
      if (isConnect)
        yield TcpConnectedState();
      else
        yield TcpDisconnectedState();
    }
    if (event is TcpDisconnectEvent) {
      tcpApi.disconnect();
      yield TcpDisconnectedState();
    }

    if (event is TcpSendMessageEvent) {
      try {
        yield TcpMessageSendingState();
        for (int i = 0; i < TcpBody.textBoxes.length; i++) {
          yield TcpAddListState.addList();
          final randomData=new RandomDataState(dataString:TcpBody.textBoxes[i].message.text);
          randomData.setData();
          await Future.delayed(Duration(seconds: 3), () async {
            await tcpApi.sendMessage(randomData.dataString);
          });
          yield TcpMessageSendState.addMessage(messageIndex,randomData.dataString);
          messageIndex++;
        }
      } catch (e) {
        print(e.toString());
        tcpApi.disconnect();
        yield TcpDisconnectedState();
      }
    }

      if(event is TcpAutoSendMessageEvent){
        yield TcpMessageSendingState();

        for(int i = 0; i < TcpBody.textBoxes.length; i++){
          for (int j = 0; j < event.count; j++) {
            yield TcpAddListState.addList();
            final randomData=new RandomDataState(dataString:TcpBody.textBoxes[i].message.text);
            randomData.setData();
            await Future.delayed(Duration(seconds: event.time), () async {
              await tcpApi.sendMessage(randomData.dataString);
            });
            yield TcpMessageSendState.addMessage(messageIndex,randomData.dataString);
            messageIndex++;
          }
        }
      }
      if( event is TcpMessageAndResponseListClearEvent){
        yield TcpListClearState.clearList();
        messageIndex=0;
        responseIndex=0;
      }
    }
    @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
  }
