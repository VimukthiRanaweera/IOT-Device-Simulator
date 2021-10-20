

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
    var inputFormat = DateFormat("yyyy");
    time = inputFormat.format(DateTime.now()).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: !Responsive.isMobile(context)
              ? EdgeInsets.symmetric(horizontal: 80, vertical: 50)
              : EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: Responsive.isMobile(context)?CrossAxisAlignment.center:CrossAxisAlignment.start,
            children: [
              Text(
                "IoT Dev Tools v1.0",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "'IoT Dev Tools' is a free software developed by Dialog Axiata PLC to test, simulate and "
                "automate IoT devices and plugins at Dialog IoT platforms ",style:TextStyle(fontSize: 15),
                textAlign: Responsive.isMobile(context)?TextAlign.center:TextAlign.start
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: leftDetails(),
                      ),
                      if(!Responsive.isMobile(context))
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        width: 20,
                      ),
                      if(!Responsive.isMobile(context))
                      Expanded(
                        child: rightDetails(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if(Responsive.isMobile(context))
                    rightDetails(),
                  SizedBox(
                    height: 30,
                  ),
                  copyRight(),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget leftDetails() {
    return Container(
      child: Column(
        crossAxisAlignment: Responsive.isMobile(context)?CrossAxisAlignment.center:CrossAxisAlignment.start,
        children: [
          Text(
            "Contact for Developer Support",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: Responsive.isMobile(context)?MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              Icon(Icons.email),
              SizedBox(
                width: 5,
              ),
              textLink("iotdev.support@dialog.lk", "iotdev.support@dialog.lk"),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "IoT Developer Portal Login",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: Responsive.isMobile(context)?MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              Icon(Icons.link_outlined),
              SizedBox(
                width: 5,
              ),
              textLink(
                  "portal.iot.ideamart.io", "https://portal.iot.ideamart.io/"),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "IoT Documentation",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: Responsive.isMobile(context)?MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              Icon(Icons.link_outlined),
              SizedBox(
                width: 5,
              ),
              textLink("docs.iot.ideamart.io",
                  "https://docs.iot.ideamart.io/docs/1.0/iot-developer-portal"),
            ],
          ),
        ],
      ),
    );
  }

  Widget rightDetails() {
    return Container(
      child: Column(
        crossAxisAlignment: Responsive.isMobile(context)?CrossAxisAlignment.center:CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            "images/innovation-foundary-logo-New.png",
            width: 200,
            height: 100,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: Responsive.isMobile(context)?MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              Icon(Icons.link_outlined),
              SizedBox(
                width: 5,
              ),
              textLink("if.dialog.lk/iot", "https://if.dialog.lk/iot"),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: Responsive.isMobile(context)?MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              Icon(Icons.link_outlined),
              SizedBox(
                width: 5,
              ),
              textLink("if.dialog.lk/iot-dev-tools",
                  " https://if.dialog.lk/iot-dev-tools/ ‎"),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget copyRight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$time ",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 2,
        ),
        Icon(Icons.copyright_outlined,),
        SizedBox(
          width: 2,
        ),
        Text("Dialog Axiata PLC", style: TextStyle(fontWeight:FontWeight.w600))
      ],
    );
  }

  Widget textLink(text, link) {
    return RichText(
        text: TextSpan(
            text: text,
            style: TextStyle(
                fontSize: 15,
              color: Colors.black87
               ),
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
