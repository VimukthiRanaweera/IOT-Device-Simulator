import 'dart:async';
import 'package:coap/coap.dart';
import '../config/coap_config_debug.dart';
class CoapApi {


  Future<dynamic> get(String hostAddress,hostPort,uriPath) async {
    // Create a configuration class. Logging levels can be specified in
    // the configuration file
    final conf = CoapConfig();
    // Build the request uri, note that the request paths/query parameters can be changed
    // on the request anytime after this initial setup.
    var host = '$hostAddress';
    final uri = Uri(scheme: 'coap', host: host, port:hostPort);
    // Create the client.
    // The method we are using creates its own request so we do not
    // need to supply one.
    // The current request is always available from the client.
    final client = CoapClient(uri, conf);
    // Adjust the response timeout if needed, defaults to 32767 milliseconds
    //client.timeout = 10000;
    // Create the request for the get request

    final request = CoapRequest.newGet();
    request.addUriPath(uriPath);
    client.request = request;
    print('EXAMPLE - Sending get request to $host, waiting for response....');
    final response = await client.get();
    print('EXAMPLE - response received>>>>>>>>>>>>>>>>');
    print(response.payloadString);
    // Clean up
    print("Client closing.......................");
    client.close();
    return response.payloadString;


  }


  FutureOr<void>  post(String hostAddress,hostPort,uriPath,uriTitle) async {
    // Create a configuration class. Logging levels can be specified in
    // the configuration file.
    final conf = CoapConfig();

    // Build the request uri, note that the request paths/query parameters can be changed
    // on the request anytime after this initial setup.
    var host = '$hostAddress';

    final uri = Uri(scheme: 'coap', host:host, port: hostPort);

    // Create the client.
    // The method we are using creates its own request so we do not
    // need to supply one.
    // The current request is always available from the client.
    final client = CoapClient(uri, conf);

    // Adjust the response timeout if needed, defaults to 32767 milliseconds
    //client.timeout = 10000;

    // Create the request for the put request
    final request = CoapRequest.newPost();
    request.addUriPath(uriPath);
    // Add a title
    request.addUriQuery('${CoapLinkFormat.title}=This is an SJH post request');
    client.request = request;

    print('EXAMPLE - Sending post request to $host, waiting for response....');

    var response = await client.put('SJHTestPut');
    print('EXAMPLE - post response received, sending get>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    print('EXAMPLE -  Payload: ${response.payloadString}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    // Now get and check the payload
    final getRequest = CoapRequest.newGet();
    getRequest.addUriPath(uriPath);
    client.request = getRequest;
    response = await client.get();
    print('EXAMPLE - get response received...............................');
    print('EXAMPLE - Payload: ${response.payloadString}........................');
    print('EXAMPLE - E-Tags : ${CoapUtil.iterableToString(response.etags)}....................');

    // Clean up
    client.close();
  }

}