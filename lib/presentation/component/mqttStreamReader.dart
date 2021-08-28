
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/MODEL/SubscribeMessage.dart';
import 'package:iot_device_simulator/logic/MQTT/Data/MqttAPI.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';

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
        SubscribeMessage.messages.insert(0, data);
      });
    });
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    _subscription.cancel(); // don't forget to close subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
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
    );
  }
}

