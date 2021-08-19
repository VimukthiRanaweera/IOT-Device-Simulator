import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/MQTT/mqttConCubit.dart';
import 'package:iot_device_simulator/logic/checkConCubit.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';
import 'package:mqtt_client/mqtt_client.dart';


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
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
              }
            ),
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
              items:<String>['MQTT','HTTP','CoAP'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          BlocBuilder<ProtocolCubit,ProtocolState>(
              builder:(context,state){
                if(state.protocol!="HTTP")
                  return Expanded(
                    child: Row(
                      children: [
                        if(!Responsive.isMobile(context))
                          SizedBox(width: 20,),
                        if(Responsive.isMobile(context))
                          SizedBox(width: 5,),
                        BlocBuilder<ConnectionCubit,ConState>(
                            builder:(context,state){
                              return Expanded(
                                child: Text(state.connectionName,
                                    style: Theme
                                        .of(context)
                                        .textTheme.headline6
                                ),
                              );
                            }
                        ),

                        if(!Responsive.isMobile(context))
                          SizedBox(width: 20,),
                        IconButton(
                          iconSize: 30,
                          icon:Icon(Icons.settings,
                          ),
                          onPressed: (){
                            Navigator.of(context).pushNamed('/newConnection');
                          },
                        ),
                        if(!Responsive.isMobile(context))
                          SizedBox(width: 20,),

                        if(Responsive.isMobile(context))
                          SizedBox(width: 3,),
                        BlocBuilder<MqttBloc,MqttState>
                          (builder:(context,state){
                          if (state is MqttDisconnectedState)
                            return ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () async {

                                BlocProvider.of<MqttBloc>(context).add(MqttConnetEvent(brokerAddress: BlocProvider.of<ConnectionCubit>(context).state.brokerAddress,
                                    port:BlocProvider.of<ConnectionCubit>(context).state.port, username: BlocProvider.of<ConnectionCubit>(context).state.username,
                                    password: BlocProvider.of<ConnectionCubit>(context).state.password));


                                // BlocProvider.of<MqttConCubit>(context).setConnection(BlocProvider.of<ConnectionCubit>(context).state.brokerAddress,
                                //     BlocProvider.of<ConnectionCubit>(context).state.port, BlocProvider.of<ConnectionCubit>(context).state.username,
                                //     BlocProvider.of<ConnectionCubit>(context).state.password, BlocProvider.of<ConnectionCubit>(context).state.keepAlive);

                                // await BlocProvider.of<MqttConCubit>(context).state.connectDevice();
                                // if(BlocProvider.of<MqttConCubit>(context).state.client.connectionStatus!.state ==MqttConnectionState.connected) {
                                //   BlocProvider.of<CheckConCubit>(context).CheckConnection(true);
                                // }
                              },
                              child: Text('Connect'),
                            );
                          else {
                            return ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                primary:Colors.green,
                              ),
                              onPressed: ()  async {
                                BlocProvider.of<MqttBloc>(context).add(MqttDisConnectEvent());
                                // await BlocProvider.of<MqttConCubit>(context).state.Disconnect();
                                // BlocProvider.of<CheckConCubit>(context).CheckConnection(false);
                                // print("Disconnected code is");

                              },
                              child: Text('Disconnect'),
                            );

                          }

                        },
                        ),

                      ],
                    ),
                  );
                else
                  return Container();
              },

          ),


        ],
      ),
    );
  }
}
