import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/MQTT/mqttConCubit.dart';
import 'package:iot_device_simulator/logic/MQTT/randomDataCubit.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';
import 'package:iot_device_simulator/logic/MQTT/checkPublishCubit.dart';
import 'package:iot_device_simulator/logic/checkConCubit.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';
import 'package:iot_device_simulator/presentation/component/automateSendData.dart';


class MqttPublish extends StatefulWidget {
  // const MqttPublish({Key key}) : super(key: key);

  @override
  _MqttPublishState createState() => _MqttPublishState();
}
final GlobalKey<FormState> _formKey = GlobalKey();
TextEditingController topic =TextEditingController();
TextEditingController message = TextEditingController();
class _MqttPublishState extends State<MqttPublish> {
bool isPublishing=false;
void setPublishing(bool check){
  setState(() {
    isPublishing=check;
  });
}
  @override
  Widget build(BuildContext context) {
  Future<void> _publishButton() async {
    if (_formKey.currentState!.validate()) {
      if (BlocProvider.of<AutomateCubit>(context).state.isChecked) {
        if(BlocProvider.of<AutomateCubit>(context).state.setAutoDetails()) {
          BlocProvider.of<MqttBloc>(context).add(MqttMultiplePublishEvent(count: BlocProvider.of<AutomateCubit>(context).state.count
                  , time: BlocProvider
                      .of<AutomateCubit>(context)
                      .state
                      .time, topic: topic.text, message: message.text));
        }


        // if(BlocProvider.of<AutomateCubit>(context).state.setAutoDetails()) {
        //   for (int i = 0; i < BlocProvider.of<AutomateCubit>(context).state.count; i++) {
        //     await Future.delayed(
        //         Duration(seconds:BlocProvider.of<AutomateCubit>(context).state.time), () {
        //       BlocProvider.of<RandomDataCubit>(context).setRandomValue(message.text);
        //       BlocProvider.of<RandomDataCubit>(context).state.setData();
        //       BlocProvider.of<MqttConCubit>(context).state.Publish(topic.text, BlocProvider.of<RandomDataCubit>(context).state.dataString);
        //     });
        //   }
        // }
      }
      else{
        BlocProvider.of<MqttBloc>(context).add(MqttPublishEvent(topic:topic.text, message:message.text));
      }
    }

  }
    return  BlocListener<MqttBloc,MqttState>(
      listener:(context,state) {
        if (state is MqttPublishedState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success!'),
                duration: Duration(milliseconds: 500),
              )
          );
        }
      },
      child: Row(
        children: [
      Expanded(
        flex: 4,
        child: Form(
          key: _formKey,
          child: Container(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               SizedBox(height:70),
               TextFormField(
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
                 validator: (text){
                   if(text!.isEmpty){
                     return 'Cannot be empty';
                   }
                 },
                ),

               SizedBox(height: 40,),
                  TextFormField(
                    maxLines: 2,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black26,
                        border:OutlineInputBorder(
                          borderSide:BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: 'Message'
                    ),
                    controller: message,
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                  ),
               SizedBox(height:20),
               Row(
                 mainAxisAlignment:MainAxisAlignment.end,
                 children: [
                   BlocBuilder<MqttBloc,MqttState>(
                       builder:(context,state){
                         if(state is MqttPublishingState){
                           return Row(
                             children: [
                               Text("Publishing . . . ",style:TextStyle(fontSize:20,color:Colors.blueAccent),),
                               SizedBox(width:10,),
                               CircularProgressIndicator(),
                               SizedBox(width:10,),
                             ],
                           );

                         }
                         return SizedBox(width:10,);
                       }
                   ),

                   BlocBuilder<MqttBloc,MqttState>(
                     builder:(context,state) {
                      return ElevatedButton(
                           style: ElevatedButton.styleFrom(
                               padding: EdgeInsets.symmetric(
                                   horizontal: 30, vertical: 20)
                           ),
                           onPressed:state is MqttPublishingState? null:_publishButton,
                           child: Text('Publish')

                       );

                     }
                   ),

                 ],
               ),
               SizedBox(height:20,),
               if(Responsive.isMobile(context))
                 AutomateSendData(),
             ],
            ),
          ),
        ),
      ),
          if(!Responsive.isMobile(context))
            SizedBox(width:40,),
          if(!Responsive.isMobile(context))
          Expanded(
            flex: 2,
            child: AutomateSendData(),
          ),
       ]
      ),
    );

  }

  Future<void> _showMyDialog(String message) async{
  return showDialog<void>
    (
      context: context,
      barrierDismissible: true,
      builder:(BuildContext context){
      return AlertDialog(
        title: Text('Alert',style:TextStyle(color:Colors.redAccent,fontWeight:FontWeight.bold),),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(message)
            ],
          ),
        ),
        backgroundColor:primaryColor,
        actions: [
          TextButton(
              onPressed:(){
                Navigator.of(context).pop();

              },
              child:Text("OK",style:TextStyle(fontSize:14,color: Colors.black,fontWeight:FontWeight.bold),)
          ),
        ],
      );
      },
  );

  }

}
