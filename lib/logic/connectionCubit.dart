import 'package:bloc/bloc.dart';

class ConnectionCubit extends Cubit<ConnectionState>{
  ConnectionCubit() : super(ConnectionState.ID(''));
  void setConnectionName(connectionName)=> emit(ConnectionState.name(connectionName));
  void setConnectionID(connectionID)=> emit(ConnectionState.ID(connectionID));
  void setBrokerAddress(connectionAddress)=> emit(ConnectionState.address(connectionAddress));
  void setPort(connectionPort)=> emit(ConnectionState.port(connectionPort));
  void setUsername(username)=> emit(ConnectionState.port(username));
  void setPassword(password)=> emit(ConnectionState.port(password));
  void setKeepAlive(alive)=> emit(ConnectionState.port(alive));
  void setTimeout(timeout)=> emit(ConnectionState.port(timeout));

}

class ConnectionState{
  late String connectionName;
  late String connectionID;
  late String brokerAddress;
  late int port;
  late String username;
  late String password;
  late int keepAlive;
  late int connectionTimeOut;
 static List<ConnectionState> list=[];



  ConnectionState.name(this.connectionName);
  ConnectionState.ID(this.connectionID);
  ConnectionState.address(this.brokerAddress);
  ConnectionState.port(this.port);

  ConnectionState.username(this.username);

  ConnectionState.password(this.password);

  ConnectionState.keepalive(this.keepAlive);

  ConnectionState.connectiontimeout(this.connectionTimeOut);
}