import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttAPI{
  late final client;

  // ignore: close_sinks
  static final StreamController<String> controller = StreamController<String>.broadcast();
  // ignore: close_sinks
  static final StreamController<String> responeTopicController = StreamController<String>.broadcast();
  // ignore: close_sinks
  static final StreamController<String> connectionController =StreamController<String>.broadcast();
  Stream<String> get stream =>controller.stream;

  Future<bool> connectDevice(username,password,brokerAddress,port) async {
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

  Future<void> Publish(String pubTopic,String message)async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    print('EXAMPLE::Publishing our topic $message $pubTopic');
    var state=client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
    print("in publish before");
    print(state);
    print("in publish after");
  }

  Future<void> Disconnect() async {
    await MqttUtilities.asyncSleep(2);
    print('EXAMPLE::Disconnecting');
    client.disconnect();
  }

  /// The unsolicited disconnect callback
  void onDisconnected(){

    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }else{
      print('EXAMPLE::OnDisconnected callback is Unsolicited, this is correct');
      connectionController.sink.add("Disconnected");
    }

  }

  Future<void> subscribe(String subTopic,bool isResponse) async {
    print("in the subscribe function");
    const topic = '+/2270735/generic_brand_2921/generic_device/v7/sub'; // Not a wildcard topic
    await client.subscribe(subTopic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess =c![0].payload as MqttPublishMessage;
      final pt =  MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      controller.sink.add(pt);
      if(isResponse)
        responeTopicController.sink.add(c[0].topic);
    });
    client.published!.listen((MqttPublishMessage message) {
      print('EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');

    });

  }



  Future<void> unsubscribe(topic) async {
    try {
      print('EXAMPLE::Unsubscribing');
      client.unsubscribe(topic);
      print("after unsubscribed");
    }catch(e){
      print(e);
    }

  }
  void onUnsubscribe(String topic){
    print("<<<<<<<<<<Unsubscribed the topic  $topic>>>>>>>>>");
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }




}