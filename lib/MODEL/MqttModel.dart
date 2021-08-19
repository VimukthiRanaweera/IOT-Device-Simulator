class MqttModel{


  late String protocol;
  late String connectionName;
  late String connectionID;
  late String brokerAddress;
  late int port;
  late String username;
  late String password;
  late int keepAlive;

  MqttModel({required this.protocol, required this.connectionName, required this.brokerAddress, required this.port,
      required this.username, required this.password, required this.keepAlive});
}