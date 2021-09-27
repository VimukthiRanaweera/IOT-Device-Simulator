import 'dart:async';
import 'package:coap/coap.dart';
import '../config/coap_config_debug.dart';
class CoapApi {
  late final client;
  FutureOr<void> connect(hostAddress, port, message) async {
    /// Create a configuration class. Logging levels can be specified in
    /// the configuration file

    print("in the coap file");
    final conf = CoapConfig();

    // Build the request uri, note that the request paths/query parameters can be changed
    // on the request anytime after this initial setup.
    const host = 'localhost';

    final uri = Uri(scheme: 'coap', host: hostAddress, port: port);

    // Create the client.
    // The method we are using creates its own request so we do not
    // need to supply one.
    // The current request is always available from the client.
     client = CoapClient(uri, conf);

    // Adjust the response timeout if needed, defaults to 32767 milliseconds
    //client.timeout = 10000;

    // Create the request for the post request
    final request = CoapRequest.newPut();
    request.addUriPath('storage');
    // // Add a title
    request.addUriQuery('${CoapLinkFormat.title}=This is an SJH Post request');
    client.request = request;

    print('EXAMPLE - Sending post request to $host, waiting for response....');

    var response = await client.post(message);
    print('EXAMPLE - post response received, sending get');
    print(response.payloadString);
    // Now get and check the payload
    final getRequest = CoapRequest.newGet();
    getRequest.addUriPath('storage');
    client.request = getRequest;
    response = await client.get();
    print('EXAMPLE - get response received');
    print(response.payloadString);
    final options = response.getAllOptions();
    for (final option in options) {
      if (option.type == optionTypeUriQuery) {
        print('Title is : ${option.stringValue.split('=')[1]}');
      }
    }
    if (response.payloadString == message) {
      print('EXAMPLE - Hoorah! the post has worked');
    } else {
      print('EXAMPLE - Boo! the post failed');
    }

    // Clean up

    print('end>>>>>>>>>>>>>>>>>>>>');
    client.close();

  }


}