import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/logic/COAP/coapApi.dart';
import 'package:iot_device_simulator/presentation/component/automateSendData.dart';

import '../Responsive.dart';

class CoapBody extends StatefulWidget {
  // const CoapBody({Key key}) : super(key: key);

  @override
  _CoapBodyState createState() => _CoapBodyState();
}
CoapApi api = CoapApi();
class _CoapBodyState extends State<CoapBody> {
  late String dropdownValueCOAP='GET';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    DropdownButton<String>(
                      value:dropdownValueCOAP,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValueCOAP = newValue!;
                        });
                      },
                      items:<String>['GET','POST',].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintMaxLines: 1,
                          filled: true,
                          fillColor: Colors.black26,
                          border:OutlineInputBorder(
                            borderSide:BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: 'URL',
                        ),
                      ),
                    ),
                    SizedBox(width: 30,),
                    if(dropdownValueCOAP=="GET")
                    ElevatedButton(
                        style:ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                        ),
                        onPressed: (){

                        },
                        child:Text('Send')
                    ),
                  ],
                ),
                SizedBox(height: 60,),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
                    border:OutlineInputBorder(
                      borderSide:BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Message',
                  ),
                ),
                SizedBox(height: 30,),
                if(dropdownValueCOAP=='POST')
                ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                    ),
                    onPressed: (){
                      print('Connect');

                      api.connect("127.0.0.1",8890,'{"eventName":"action01","status":"online","para":"111","id":"20210902"}');
                    },
                    child:Text('Send')
                ),
                SizedBox(height:20,),
                SizedBox(height:20,),
                if(Responsive.isMobile(context) && dropdownValueCOAP=='POST')
                  AutomateSendData(),
              ],
            ),
          ),

          if(!Responsive.isMobile(context) && dropdownValueCOAP=='POST')
          Expanded(
            flex: 2,
            child: AutomateSendData(),

            ),
        ],
      ),
    );
  }
}
