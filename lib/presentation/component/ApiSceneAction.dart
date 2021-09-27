import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';

class ApiSceneAction extends StatefulWidget {
  const ApiSceneAction() : super();

  @override
  _ApiSceneActionState createState() => _ApiSceneActionState();
}
ApiSceneActionCharacter _character = ApiSceneActionCharacter.device;
final TextEditingController formActionDeviceId = new TextEditingController();
final TextEditingController formActionEventName = new TextEditingController();
final TextEditingController formActionPhoneNO = new TextEditingController();
final TextEditingController formActionPhoneMessage = new TextEditingController();
final TextEditingController formActionEmailAddress = new TextEditingController();
final TextEditingController formActionEmailSubject = new TextEditingController();
final TextEditingController formActionEmailBody = new TextEditingController();
String globalAction ="Select a Global Action";
class _ApiSceneActionState extends State<ApiSceneAction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Device'),
                  leading: Radio<ApiSceneActionCharacter>(
                    value:ApiSceneActionCharacter.device,
                    groupValue: _character,
                    onChanged: (ApiSceneActionCharacter? value) {
                      setState(() {
                        _character = value!;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('Global'),
                  leading: Radio<ApiSceneActionCharacter>(
                    value:ApiSceneActionCharacter.global,
                    groupValue: _character,
                    onChanged: (ApiSceneActionCharacter? value) {
                      setState(() {
                        _character = value!;
                      });
                    },
                  ),
                ),
              ),
              if(!Responsive.isMobile(context))
              Expanded(flex: 2,child: Container())
            ],
          ),
          SizedBox(height: 15,),
          if(_character==ApiSceneActionCharacter.device)
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(!Responsive.isMobile(context))
                  Row(
                    children: [
                      Expanded(child: numberTextField(formActionDeviceId, "Device Id")),
                      SizedBox(width: 40,),
                      Expanded(child: textField(formActionEventName, "Event Name")),
                    ],
                  ),
                  if(Responsive.isMobile(context))
                    numberTextField(formActionDeviceId, "Device Id"),
                  if(Responsive.isMobile(context))
                    SizedBox(height: 30,),
                  if(Responsive.isMobile(context))
                    textField(formActionEventName, "Event Name"),
                ],
              ),
            ),
          if(_character==ApiSceneActionCharacter.global)
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    globalActionSelectBox(),
                  SizedBox(height: 20,),
                  if(globalAction=="sms")
                  Container(
                    child:Column(
                      children: [
                        if(!Responsive.isMobile(context))
                          Row(
                            children: [
                              Expanded(child: numberTextField(formActionPhoneNO,"Phone Number")),
                              SizedBox(width: 40,),
                              Expanded(child: textField(formActionPhoneMessage,"Message")),

                            ],
                          ),
                        if(Responsive.isMobile(context))
                          numberTextField(formActionPhoneNO,"Phone Number"),
                        if(Responsive.isMobile(context))
                          SizedBox(height: 30,),
                        if(Responsive.isMobile(context))
                          textField(formActionPhoneMessage,"Message"),
                      ],
                    ),
                  ),
                  if(globalAction=="email")
                  Container(
                    child:Column(
                      children: [
                        if(!Responsive.isMobile(context))
                          Row(
                            children: [
                              Expanded(child: textField(formActionEmailAddress,"Email Address")),
                              SizedBox(width: 40,),
                              Expanded(child: textField(formActionPhoneMessage,"Subject")),

                            ],
                          ),
                        if(Responsive.isMobile(context))
                          textField(formActionEmailAddress,"Email Address"),
                        if(Responsive.isMobile(context))
                          SizedBox(height: 30,),
                        if(Responsive.isMobile(context))
                          textField(formActionPhoneMessage,"Subject"),
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Expanded(child: textField(formActionEmailSubject,"Subject")),
                            if(!Responsive.isMobile(context))
                            SizedBox(width: 40,),
                            if(!Responsive.isMobile(context))
                             Expanded(child:Container()),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
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
  Widget globalActionSelectBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<String>(
        value: globalAction,
        onChanged: (String? newValue) {
          setState(() {
            globalAction = newValue!;
          });
        },
        items: <String>[
          'Select a Global Action',
          'sms',
          'email',
          'callurl',
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
