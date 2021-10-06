import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttSecureApi{
var client;
var qosType;
  /// An annotated simple subscribe/publish usage example for a secure mqtt_server_client. Please read in with reference
  /// to the MQTT specification. The example is runnable, also refer to test/mqtt_client_broker_test...dart
  /// files for separate subscribe/publish tests.
  /// First create a client, the client is constructed with a broker name, client identifier
  /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
  /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
  /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
  /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
  /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
  /// The client identifier can be a maximum length of 23 characters.

  Future<bool> connect() async {

    client = MqttServerClient('devdeviceconnect.iot.xpand.asia', '');
    /// Set logging on if needed, defaults to off
    client.logging(on: false);

    /// Set secure
    client.secure = true;
    // Set the port
    client.port =1894;
    /// Security context
    final currDir = 'C:\\Users\\Lenovo\\Desktop\\73248${path.separator}example${path.separator}';
    final context = SecurityContext.defaultContext;
    context
        .setTrustedCertificates(
        currDir + path.join('pem', 'user.crt'));

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

    /// Set an on bad certificate callback, note that the parameter is needed.
    client.onBadCertificate = (dynamic a) => true;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password and clean session,
    /// an example of a specific one below.
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .authenticateAs("vimukthi-device_01-v3_6680","1630129274_6680")
        .withWillTopic(
        'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::devdeviceconnect.iot.xpand.asia client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
      return true;
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client
              .connectionStatus}');
      client.disconnect();
      return false;

    }
  }

  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  Future<void> Publish(String pubTopic,String message)async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    print('EXAMPLE::Publishing our topic $message $pubTopic');
    var state=client.publishMessage(pubTopic, qosType, builder.payload!);
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

    }

  }

  Future<void> subscribe(String subTopic,bool isResponse) async {
    print("in the subscribe function");
    const topic = '+/2270735/generic_brand_2921/generic_device/v7/sub'; // Not a wildcard topic
    await client.subscribe(subTopic, qosType);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess =c![0].payload as MqttPublishMessage;
      final pt =  MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');

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