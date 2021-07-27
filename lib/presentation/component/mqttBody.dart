
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/presentation/component/mqttPublish.dart';
import 'package:iot_device_simulator/presentation/component/mqttSbuscribe.dart';

import '../../constants/constants.dart';

class MqttBody extends StatefulWidget {
  // const MqttBody({Key key}) : super(key: key);

  @override
  _MqttBodyState createState() => _MqttBodyState();
}
List<bool> isSelected =[true,false];
class _MqttBodyState extends State<MqttBody> {

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Divider(),
              ToggleButtons(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:10,horizontal: 40),
                    child: Text('Publish'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:10,horizontal: 40),
                    child: Text('Subscribe'),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });

                },
                isSelected: isSelected,
                fillColor:appbarColor,
                borderRadius:BorderRadius.all(Radius.circular(10)),
                selectedColor: Colors.white,
              ),
              Divider(),
              SizedBox(height: 20,),
              if(isSelected[0])
                MqttPublish(),

               if(isSelected[1])
                MqttSubscribe(),
            ],
          ),
    );
  }
}
