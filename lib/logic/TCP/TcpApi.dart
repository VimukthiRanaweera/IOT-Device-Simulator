// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
class TcpApi {
  late TcpSocketConnection socketConnection;
  String message = "";

  // ignore: close_sinks
  static final StreamController<String> responseController = StreamController<String>.broadcast();


//receiving and sending back a custom message
  void messageReceived(String msg) {
    print("message is " + msg);
   responseController.add(msg);
  }

//starting the connection and listening to the socket asynchronously
  Future<bool> startConnection(hostAddress,port) async {

      socketConnection = TcpSocketConnection(hostAddress, port);
      socketConnection.enableConsolePrint(
          true); //use this to see in the console what's happening
      if (await socketConnection.canConnect(3000,
          attempts: 3)) { //check if it's possible to connect to the endpoint
        await socketConnection.connect(
            3000, "EOS", messageReceived, attempts: 3);
      }
      if(socketConnection.isConnected())
        return true;
      else
        return false;

  }

  Future<void> sendMessage(String message) async {
      print("in the send message");
      if(socketConnection.isConnected()){
          socketConnection.sendMessage(message);

    }
      else{
        throw Exception("Exception in send message");
      }
  }

  void disconnect(){
    socketConnection.disconnect();

  }
}
