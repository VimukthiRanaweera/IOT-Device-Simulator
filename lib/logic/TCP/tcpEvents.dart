import 'package:equatable/equatable.dart';

class TcpEvents extends Equatable{
  @override
  List<Object?> get props => [];
}

class TcpConnectEvent extends TcpEvents{
  late final String host;
  late final int port;


  TcpConnectEvent(this.host, this.port);

  List<Object?> get props => [
    host,
    port
  ];

}

class TcpDisconnectEvent extends TcpEvents{}

class TcpSendMessageEvent extends TcpEvents{
  TcpSendMessageEvent();
  List<Object?> get props => [

  ];
}
class TcpAutoSendMessageEvent extends TcpEvents{
  late final int count;
  late final int time;
  TcpAutoSendMessageEvent(this.count, this.time);

  List<Object?> get props => [
    count,time,
  ];

}
class TcpMessageWriteFileEvent extends TcpEvents{
  late final String fileName;

  TcpMessageWriteFileEvent(this.fileName);
  List<Object?> get props => [
    fileName
  ];
}

class TcpMessageAndResponseListClearEvent extends TcpEvents{}