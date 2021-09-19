import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:iot_device_simulator/MODEL/apiParaControllers.dart';
class ApiAutomateRepo{

  Future<Map<String, dynamic>> apiManagement(String xSecret) async {
    try {
      var headers = {
        'X-Secret': xSecret,
        'accept': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://iot.dialog.lk/developer/api/applicationmgt/authenticate'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print("in the Api management");
      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        var responseBody=convert.jsonDecode(await response.stream.bytesToString());
        return responseBody;
      }
      else {
        print(response.reasonPhrase);
        throw Exception("bad request");
      }
    }catch(_){
      throw Exception('not connect');
    }

  }

  Future<Map<String, dynamic>> userManagemnet(username,password,tokenType,accessToken) async{

      var headers = {
        'Authorization': '$tokenType $accessToken',
        'Content-Type': 'application/json',
        'accept': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://iot.dialog.lk/developer/api/usermgt/v1/authenticate'));
      request.body = json.encode({
        "username": username,
        "password": password
      });
      request.headers.addAll(headers);
      print("in the usermanagement");
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseBody=convert.jsonDecode(await response.stream.bytesToString());
        return responseBody;
      }
      else {
        print(response.reasonPhrase);
        throw Exception("invalid User Credential");
      }

  }

  Future<Map<String, dynamic>> deviceHistory({tokenType,accessToken,XIotJwt,eventName,deviceIds,startDate,endDate,noOfEvents,zoneId,params}) async {
    var headers = {
      'Authorization': '$tokenType $accessToken',
      'X-IoT-JWT': '$XIotJwt',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('https://iot.dialog.lk/developer/api/datamgt/v1/user/devicehistory?eventName=$eventName&deviceIds=$deviceIds'
        '&startDate=$startDate:00&endDate=$endDate:00&noOfEvents=$noOfEvents&zoneId=$zoneId&eventParams=$params'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody=convert.jsonDecode(await response.stream.bytesToString());
      return responseBody;
      // print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    throw Exception("error in Device history Api Call");
    }
  }

  Future<String> executeAction({required String tokenType,required String accessToken,required String XIotJwt,required int deviceId,
    required String actionName,required int userID,required List<ApiParaControllers> paramList}) async {

    var headers = {
      'Authorization':  '$tokenType $accessToken',
      'X-IoT-JWT':'$XIotJwt',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    print("in the execute ????");

    var request = http.Request('POST', Uri.parse('https://iot.dialog.lk/developer/api/userdevicecontrol/v1/devices/executeaction?deviceId&actionName&userId'));
    request.body = json.encode({
      "operation": "deviceControl",
      "deviceId": deviceId,
      "actionName": actionName,
      "userId": userID,
      "actionParameters": {
        for(var item in paramList)
          "${item.para.text}": "${item.value.text}"
      }
    });
    print(deviceId);
    print(actionName);
    print(userID);
    print("in the execute action");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("success" );
    }
    else {
      print("in the execute action else......");
    print(response.reasonPhrase);
    }
    var responseBody= await response.stream.bytesToString();
    return responseBody;

  }


}
