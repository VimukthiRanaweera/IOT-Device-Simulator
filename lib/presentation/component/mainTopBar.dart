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

String qosValue = "0";

class _MainTopBarState extends State<MainTopBar> {
  late String dropdownValue = 'MQTT';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.start,
            children: [
              if(!Responsive.isMobile(context))
                SizedBox(width: 20,),
                protocolDropDown(),

              BlocBuilder<ProtocolCubit, ProtocolState>(
                builder: (context, protocolState) {
                  return Expanded(
                    child: Row(
                      children: [
                        if(!Responsive.isMobile(context))
                          SizedBox(width: 20,),
                        if(Responsive.isMobile(context))
                          SizedBox(width: 5,),
                        BlocBuilder<ConnetionBloc, ConsState>(
                            builder: (context, Connectionstate) {
                              if (protocolState.protocol ==
                                  Connectionstate.superConModel.protocol)
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Text(
                                      Connectionstate.superConModel.connectionName,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1
                                  ),
                                );
                              else {
                                return Container();
                              }
                            }
                        ),
                        Expanded(child: Container()),
                        if(!Responsive.isMobile(context))
                        qosContent(),
                          SizedBox(width: Responsive.isMobile(context)?10:20),
                        if(protocolState.protocol == "MQTT")
                          settingButton(),
                          SizedBox(width: Responsive.isMobile(context) ? 3 : 20,),
                        if(!Responsive.isMobile(context))
                        mqttButton(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          if(Responsive.isMobile(context))
          SizedBox(height: 25,),
          if(Responsive.isMobile(context))
          Row(
            children: [
              qosContent(),
              Expanded(child: Container()),
              mqttButton(),
            ],
          )
        ],
      ),
    );
  }
  Widget mqttButton(){
    return  BlocBuilder<ProtocolCubit, ProtocolState>(
        builder: (context, protocolState) {
          if (protocolState.protocol == 'MQTT')
            return BlocBuilder<MqttBloc, MqttState>
              (builder: (context, state) {
              if (state is MqttClientNotClickState) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15)),
                  onPressed: null,
                  child: Text('Connect'),
                );
              }
              else if (state is MqttDisconnectedState ||
                  state is MqttClientClickedState)
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    primary: Colors.red,
                  ),
                  onPressed: () async {
                    BlocProvider.of<MqttBloc>(context).add(
                        MqttConnetEvent(BlocProvider
                            .of<ConnetionBloc>(context)
                            .state
                            .superConModel, int.parse(qosValue)));
                  },
                  child: Text('Connect'),
                );
              else if (state is MqttConnectingState) {
                return CircularProgressIndicator();
              }
              else {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
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
    );

  }

  Widget qosContent(){
    return BlocBuilder<ProtocolCubit, ProtocolState>(
      builder:(context,state){
        if(state.protocol == 'MQTT') {
          return Container(
              child: Row(
                children: [
                  Text("QOS", style: TextStyle(
                      fontWeight: FontWeight.bold),),
                  SizedBox(width: 5,),
                  qos(),
                ],
              )
          );
        }else{
          return Container();
        }
      },
    );
  }

  Widget qos() {
    return Container(
      height:35,
      padding: EdgeInsets.symmetric(horizontal:10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(TextBoxRadius),
        border: Border.all(color: Colors.black26),
      ),
      child:DropdownButton<String>(
        value:qosValue,
        underline: Container(),
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        onChanged: (String? newValue) {
          setState(() {
            // dropdownValue = newValue!;
            qosValue= newValue!;
          });
        },
        items: <String>['0', '1', '2'].map<
            DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget settingButton() {
    return BlocBuilder<MqttBloc, MqttState>(
        builder: (context, state) {
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
    );
  }
  Widget protocolDropDown(){
    return  Container(
      padding: EdgeInsets.only(left: 10, right: 3),
      height: 40,
      decoration: BoxDecoration(border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(15),
          color: primaryColor),
      child: DropdownButton<String>(
        value: BlocProvider
            .of<ProtocolCubit>(context)
            .state
            .protocol,
        underline: Container(),
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        onChanged: (String? newValue) {
          setState(() {
            // dropdownValue = newValue!;
            BlocProvider.of<ProtocolCubit>(context).SetProtocol(newValue);
          });
        },
        items: <String>['MQTT', 'HTTP', 'CoAP', "TCP"].map<
            DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
