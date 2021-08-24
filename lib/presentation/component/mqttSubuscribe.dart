
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/MODEL/SubscribeMessage.dart';
import 'package:iot_device_simulator/logic/MQTT/Data/MqttAPI.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/presentation/component/mqttStreamReader.dart';


class MqttSubscribe extends StatefulWidget {
  // const MqttSubscribe({Key key}) : super(key: key);

  @override
  _MqttSubscribeState createState() => _MqttSubscribeState();
}
TextEditingController topic =TextEditingController();
TextEditingController message = TextEditingController();
int count=0;

var items=List<String>.generate(100, (index) => 'Item $index');

class _MqttSubscribeState extends State<MqttSubscribe> {

  @override
  Widget build(BuildContext context) {

    return BlocListener<ConnetionBloc,ConsState>(
      listener:(context,state){
        if(state is ConnectionSelectedState){
          setState(() {
            SubscribeMessage.messages.clear();
            topic.clear();
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                hintMaxLines: 2,
                filled: true,
                fillColor: Colors.black26,
                border:OutlineInputBorder(
                  borderSide:BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Topic',
              ),
              controller: topic,
            ),
            SizedBox(height: 20,),
            BlocBuilder<MqttBloc,MqttState>(
                builder:(context,state){
                  if(state is MqttSubscribeTopicState)
                    return ElevatedButton(
                        style:ElevatedButton.styleFrom(
                            padding:EdgeInsets.symmetric(horizontal:30,vertical:20)
                        ),
                        onPressed: (){
                          BlocProvider.of<MqttBloc>(context).add(MqttUnsubscribeEvent(topic.text));
                          setState(() {
                            SubscribeMessage.messages.clear();
                          });

                        },
                        child:Text('Unsubscribe')
                    );
                  else if(state is MqttDisconnectedState|| state is MqttClientNotClickState)
                    return ElevatedButton(
                        style:ElevatedButton.styleFrom(
                            padding:EdgeInsets.symmetric(horizontal:30,vertical:20)
                        ),
                        onPressed:null,
                        child:Text('Subscribe')
                    );
                  else
                    return ElevatedButton(
                        style:ElevatedButton.styleFrom(
                            padding:EdgeInsets.symmetric(horizontal:30,vertical:20)
                        ),
                        onPressed: (){
                          BlocProvider.of<MqttBloc>(context).add(MqttSubscribeEvent(topic.text));

                        },
                        child:Text('Subscribe')
                    );
                }
            ),
            SizedBox(height: 40,),
            Container(
              height: 300,
                color: Colors.black12,
                child: StreamReader()
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                style:ElevatedButton.styleFrom(
                    padding:EdgeInsets.symmetric(horizontal:20,vertical:10)
                ),
                onPressed: (){
                  setState(() {
                    SubscribeMessage.messages.clear();
                  });

                },
                child:Text('clear')
            ),

          ],
        ),
      ),
    );
  }
}
