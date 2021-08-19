part of'mqttConCubit.dart';

class MqttConState{

  late final client;
   String brokerAddress;
   int port;
  String username;
   String password;
  int keepAlive;


  late  String subMessage="";

  MqttConState({required this.brokerAddress, required this.port, required this.username, required this.password,
      required this.keepAlive});



  Future<bool> connectDevice() async {

    client = MqttServerClient(brokerAddress, '');
    client.logging(on: false);
    client.port = port;

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 20;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = onDisconnected;

    /// Add the successful connection callback
    client.onConnected = onConnected;

    /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
    /// You can add these before connection or change them dynamically after connection if
    /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
    /// can fail either because you have tried to subscribe to an invalid topic or the broker
    /// rejects the subscribe request.
    client.onSubscribed = onSubscribed;
    /// Set a ping received callback if needed, called whenever a ping response(pong) is received
    /// from the broker.
    client.pongCallback = pong;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password and clean session,
    /// an example of a specific one below.
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .authenticateAs(username,password)
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Dialog client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Dialog client connected');
      return true;

    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Dialog client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
    return false;
  }

  /// The successful connect callback
  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  int Publish(String pubTopic,String message){
    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      print('EXAMPLE::Publishing our topic');
      var state = client.publishMessage(
          pubTopic, MqttQos.exactlyOnce, builder.payload!);
      print("in publish before");
      print(state);
      print("in publish after");
      return state;
    }catch(_){
      print('Exception in the publish');
      return-1;
    }
  }

  Future<void> Disconnect() async {
    try {
      await MqttUtilities.asyncSleep(2);
      print('EXAMPLE::Disconnecting');
      var code = client.disconnect();
      print('in the Disconnection function $code');
    }catch(_){
      print('Disconnection Exception');
    }

  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }else{

    }

  }

  void subscribe(subTopic){
    print("in the subscribe function");
    const topic = '+/2270735/generic_brand_2921/generic_device/v7/sub'; // Not a wildcard topic
    client.subscribe(subTopic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      subMessage=pt;
    });

    client.published!.listen((MqttPublishMessage message) {
      print('EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }

}