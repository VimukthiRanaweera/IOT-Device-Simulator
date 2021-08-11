import 'package:bloc/bloc.dart';

class ConnectionCubit extends Cubit<ConState>{
  ConnectionCubit() : super(ConState(username: '', connectionName: 'Iot Client',
      password: '', port:1896, brokerAddress: '', connectionID: '' ,protocol: '', keepAlive: 60));

  void setConnectionDetails(protocol,connectionName,connectionID,brokerAddress,port,username,password,keepAlive)=>
      emit(ConState(protocol:protocol,connectionName:connectionName,connectionID:connectionID,brokerAddress:brokerAddress,
          port:port,username:username,password:password, keepAlive:keepAlive));

}

class ConState{

  late String protocol;
  late String connectionName;
 late String connectionID;
   late String brokerAddress;
  late int port;
  late String username;
  late String password;
  late int keepAlive;

  ConState({
    required this.protocol,
    required this.connectionName,
    required this.connectionID,
    required this.brokerAddress,
    required this.port,
    required this.username,
    required this.password,
    required this.keepAlive,
  });




}