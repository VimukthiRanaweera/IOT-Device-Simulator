import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';



import '../Responsive.dart';

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(!Responsive.isMobile(context))
          SizedBox(width: 20,),
          Container(
            padding: EdgeInsets.only(left:10,right:3),
            height: 40,
            decoration: BoxDecoration(border: Border.all(color:Colors.black38),borderRadius:BorderRadius.circular(15),color:primaryColor),
            child: DropdownButton<String>(
              value:BlocProvider.of<ProtocolCubit>(context).state.protocol,
              underline: Container(),
              icon:Icon(Icons.keyboard_arrow_down_rounded),
              onChanged: (String? newValue) {
                setState(() {
                  // dropdownValue = newValue!;
                  BlocProvider.of<ProtocolCubit>(context).SetProtocol(newValue);
                });
              },
              items:<String>['MQTT','HTTP','CoAP',"TCP"].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          BlocBuilder<ProtocolCubit,ProtocolState>(
              builder:(context,protocolState){

                  return Expanded(
                    child: Row(
                      children: [
                        if(!Responsive.isMobile(context))
                          SizedBox(width: 20,),
                        if(Responsive.isMobile(context))
                          SizedBox(width: 5,),
                        BlocBuilder<ConnetionBloc,ConsState>(
                            builder:(context,Connectionstate){
                              if(protocolState.protocol==Connectionstate.superConModel.protocol)
                              return Container(
                                padding: EdgeInsets.all(10),
                                decoration:BoxDecoration(border: Border.all(color:Colors.black38),color:secondaryColor,borderRadius:BorderRadius.circular(15)),
                                child: Text(Connectionstate.superConModel.connectionName,
                                    style: Theme
                                        .of(context)
                                        .textTheme.bodyText1
                                ),
                              );
                              else{
                                return Text("${protocolState.protocol} Client");
                              }
                            }
                        ),
                        Expanded(child: Container()),
                        if(!Responsive.isMobile(context))
                          SizedBox(width: 20,),
                        if(protocolState.protocol=="MQTT")
                        BlocBuilder<MqttBloc,MqttState>(
                          builder:(context,state) {
                            return AbsorbPointer(
                              absorbing: state is MqttConnectedState,
                              child: IconButton(
                                iconSize: 30,
                                icon: Icon(Icons.settings,
                                ),
                                onPressed: () {
                                  BlocProvider.of<ConnetionBloc>(context).add(
                                      ClickedSettingEvent(BlocProvider
                                          .of<ConnetionBloc>(context)
                                          .state
                                          .superConModel));
                                  Navigator.of(context).pushNamed(
                                      '/newConnection');
                                },
                              ),
                            );
                          }
                        ),
                        if(!Responsive.isMobile(context))
                          SizedBox(width: 20,),

                        if(Responsive.isMobile(context))
                          SizedBox(width: 3,),

                        BlocBuilder<ProtocolCubit,ProtocolState>(
                          builder:(context,protocolState) {
                            if(protocolState.protocol=='MQTT')
                            return BlocBuilder<MqttBloc, MqttState>
                              (builder: (context, state) {
                              if (state is MqttClientNotClickState)
                               {
                                return ElevatedButton(
                                  onPressed: null,
                                  child: Text('Connect'),
                                );
                              }
                              else if (state is MqttDisconnectedState ||
                                  state is MqttClientClickedState)
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  onPressed: () async {
                                    BlocProvider.of<MqttBloc>(context).add(
                                        MqttConnetEvent(BlocProvider
                                            .of<ConnetionBloc>(context)
                                            .state
                                            .superConModel));
                                  },
                                  child: Text('Connect'),
                                );
                              else if (state is MqttConnectingState) {
                                return CircularProgressIndicator();
                              }
                              else {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: () async {
                                    BlocProvider.of<MqttBloc>(context).add(
                                        MqttDisConnectEvent());
                                  },
                                  child: Text('Disconnect'),
                                );
                              }
                            },
                            );
                            else
                              return Container();
                          }
                        ),

                      ],
                    ),
                  );

              },

          ),


        ],
      ),
    );
  }
}
