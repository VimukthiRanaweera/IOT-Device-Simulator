import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/MQTT/mqttConnectionManager.dart';
import 'package:iot_device_simulator/logic/checkConCubit.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';
import 'package:iot_device_simulator/logic/mqttConnectionCubit.dart';
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
          DropdownButton<String>(
            value:dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                BlocProvider.of<ProtocolCubit>(context).SetProtocol(dropdownValue);
              });
            },
            items:<String>['MQTT','HTTP','CoAP'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
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
          BlocBuilder<CheckConCubit,CheckConState>
            (builder:(context,state){
            if (state.isconnected)
              return ElevatedButton(
                style:ElevatedButton.styleFrom(
                  primary:Colors.green,
                ),
                onPressed: () async {
                 await BlocProvider.of<MqttConnectionCubit>(context).state.mqttConnectionManager.Disconnect();
                    BlocProvider.of<CheckConCubit>(context).CheckConnection(false);

                },
                child: Text('Disconnect'),
              );
            else {
             return ElevatedButton(
                style:ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () async {

                  MqttConnectionManager con =MqttConnectionManager(BlocProvider.of<ConnectionCubit>(context).state.brokerAddress,
                      BlocProvider.of<ConnectionCubit>(context).state.port, BlocProvider.of<ConnectionCubit>(context).state.username,
                      BlocProvider.of<ConnectionCubit>(context).state.password);
                  BlocProvider.of<MqttConnectionCubit>(context).setPublishDetails(con);
                  await BlocProvider.of<MqttConnectionCubit>(context).state.mqttConnectionManager.connectDevice();
                  if(BlocProvider.of<MqttConnectionCubit>(context).state.mqttConnectionManager.client.connectionStatus!.state ==MqttConnectionState.connected) {
                    BlocProvider.of<CheckConCubit>(context).CheckConnection(true);
                  }
                  else{
                    print('Not Connect');
                  }

                },
                child: Text('Connect'),
              );

            }

          },
          ),

        ],
      ),
    );
  }
}
