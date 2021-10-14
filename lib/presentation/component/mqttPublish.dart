import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
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
bool isChecked = false;
class _MqttPublishState extends State<MqttPublish> {
void clearText(){
  topic.clear();
  message.clear();
}
  @override
  Widget build(BuildContext context) {
  Future<void> _publishButton() async {
    if (_formKey.currentState!.validate()) {
      if (isChecked) {
        if(BlocProvider.of<AutomateCubit>(context).state.setAutoDetails()) {
          BlocProvider.of<MqttBloc>(context).add(MqttMultiplePublishEvent(count: BlocProvider.of<AutomateCubit>(context).state.count
                  , time: BlocProvider
                      .of<AutomateCubit>(context)
                      .state
                      .time, topic: topic.text, message: message.text));
        }
      }
      else{
        BlocProvider.of<MqttBloc>(context).add(MqttPublishEvent(topic:topic.text, message:message.text));
      }
    }

  }
    return  MultiBlocListener(
      listeners: [
        BlocListener<MqttBloc,MqttState>(
          listener:(context,state) {
            if (state is MqttPublishedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Success!'),
                    duration: Duration(milliseconds: 1000),
                  )
              );
            }
          },
        ),
        BlocListener<ConnetionBloc,ConsState>(
            listener:(context,state){
              if(state is ConnectionSelectedState) {
                clearText();
                setState(() {
                  isChecked=false;
                });
              }
            }
            ),
      ],
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Expanded(
          flex: 4,
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // SizedBox(height:Responsive.isMobile(context)?20:20),
                 SizedBox(height: 45,),
                 TextFormField(
                   maxLines: 2,
                    minLines: 1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: TextFieldColour,
                        border:OutlineInputBorder(
                          borderSide:BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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
                 SizedBox(height: 30,),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: TextFieldColour,
                          border:OutlineInputBorder(
                            borderSide:BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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
                 if(Responsive.isMobile(context))
                 Container(
                   child: Column(
                     children: [
                       SizedBox(height: 20,),
                       Row(
                         children: [
                           Checkbox(
                             checkColor: Colors.white,
                             activeColor: checkBoxColor,
                             value:isChecked,
                             onChanged: (bool? value) {
                               setState(() {
                                 isChecked = value!;
                               });
                             },
                           ),
                           SizedBox(width: 20,),
                           Text("Automate"),
                         ],
                       ),
                         if(isChecked)
                         AutomateSendData(),
                     ],
                   ),
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
                                 Text("Publishing . . . ",style:TextStyle(fontSize:20,color:ConnectingColor),),
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
                             onPressed:(state is MqttPublishingState || state is MqttConnectingState || state is MqttDisconnectedState || state is MqttClientNotClickState || state is MqttClientClickedState)? null:_publishButton,
                             child: Text('Publish')

                         );

                       }
                     ),

                   ],
                 ),

               ],
              ),
            ),
          ),
        ),
            SizedBox(width: 20,),
            if(!Responsive.isMobile(context))
            Expanded(
              flex: isChecked?2:1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: checkBoxColor,
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value:isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        SizedBox(width: 20,),
                        Text("Automate"),
                      ],
                    ),
                    SizedBox(height:12),
                    if(isChecked)
                      AutomateSendData(),
                  ],
                ),
              ),
            ),
         ]
        ),
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
