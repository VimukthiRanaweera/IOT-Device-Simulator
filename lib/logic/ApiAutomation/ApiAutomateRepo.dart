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
        print(response.statusCode);
        print("in the invalid x-secret");
        throw Exception(response.statusCode);
      }
    }catch(e){
      print("in the not connect $e");
      if(e.toString().replaceAll("Exception:","").trim()== "401"){
        throw Exception("invalid X-Secret");
      }else{
        throw Exception("Not connect");
      }

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
        print(responseBody);
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
    var request;
    if(noOfEvents.isEmpty){
       request = http.Request('GET', Uri.parse('https://iot.dialog.lk/developer/api/datamgt/v1/user/devicehistory?eventName=$eventName&deviceIds=$deviceIds'
          '&startDate=$startDate:00&endDate=$endDate:00&zoneId=$zoneId&eventParams=$params'));
    }
    else{
      request = http.Request('GET', Uri.parse('https://iot.dialog.lk/developer/api/datamgt/v1/user/devicehistory?eventName=$eventName&deviceIds=$deviceIds'
          '&startDate=$startDate:00&endDate=$endDate:00&noOfEvents=$noOfEvents&zoneId=$zoneId&eventParams=$params'));
    }


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print("in the device history");
    if (response.statusCode == 200) {
      var responseBody=convert.jsonDecode(await response.stream.bytesToString());
      print(responseBody);
      if(responseBody.isNotEmpty) {
        return responseBody;
      }else{
        throw Exception("Not found data for the given device information");
      }
      // print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    throw Exception("Invalid device Information");
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

  Future<Map<String, dynamic>> createDevice({required String tokenType,required String accessToken,required String XIotJwt,required int deviceDefinitionId,
    required String brand,required String type,required String model,required String deviceCategory,required int userId, required int deviceParentId,required String macAddress,
    required String name,required String zoneId}) async {

    var headers = {
      'Authorization': '$tokenType $accessToken',
      'X-IoT-JWT': '$XIotJwt',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://iot.dialog.lk/developer/api/userdevicemgt/v1/devices'));
    request.body = json.encode({
      "deviceDefinitionId": deviceDefinitionId,
      "brand": "$brand",
      "type": "$type",
      "model": "$model",
      "deviceCategory": "$deviceCategory",
      "userId": userId,
      "deviceParentId": deviceParentId,
      "macAddress": "$macAddress",
      "name": "$name",
      "location": null,
      "additionalParams": null,
      "otherParameters": null,
      "featured": false,
      "nonDeletable": false,
      "pullInterval": 0,
      "zoneId": "$zoneId"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
     var responseBody= convert.jsonDecode(await response.stream.bytesToString());
    print(responseBody);
    return responseBody;


  }
  Future<dynamic> createScene({required String tokenType,required String accessToken,required String XIotJwt,required var body}) async {
    var headers = {
      'Authorization': '$tokenType $accessToken',
      'X-IoT-JWT': '$XIotJwt',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    print("in the createScene");
    var request = http.Request('POST', Uri.parse('https://iot.dialog.lk/developer/api/userscenemgt/v1/scenes'));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // var responseBody= convert.jsonDecode(await response.stream.bytesToString());
    // return responseBody;
    if (response.statusCode == 201||response.reasonPhrase=="created") {
      print("created scene in createscene api call::::");
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print("error in createscene api call::::");
    print(response.reasonPhrase);
    return false;
    }
  }

  Future<dynamic> getDevices({required String tokenType,required String accessToken,required String XIotJwt}) async {
    var headers = {
      'Authorization': '$tokenType $accessToken',
      'X-IoT-JWT': '$XIotJwt',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    var request = http.Request('GET', Uri.parse('https://iot.dialog.lk/developer/api/userdevicemgt/v1/devices'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseBody= convert.jsonDecode(await response.stream.bytesToString());
      return responseBody;
    }
    else {
    throw Exception("Devices request failed");
    }
  }
  Future<dynamic> getScenes({required String tokenType,required String accessToken,required String XIotJwt}) async {
    var headers = {
      'Authorization': '$tokenType $accessToken',
      'X-IoT-JWT': '$XIotJwt',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('https://iot.dialog.lk/developer/api/userscenemgt/v1/scenes'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseBody= convert.jsonDecode(await response.stream.bytesToString());
      return responseBody;
    }
    else {
      throw Exception("Scene request failed");
    }

  }
  Future<dynamic> getEvents({required String tokenType,required String accessToken,required String XIotJwt,required String deviceId}) async {
    var headers = {
      'Authorization': '$tokenType $accessToken',
      'X-IoT-JWT': '$XIotJwt',
      'Accept': 'application/json'
    };

    var request = http.Request('GET', Uri.parse('https://iot.dialog.lk/developer/api/userdevicemgt/v1/devices/$deviceId/events'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.reasonPhrase);
    var responseBody= convert.jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      return responseBody;
    }else if(responseBody["errorCode"] == 1000){
      throw Exception(responseBody["desc"]);
    }
    else {
    throw Exception("Get events request fail");
    }

  }
Future<dynamic> getActions({required String tokenType,required String accessToken,required String XIotJwt,required String deviceId}) async {
    var headers = {
      'Authorization': '$tokenType $accessToken',
      'X-IoT-JWT': '$XIotJwt',
      'Accept': 'application/json'
    };

    var request = http.MultipartRequest('GET', Uri.parse('https://iot.dialog.lk/developer/api/userdevicemgt/v1/devices/$deviceId/actions'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.reasonPhrase);
    var responseBody= convert.jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      return responseBody;
    }else if(responseBody["errorCode"] == 1000){
      throw Exception(responseBody["desc"]);
    }
    else {
    throw Exception("Get actions request fail");
    }

  }

}
