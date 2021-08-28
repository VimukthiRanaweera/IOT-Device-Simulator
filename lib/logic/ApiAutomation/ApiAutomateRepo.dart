import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
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


}

// var url = Uri.parse(
//     'https://iot.dialog.lk/developer/api/applicationmgt/authenticate');
// var response = await http.get(
//     url, headers: {'X-Secret': xSecret, 'accept': 'application/json'});
// var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
// print(response.body);
// print(jsonResponse['access_token']);
// return jsonResponse;