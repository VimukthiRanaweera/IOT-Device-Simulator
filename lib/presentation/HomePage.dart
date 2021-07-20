import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';

import 'body.dart';
import 'component/drawerConList.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String dropdownValue='MQTT';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerConList(),
      appBar:AppBar(
        title: Text("Dialog Iot Simulator"),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if(Responsive.isDesktop(context))
            Expanded(
                child: drawerConList(),
            ),
            Expanded(
              flex: 4,
              child:PageBody()

            ),
          ],
        ),
      ),
    );
  }
}
