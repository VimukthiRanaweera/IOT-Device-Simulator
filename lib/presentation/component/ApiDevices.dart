import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateBloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';

import '../ApiAutomation.dart';
import '../Responsive.dart';

class ApiDevices extends StatefulWidget {
  const ApiDevices() : super();

  @override
  _ApiDevicesState createState() => _ApiDevicesState();
}
final _formkeyDeviceID = GlobalKey<FormFieldState>();
final TextEditingController deviceId = new TextEditingController();
String selectItem="Get Devices";
class _ApiDevicesState extends State<ApiDevices> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 3),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              if(!Responsive.isMobile(context))
              Row(
                children: [
                  selectDevice(),
                  SizedBox(width: 30,),
                  if(selectItem=='Get Device Events'|| selectItem =='Get Device Actions')
                  Expanded(child: numberTextField(deviceId,"Device ID")),
                  Expanded(flex:2,child: Container())
                ],
              ),
              if(Responsive.isMobile(context))
              selectDevice(),
              if(Responsive.isMobile(context))
                SizedBox(height: 30,),
              if(Responsive.isMobile(context))
                Row(
                  children: [
                    if(selectItem=='Get Device Events'|| selectItem =='Get Device Actions')
                      Expanded(child: numberTextField(deviceId,"Device ID")),
                  ],
                ),
              SizedBox(height: 30,),

            ],
          ),
        ),
        SizedBox(
          height:Responsive.isMobile(context)?30: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(!Responsive.isMobile(context))
              eventMessages(),
            if (!Responsive.isMobile(context))
              SizedBox(
                width: 30,
              ),
            if (Responsive.isMobile(context))
              SizedBox(
                width: 15,
              ),
            BlocBuilder<ApiAutomateBloc, ApiAutomateState>(
                builder: (context, state) {
                  if (state is ApiCallingState) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical:20)),
                        onPressed: null,
                        child: Text('Submit'));
                  } else
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 20)),
                        onPressed: () {

                          if(selectItem=='Get Devices') {
                            if(formKey.currentState!.validate())
                              BlocProvider.of<ApiAutomateBloc>(context).add(
                                  ApiGetDevicesEvent(formXSecret.text,
                                      formUsername.text, formPassword.text));
                          }else if(selectItem=='Get Scenes'){
                            if(formKey.currentState!.validate())
                              BlocProvider.of<ApiAutomateBloc>(context).add(
                                  ApiGetScenesEvent(formXSecret.text,
                                      formUsername.text, formPassword.text));
                          }
                          else if(selectItem == "Get Device Events"){
                            if(formKey.currentState!.validate())
                              if(_formkeyDeviceID.currentState!.validate())
                                BlocProvider.of<ApiAutomateBloc>(context).add(ApiGetDeviceEventsEvent(formXSecret.text,
                                    formUsername.text, formPassword.text,deviceId.text));
                          }
                          else if(selectItem == "Get Device Actions"){
                            if(formKey.currentState!.validate())
                              if(_formkeyDeviceID.currentState!.validate())
                                BlocProvider.of<ApiAutomateBloc>(context).add(ApiGetDeviceActionsEvent(formXSecret.text,
                                    formUsername.text, formPassword.text,deviceId.text));
                          }

                        },
                        child: Text('Submit'));
                }
            ),
          ],
        ),
      ],
    );
  }
  Widget selectDevice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<String>(
        underline: SizedBox(),
        value:selectItem,
        onChanged: (String? newValue) {
          setState(() {
            selectItem = newValue!;

          });
          BlocProvider.of<ApiAutomateBloc>(context).add( ClearButtonClickedEvent());
        },
        items: <String>[
          'Get Devices',
          'Get Device Events',
          'Get Device Actions',
          'Get Scenes',

        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget eventMessages(){
    return  Container(
      child: BlocBuilder<ApiAutomateBloc, ApiAutomateState>(
          builder: (context, state) {
            if (state is ApiCallingState)
              return Row(
                children: [
                  messageBox("Connecting ...", ConnectingColor),
                  SizedBox(
                      width: Responsive.isMobile(context)
                          ? 15
                          : 30),
                  CircularProgressIndicator(),
                ],
              );
            else if (state is ApiExploreIdsSuccessed)
              return messageBox("Success", Colors.green);
            else if (state is ApiExploreIDsErrorState)
              return messageBox("${state.error}", Colors.red);
            else {
              return Container(
              );
            }
          }),
    );
  }
  Widget messageBox(String message, Color color) {
    return Container(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 8 : 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            message,
            style: TextStyle(color: color),
          )),
    );
  }
  Widget numberTextField(controller, name) {
    return TextFormField(
      key: _formkeyDeviceID,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintMaxLines: 1,
        filled: true,
        fillColor: TextFieldColour,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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

}
