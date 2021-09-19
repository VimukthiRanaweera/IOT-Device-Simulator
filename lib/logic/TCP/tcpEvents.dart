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
}
class TcpAutoSendMessageEvent extends TcpEvents{
  late final int count;
  late final int time;

  TcpAutoSendMessageEvent(this.count, this.time);

  List<Object?> get props => [
    count,
    int
  ];

}

class TcpMessageAndResponseListClearEvent extends TcpEvents{}