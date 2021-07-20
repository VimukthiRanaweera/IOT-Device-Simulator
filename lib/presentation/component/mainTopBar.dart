import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';
import 'package:iot_device_simulator/presentation/mqttNewConnectionPage.dart';

class MainTopBar extends StatefulWidget {
  // const MainTopBar({Key key}) : super(key: key);

  @override
  _MainTopBarState createState() => _MainTopBarState();
}

class _MainTopBarState extends State<MainTopBar> {
  late String dropdownValue='MQTT';
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:BoxConstraints(minWidth: 400),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value:dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items:<String>['MQTT','HTTP','CoAP'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // if(!Responsive.isMobile(context))
            SizedBox(width: 20,),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                  fillColor: Colors.black26,
                  border:OutlineInputBorder(
                    borderSide:BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Connection Name'
              ),
            ),
          ),
          // if(!Responsive.isMobile(context))
          SizedBox(width: 20,),
          IconButton(
            iconSize: 30,
            icon:Icon(Icons.settings,
            ),
            onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder:(_){
                  return MqttNewConnectionPage();
                }
                ));
            },
          ),
          // if(!Responsive.isMobile(context))
            SizedBox(width: 20,),
          ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            onPressed: () { },
            child: Text('Connect'),
          ),
          SizedBox(width: 10,),
          ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: () { },
            child: Text('Disconnect'),
          ),

        ],
      ),
    );
  }
}
