import 'package:http/http.dart' as http;
import 'package:iot_device_simulator/logic/MQTT/randomDataCubit.dart';
class HttpRepo{


  Future<int> postHttp(message,url) async {
   int code=0;
    var client = http.Client();
    try {
      var uriResponse = await client.post(Uri.parse('http://$url'), body:message);
      print(uriResponse.statusCode);
      print(uriResponse.body);
      code=uriResponse.statusCode;
      if(code==200){
        return code;
      }
      else {
        throw Exception();
      }

    }
    finally {
      client.close();
    }

  }

  Future<int> multiplePost(message,url,count,time) async {
     int code=0;
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
          if(code!=200){
            throw Exception();
          }
        });

      }
    }
    finally {
      client.close();
    }
    return code;
  }


}
