
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:iot_device_simulator/MODEL/SubscribeMessage.dart';
import 'package:iot_device_simulator/logic/MQTT/Data/MqttAPI.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/writeSubscribeLogFileCubit.dart';


import '../Responsive.dart';

class StreamReader extends StatefulWidget {

  @override
  _StreamReaderState createState() => _StreamReaderState();
}

class _StreamReaderState extends State<StreamReader> {

  late StreamSubscription _subscription;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _subscription = MqttAPI.controller.stream.listen((data) {
      setState(() {
        print("in the stream reader class listening>>>>>>>>>>>>");
        SubscribeMessage.messages.insert(0, data);
      });
    });
    scrollController = ScrollController();
  }


  @override
  void dispose() {
    print("cancel Subscription>>>>");
    _subscription.cancel(); // don't forget to close subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MqttBloc,MqttState>(
      listener:(context,state){
        if(state is MqttSubscribeResponsedState){
          var inputFormat =  DateFormat("yyyy-MM-dd HH:mm:ss");
          BlocProvider.of<WriteSubscribeLogFileCubit>(context).state.writeLogMessage(SubscribeMessage.messages[0],state.response,
              inputFormat.format(DateTime.now()).toString());
        }
        else if( state is MqttSubscribeNotResponsedState){
          var inputFormat =  DateFormat("yyyy-MM-dd HH:mm:ss");
          BlocProvider.of<WriteSubscribeLogFileCubit>(context).state.writeLogMessage(SubscribeMessage.messages[0],"NOT RESPONSE",
              inputFormat.format(DateTime.now()).toString());
        }
      },
      child: Scrollbar(
        isAlwaysShown:true,
        thickness: 9,
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
                    itemCount: SubscribeMessage.messages.length,
                    itemBuilder: (context, index) {

                      return Card(
                        child: BlocBuilder<MqttBloc,MqttState>(
                          builder:(context,state){

                            return ListTile(
                              title: Text(SubscribeMessage.messages[index]),
                              tileColor: Colors.black26,
                              trailing: state is MqttSubscribeResponsedState?FittedBox(
                                fit: BoxFit.fill,
                                child: Row(
                                  children: [
                                    Icon(Icons.done,color:Colors.green,size:20,),
                                    SizedBox(width: 5,),
                                    if(Responsive.isMobile(context))
                                    Text("Response \nPublished",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),),
                                    if(!Responsive.isMobile(context))
                                      Text("Response Published",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),),
                                  ],
                                ),
                              ):null,

                            );
                          },
                        ),
                      );
                    }
                ),
      ),
    );
  }
}

