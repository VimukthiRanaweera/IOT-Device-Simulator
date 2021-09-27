

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DevicesList extends StatefulWidget {
  const DevicesList() : super();

  @override
  _DevicesListState createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),

    );
  }
}
