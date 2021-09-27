import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/presentation/component/ApiSceneAction.dart';

import '../Responsive.dart';

class ApiByDevice extends StatefulWidget {
  const ApiByDevice() : super();

  @override
  _ApiByDeviceState createState() => _ApiByDeviceState();
}

final TextEditingController formEventName = new TextEditingController();
final TextEditingController formDeviceId = new TextEditingController();
final TextEditingController formPara = new TextEditingController();
final TextEditingController formValue = new TextEditingController();

String logic = "<";
bool isState = false;

class _ApiByDeviceState extends State<ApiByDevice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context))
            Row(
              children: [
                Expanded(
                  child: numberTextField(formDeviceId, "Device ID"),
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: textField(formEventName, "Event Name"),
                )
              ],
            ),
          if (Responsive.isMobile(context))
            numberTextField(formDeviceId, "Device ID"),
          if (Responsive.isMobile(context))
            SizedBox(
              height: 30,
            ),
          if (Responsive.isMobile(context))
            textField(formEventName, "Event Name"),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  title: const Text(
                    'State',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: isState,
                  onChanged: (bool value) {
                    setState(() {
                      isState = value;
                    });
                  },
                ),
              ),
              if (!Responsive.isMobile(context))
                Expanded(
                    child: SizedBox(
                  width: 10,
                )),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          if (!isState)
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: textField(formPara, "Para")),
                      if (!Responsive.isMobile(context))
                        SizedBox(
                          width: 40,
                        ),
                      if (Responsive.isMobile(context))
                        SizedBox(
                          width: 15,
                        ),
                      logicSelectBox(),
                      if (!Responsive.isMobile(context))
                        SizedBox(
                          width: 40,
                        ),
                      if (Responsive.isMobile(context))
                        SizedBox(
                          width: 15,
                        ),
                      Expanded(child: textField(formValue, "Value")),
                    ],
                  )
                ],
              ),
            ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Text(
                "Action",
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(child: Container()),
            ],
          ),
          ApiSceneAction(),
        ],
      ),
    );
  }

  Widget textField(controller, name) {
    return TextFormField(
      decoration: InputDecoration(
        hintMaxLines: 1,
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: name,
      ),
      controller: controller,
      validator: (text) {
        if (text!.isEmpty) {
          return 'Cannot be empty';
        }
      },
    );
  }

  Widget numberTextField(controller, name) {
    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintMaxLines: 1,
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: name,
      ),
      controller: controller,
      validator: (text) {
        if (text!.isEmpty) {
          return 'Cannot be empty';
        }
      },
      onSaved: (text) {},
    );
  }

  Widget logicSelectBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<String>(
        value: logic,
        onChanged: (String? newValue) {
          setState(() {
            logic = newValue!;
          });
        },
        items: <String>[
          '<',
          '>',
          '<=',
          '>=',
          '==',
          '!=',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
