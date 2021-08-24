
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/MODEL/SubscribeMessage.dart';
import 'package:iot_device_simulator/logic/MQTT/Data/MqttAPI.dart';

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
        // SubscribeMessage.messages.add(data);
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
                      child: ListTile(
                        title: Text(SubscribeMessage.messages[index]),
                        tileColor: Colors.black26,
                      ),
                    );
                  }
              ),
    );
  }
}

