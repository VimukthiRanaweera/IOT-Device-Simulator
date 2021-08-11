
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/MQTT/mqttConCubit.dart';
import 'package:iot_device_simulator/logic/MQTT/mqttSubscribeCubit.dart';

class MqttSubscribe extends StatefulWidget {
  // const MqttSubscribe({Key key}) : super(key: key);

  @override
  _MqttSubscribeState createState() => _MqttSubscribeState();
}
TextEditingController topic =TextEditingController();
TextEditingController message = TextEditingController();
int count=0;

class _MqttSubscribeState extends State<MqttSubscribe> {

  @override
  Widget build(BuildContext context) {

    message.text="Message\n";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.end,
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
          ElevatedButton(
              style:ElevatedButton.styleFrom(
                  padding:EdgeInsets.symmetric(horizontal:30,vertical:20)
              ),
              onPressed: (){
                 BlocProvider.of<MqttConCubit>(context).state.subscribe(topic.text);

              },
              child:Text('Subscribe')
          ),
          SizedBox(height: 40,),
          BlocBuilder<MqttConCubit,MqttConState>(
            builder:(context,state) {

                 return Text(
                state.subMessage
                );

             // return Container(
             //    constraints: BoxConstraints(maxHeight: 400),
             //    child: SingleChildScrollView(
             //      child: TextField(
             //        maxLines: null,
             //        enabled: false,
             //        decoration: InputDecoration(
             //          filled: true,
             //          fillColor: Colors.black12,
             //          hintText: 'Message',
             //          disabledBorder: OutlineInputBorder(
             //            borderSide: BorderSide(
             //                color: Colors.black38, width: 1.0),
             //          ),
             //        ),
             //        controller: state.messageControl,
             //      ),
             //    ),
             //  );
            }
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              style:ElevatedButton.styleFrom(
                  padding:EdgeInsets.symmetric(horizontal:20,vertical:10)
              ),
              onPressed: (){
                count++;
                BlocProvider.of<MqttSubscribeCubit>(context).setSub(count);
              },
              child:Text('clear')
          ),

        ],
      ),
    );
  }
}
