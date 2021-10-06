
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/MODEL/SubscribeMessage.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/MQTT/writeSubscribeLogFileCubit.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/presentation/component/mqttStreamReader.dart';

import '../Responsive.dart';


class MqttSubscribe extends StatefulWidget {
  // const MqttSubscribe({Key key}) : super(key: key);

  @override
  _MqttSubscribeState createState() => _MqttSubscribeState();
}
TextEditingController topic =TextEditingController();
TextEditingController message = TextEditingController();
TextEditingController responseMessage = TextEditingController();
TextEditingController responseTopic = TextEditingController();
final _formTopicKey = GlobalKey<FormFieldState>();
final GlobalKey<FormState> _formKey = GlobalKey();

bool isCheckedAction=false;
bool isCheckedLogWrite=false;
class _MqttSubscribeState extends State<MqttSubscribe> {

  @override
  Widget build(BuildContext context) {

    return BlocListener<ConnetionBloc,ConsState>(
      listener:(context,state){
        if(state is ConnectionSelectedState){
          setState(() {
            SubscribeMessage.messages.clear();
            topic.clear();
            responseMessage.clear();
            responseTopic.clear();
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:Responsive.isMobile(context)?5:50,vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                key: _formTopicKey,
                decoration: InputDecoration(
                  filled: true,
                  fillColor:TextFieldColour,
                  border:OutlineInputBorder(
                    borderSide:BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Action Response",style:TextStyle(fontWeight: FontWeight.bold),),
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: checkBoxColor,
                        value:isCheckedAction,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedAction = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: 20,),
                  Row(
                    children: [
                      Text("Log Write",style:TextStyle(fontWeight: FontWeight.bold),),
                      BlocBuilder<WriteSubscribeLogFileCubit,WriteSubscribeLogFileState>(
                        builder:(context,state) {
                          return AbsorbPointer(
                            absorbing: false,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: checkBoxColor,
                              // fillColor: MaterialStateProperty.resolveWith(getColor),
                              value:state.isLogWrite,
                              onChanged: (bool? value) async {
                                setState(() {
                                  state.isLogWrite = value!;
                                });
                                if(state.isLogWrite){
                                  String? result = await FilePicker.platform
                                      .getDirectoryPath(
                                      dialogTitle: "Save the File");
                                  print(result);
                                  if(result!=null){
                                    state.filePath=result;
                                  }else{
                                    setState(() {
                                      state.isLogWrite = false;
                                    });
                                  }
                                }
                              },
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ],
              ),
              if(isCheckedAction)
              Container(
                child: Column(
                  children: [

                      SizedBox(height: 20,),
                      TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: TextFieldColour,
                          border:OutlineInputBorder(
                            borderSide:BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
                          ),
                          hintText: 'Action Response Topic',
                        ),
                        controller: responseTopic,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Cannot be empty';
                          }
                        },
                      ),
                    SizedBox(height: 20,),
                    TextFormField(
                      maxLines: 2,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: TextFieldColour,
                        border:OutlineInputBorder(
                          borderSide:BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
                        ),
                        hintText: 'Action Response Message',
                      ),
                      controller: responseMessage,
                      validator: (text) {
                        if (text!.isEmpty) {
                          return 'Cannot be empty';
                        }
                      },
                    ),
                  ],
                ),
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
                    else if(state is MqttDisconnectedState|| state is MqttClientNotClickState || state is MqttClientClickedState || state is MqttConnectingState)
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
                            if(isCheckedAction) {
                              if(_formKey.currentState!.validate())
                              BlocProvider.of<MqttBloc>(context).add(
                                  MqttSubscribeAndResponseEvent(
                                      topic.text,responseMessage.text,responseTopic.text));
                              // BlocProvider.of<WriteSubscribeLogFileCubit>(context).setResponse(responseMessage.text);
                              }
                            else{
                              if(_formTopicKey.currentState!.validate())
                                BlocProvider.of<MqttBloc>(context).add(MqttSubscribeEvent(topic.text));
                              // BlocProvider.of<WriteSubscribeLogFileCubit>(context).setResponse("NO RESPONSE");
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
