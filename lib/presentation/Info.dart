import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Responsive.dart';

class Info extends StatefulWidget {
  const Info() : super();

  @override
  _InfoState createState() => _InfoState();
}

String time = "";

class _InfoState extends State<Info> {
  @override
  void initState() {
    var inputFormat = DateFormat("yyyy-MM-dd");
    time = inputFormat.format(DateTime.now()).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: !Responsive.isMobile(context)
              ? EdgeInsets.symmetric(horizontal: 60, vertical: 50)
              : EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Text(
                "IoT Dev Tools",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "This is a free IoT test Tool that provided by Dialog Axiata PLC for simulating IoT devices.\n The IoT Dev Tools Specially designed "
                "fo Communicate with Dialog IoT Portal and automate the Api calls with portal.",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Text("Documentation",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 15,
              ),
              textLink("IoT Dev Tool - Doc"," https://if.dialog.lk/iot-dev-tools/ ‎"),
              SizedBox(
                height: 30,
              ),
              Text("Useful Links",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 15,
              ),
              textLink("if.dialog.lk", "https://if.dialog.lk/"),
              SizedBox(height: 10,),
              textLink("if.dialog.lk/iot", "https://if.dialog.lk/?page_id=7584&preview=true"),
              SizedBox(height: 10,),
              textLink("portal.iot.ideamart.io", "https://portal.iot.ideamart.io/"),
              SizedBox(height: 10,),
              textLink("iotdev.support@dialog.lk", "iotdev.support@dialog.lk"),
              SizedBox(height: 30,),
              Image.asset("images/innovation-foundary-logo-New.png",width: 200,height: 100,fit:BoxFit.contain,),
              // Expanded(child: Spacer()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copyright_outlined),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Dialog Axiata PLC $time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget textLink(text,link){
    return  RichText(
        text: TextSpan(
            text: text,
            style: TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                var url = link;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }));
  }
}
