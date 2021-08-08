import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';
import 'package:iot_device_simulator/logic/checkConCubit.dart';
import 'package:iot_device_simulator/logic/checkPublishCubit.dart';
import 'package:iot_device_simulator/logic/mqttConnectionCubit.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';
import 'package:iot_device_simulator/presentation/component/automateSendData.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttPublish extends StatefulWidget {
  // const MqttPublish({Key key}) : super(key: key);

  @override
  _MqttPublishState createState() => _MqttPublishState();
}
final GlobalKey<FormState> _formKey = GlobalKey();
TextEditingController topic =TextEditingController();
TextEditingController message = TextEditingController();
class _MqttPublishState extends State<MqttPublish> {

  @override
  Widget build(BuildContext context) {
    return  BlocListener<CheckPublishCubit,CheckPublishState>(
      listener:(context,state) {
        if (state.isPublished)
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Published!'),
                duration: Duration(milliseconds: 500),
              )
          );
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
               BlocBuilder<AutomateCubit,AutomateState>(
                 builder:(context,state) {
                  return ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           padding: EdgeInsets.symmetric(
                               horizontal: 30, vertical: 20)
                       ),
                       onPressed: () async {
                         if (_formKey.currentState!.validate()) {
                           if(state.isChecked) {
                             if(state.setAutoDetails()){
                               for (int i = 0; i < state.count; i++) {
                                 await Future.delayed(Duration(seconds:state.time),(){
                                   BlocProvider
                                       .of<MqttConnectionCubit>(context).state.mqttConnectionManager.Publish(topic.text, message.text);
                                   BlocProvider.of<CheckPublishCubit>(context).CheckPublish(true);
                                 });

                               }

                             }
                           }
                           else{
                             BlocProvider
                                 .of<MqttConnectionCubit>(context)
                                 .state
                                 .mqttConnectionManager
                                 .Publish(topic.text, message.text);
                             BlocProvider.of<CheckPublishCubit>(context)
                                 .CheckPublish(true);
                           }


                         }
                       },
                       child: Text('Publish')
                   );

                 }
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
          Expanded(
            flex: 2,
            child: AutomateSendData(),
          ),
       ]
      ),
    );

  }
}
