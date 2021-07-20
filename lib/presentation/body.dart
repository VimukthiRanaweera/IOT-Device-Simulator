import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/presentation/component/mqttPublish.dart';

import 'component/mainTopBar.dart';
import 'component/mqttBody.dart';

class PageBody extends StatefulWidget {
  // const Body({Key key}) : super(key: key);

  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MainTopBar(),
              SizedBox(height: 30.0,),
              MqttBody(),
            ],
           ),
        ),
    );
  }
}
