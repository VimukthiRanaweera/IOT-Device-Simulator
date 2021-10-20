import 'package:equatable/equatable.dart';

class CoapEvents extends Equatable{
  @override
  List<Object?> get props => [];

}

class CoapGetEvent extends CoapEvents{
  late final String host;
  late final int port;
  late final uriPath;

  CoapGetEvent(this.host, this.port,this.uriPath);
  List<Object?> get props => [
    host,port,uriPath
  ];
}

class CoapPostEvent extends CoapEvents{
  late final String host;
  late final int port;
  late final uriPath;
  late final String uriTitle;

  CoapPostEvent(this.host, this.port, this.uriPath,this.uriTitle);
  List<Object?> get props => [
    host,port,uriTitle,uriPath
  ];
}