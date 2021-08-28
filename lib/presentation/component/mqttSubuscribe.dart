
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/MODEL/SubscribeMessage.dart';
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
TextEditingController responseMessage = TextEditingController();
final _formTopicKey = GlobalKey<FormFieldState>();
final GlobalKey<FormState> _formKey = GlobalKey();

bool isChecked=false;
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                key: _formTopicKey,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  border:OutlineInputBorder(
                    borderSide:BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Topic',
                ),
                controller: topic,
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Cannot be empty';
                  }
                },
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Text("Response",style:TextStyle(fontWeight: FontWeight.bold),),
                  Checkbox(
                    checkColor: Colors.white,
                    // fillColor: MaterialStateProperty.resolveWith(getColor),
                    value:isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                ],
              ),
              if(isChecked)
              SizedBox(height: 20,),
              if(isChecked)
                TextFormField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
                    border:OutlineInputBorder(
                      borderSide:BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Response Message',
                  ),
                  controller: responseMessage,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Cannot be empty';
                    }
                  },
                ),
              SizedBox(height: 20,),
              BlocBuilder<MqttBloc,MqttState>(
                  builder:(context,state){
                    if(state is MqttSubscribeTopicState || state is MqttSubscribeResponsedState || state is MqttSubscribeNotResponsedState)
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
                            if(isChecked) {
                              if(_formKey.currentState!.validate())
                              BlocProvider.of<MqttBloc>(context).add(
                                  MqttSubscribeAndResponseEvent(
                                      topic.text,responseMessage.text));
                              }
                            else{
                              if(_formTopicKey.currentState!.validate())
                                BlocProvider.of<MqttBloc>(context).add(MqttSubscribeEvent(topic.text));
                            }


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
      ),
    );
  }
}
