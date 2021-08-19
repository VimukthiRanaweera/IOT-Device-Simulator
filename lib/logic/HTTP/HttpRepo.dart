import 'package:http/http.dart' as http;
import 'package:iot_device_simulator/logic/MQTT/randomDataCubit.dart';
class HttpRepo{
  late int code;

  Future<int> postHttp(message,url) async {
    var client = http.Client();
    try {
      var uriResponse = await client.post(Uri.parse('http://$url'), body:message);
      print(uriResponse.statusCode);
      print(uriResponse.body);
      code=uriResponse.statusCode;
    }
    finally {
      client.close();
    }
    return code;
  }

  Future<int> multiplePost(message,url,count,time) async {

    var client = http.Client();
    try {
      for(int i=0;i<count;i++) {
        await Future.delayed(Duration(seconds:time),() async {
          final randomData=new RandomDataState(dataString:message);
          randomData.setData();
          var uriResponse = await client.post(
              Uri.parse('http://$url'), body: randomData.dataString);
          print(uriResponse.statusCode);
          print(uriResponse.body);
          code = uriResponse.statusCode;
        });

      }
    }
    finally {
      client.close();
    }
    return code;
  }


}
