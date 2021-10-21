import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/MODEL/apiParaControllers.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateBloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';
import 'package:iot_device_simulator/presentation/component/ApiCreateDevice.dart';
import 'package:iot_device_simulator/presentation/component/ApiDevices.dart';

import 'component/ApiCreateScene.dart';

class ApiAitomation extends StatefulWidget {
  const ApiAitomation() : super();

  @override
  _ApiAitomationState createState() => _ApiAitomationState();
}

List<ApiParaControllers> actionParamList = [new ApiParaControllers()];

final GlobalKey<FormState> formKey = GlobalKey();

final TextEditingController formXSecret = new TextEditingController();
final TextEditingController formUsername = new TextEditingController();
final TextEditingController formPassword = new TextEditingController();
final TextEditingController formEventName = new TextEditingController();
final TextEditingController formDeviceIDs = new TextEditingController();

final TextEditingController formActionDeviceID = new TextEditingController();
final TextEditingController formActionName = new TextEditingController();
final TextEditingController formTimeInterval = new TextEditingController();
final TextEditingController formNoOfActions = new TextEditingController();

late TextEditingController formStartDate =
    new TextEditingController(text: DateTime.now().toString());
late TextEditingController formEndDate =
    new TextEditingController(text: DateTime.now().toString());
final TextEditingController formNoOfEvents = new TextEditingController();
final TextEditingController formZoneId = new TextEditingController();
final TextEditingController formEventParams = new TextEditingController();
String zoneidvalue = "Asia/Colombo";
ScrollController actionScrollController = new ScrollController();
ScrollController eventScrollController = new ScrollController();
SingingCharacter character = SingingCharacter.event;
bool isCheckLogWrite = false;
String filePath="";

class _ApiAitomationState extends State<ApiAitomation> {
  @override
  void initState() {
    super.initState();
  }
  void removeActionParaList(){
    setState(() {
      actionParamList.removeLast();
    });
  }
  void clearParaList(){
    setState(() {
      actionParamList
          .removeRange(1, actionParamList.length);
      actionParamList[0].para.clear();
      actionParamList[0].value.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ApiAutomateBloc,ApiAutomateState>(
      listener: (context,state){
        if(state is ApiActionSuccessState || state is NotConnectedState){
          setState(() {
            isCheckLogWrite = false;
          });
        }
      },
      child: SingleChildScrollView(
        child: Container(
          padding: !Responsive.isMobile(context)
              ? EdgeInsets.symmetric(horizontal: 60, vertical: 50)
              : EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textField(formXSecret, "X-Secret"),
                SizedBox(
                  height: 40,
                ),
                if (!Responsive.isMobile(context))
                  Row(
                    children: [
                      Expanded(
                        child: textField(formUsername, "Username"),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: passwordTextField(formPassword, "Password"),
                      )
                    ],
                  ),
                if (Responsive.isMobile(context))
                  textField(formUsername, "Username"),
                if (Responsive.isMobile(context))
                  SizedBox(
                    height: 30,
                  ),
                if (Responsive.isMobile(context))
                  passwordTextField(formPassword, "Password"),
                SizedBox(
                  height: 15,
                ),
                if(!Responsive.isMobile(context))
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: radioButton("Explore IDs",SingingCharacter.device)
                      ),
                      Expanded(
                        child:radioButton("Get Events",SingingCharacter.event)
                      ),
                      Expanded(
                        child:radioButton("Execute Actions",SingingCharacter.action)
                      ),
                      Expanded(
                        child:radioButton("Add Devices",SingingCharacter.createDevice)
                      ),
                      Expanded(
                        child:radioButton("Add Scenes",SingingCharacter.createScene)
                      ),
                    ],
                  ),
                ),
                if(Responsive.isMobile(context))
                  Container(
                    height: 170,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(child: radioButton("Explore IDs",SingingCharacter.device)),
                            Expanded(child: radioButton("Get Events",SingingCharacter.event)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: radioButton("Execute Actions",SingingCharacter.action)),
                            Expanded(child: radioButton("Add Devices",SingingCharacter.createDevice)),
                          ],
                        ),

                        radioButton("Add Scenes",SingingCharacter.createScene),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
                if (character == SingingCharacter.event)
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 3),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white10),
                        child: Column(
                          children: [
                            if (!Responsive.isMobile(context))
                              Row(
                                children: [
                                  Expanded(
                                    child: textField(formEventName, "Event Name"),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Expanded(
                                    child: listTextField(formDeviceIDs,
                                        "Device IDs   eg: 24153,58261"),
                                  )
                                ],
                              ),
                            if (Responsive.isMobile(context))
                              textField(formEventName, "Event Name"),
                            if (Responsive.isMobile(context))
                              SizedBox(
                                height: 30,
                              ),
                            if (Responsive.isMobile(context))
                              listTextField(
                                  formDeviceIDs, "Device IDs   eg: 24153,58261"),
                            SizedBox(
                              height: 30,
                            ),
                            if (!Responsive.isMobile(context))
                              Row(
                                children: [
                                  Expanded(child: dateField(formStartDate, "Start")),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Expanded(child: dateField(formEndDate, "End")),
                                ],
                              ),
                            if (Responsive.isMobile(context))
                              dateField(formStartDate, "Start"),
                            if (Responsive.isMobile(context))
                              SizedBox(
                                height: 30,
                              ),
                            if (Responsive.isMobile(context))
                              dateField(formEndDate, "End"),
                            if (!Responsive.isMobile(context))
                              SizedBox(
                                height: 40,
                              ),
                            if (!Responsive.isMobile(context))
                              Row(
                                children: [
                                  Expanded(child: zoneId()),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Expanded(
                                      child: listTextField(formEventParams,
                                          "Event Params   eg: temp,speed")),
                                ],
                              ),
                            if (Responsive.isMobile(context))
                              SizedBox(
                                height: 30,
                              ),
                            if (Responsive.isMobile(context)) zoneId(),
                            SizedBox(
                              height: 40,
                            ),
                            if (Responsive.isMobile(context))
                              listTextField(
                                  formEventParams, "Event Params   eg: temp,speed"),
                            if (Responsive.isMobile(context))
                              SizedBox(
                                height: 30,
                              ),
                            if (!Responsive.isMobile(context))
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: noOfEventsTextField(
                                          formNoOfEvents, "No Of Events")),
                                  Expanded(
                                      flex: 4,
                                      child: SizedBox(
                                        width: 40,
                                      )),
                                ],
                              ),
                            if (Responsive.isMobile(context))
                              noOfEventsTextField(formNoOfEvents, "No Of Events"),
                          ],
                        ),
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(
                          height: 30,
                        ),
                      if (!Responsive.isMobile(context))
                        SizedBox(
                          height: 40,
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
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical:20)),
                              onPressed: () {
                                formEventName.clear();
                                formEventParams.clear();
                                formNoOfEvents.clear();
                                formDeviceIDs.clear();

                                BlocProvider.of<ApiAutomateBloc>(context)
                                    .add(ClearButtonClickedEvent());
                              },
                              child: Text('Clear')),
                          SizedBox(
                            width: Responsive.isMobile(context) ? 15 : 30,
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
                                              vertical:  20)),
                                      onPressed: () {
                                        if (formKey.currentState!.validate())
                                        BlocProvider.of<ApiAutomateBloc>(context)
                                            .add(EventExportButtonClickedEvent(
                                            xSecret: formXSecret.text,
                                            username: formUsername.text,
                                            password: formPassword.text,
                                            eventName: formEventName.text,
                                            deviceIds: formDeviceIDs.text,
                                            startDate: formStartDate.text,
                                            endDate: formEndDate.text,
                                            zoneId: zoneidvalue,
                                            eventParms: formEventParams.text,
                                            noOfEvents: formNoOfEvents.text));
                                      },
                                      child: Text('Submit'));
                              }),
                        ],
                      ),
                      SizedBox(height: 20,),
                      if(Responsive.isMobile(context))
                        eventMessages(),
                    ],
                  ),
                if (character == SingingCharacter.action)
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 3),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white10),
                        child: Column(
                          children: [
                            if (!Responsive.isMobile(context))
                              Row(
                                children: [
                                  Expanded(
                                    child: textField(formActionDeviceID, "Device ID"),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Expanded(
                                    child: textField(formActionName, "Action Name"),
                                  ),
                                ],
                              ),
                            if (Responsive.isMobile(context))
                              textField(formActionDeviceID, "Device ID"),
                            if (Responsive.isMobile(context))
                              SizedBox(
                                height: 30,
                              ),
                            if (Responsive.isMobile(context))
                              textField(formActionName, "Action Name"),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black38),
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white10),
                                    height: 150.0,
                                    child: parameterBuilder(),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        visualDensity:
                                            VisualDensity.adaptivePlatformDensity,
                                        onPressed: () {
                                          setState(() {
                                            actionParamList.add(new ApiParaControllers());
                                          });
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      IconButton(
                                        visualDensity:
                                            VisualDensity.adaptivePlatformDensity,
                                        onPressed:actionParamList.length >1?removeActionParaList:null,
                                        icon: Icon(Icons.remove),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: numberTextField(
                                      formNoOfActions, "No of Actions"),
                                ),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? 10 : 35,
                                ),
                                Expanded(
                                  child: timeInterval(
                                      formTimeInterval, "Time Interval in seconds"),
                                ),

                                if (!Responsive.isMobile(context))
                                  Expanded(
                                      flex: Responsive.isTablet(context) ? 0 : 2,
                                      child: SizedBox(
                                        width: 10,
                                      )),

                                if (!Responsive.isMobile(context))
                                logSaveCheckBox(),
                                if (!Responsive.isMobile(context))
                                SizedBox(
                                  width: 10,
                                ),
                                if (!Responsive.isMobile(context))
                                Text("Save Logs"),

                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (Responsive.isMobile(context))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  logSaveCheckBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Save Logs"),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(!Responsive.isMobile(context))
                            actionMessages(),
                          if (!Responsive.isMobile(context))
                            SizedBox(
                              width: 30,
                            ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical:20)),
                              onPressed: () {
                                formActionName.clear();
                                formActionDeviceID.clear();
                                formNoOfActions.clear();
                                formTimeInterval.clear();
                                clearParaList();
                                BlocProvider.of<ApiAutomateBloc>(context)
                                    .add(ClearButtonClickedEvent());
                              },
                              child: Text('Clear')),
                          SizedBox(
                            width: Responsive.isMobile(context) ? 15 : 30,
                          ),
                          BlocBuilder<ApiAutomateBloc, ApiAutomateState>(
                              builder: (context, state) {
                                if (state is ApiCallingState) {
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25,
                                              vertical: 20)),
                                      onPressed: null,
                                      child: Text('Execute'));
                                }else if(state is ApiCallingState){
                                  return CircularProgressIndicator();
                                }
                                else
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25,
                                              vertical: 20)),
                                      onPressed: () {
                                        if (formKey.currentState!.validate())
                                          BlocProvider.of<ApiAutomateBloc>(context)
                                              .add(ActionExportButtonClickedEvent(
                                              formXSecret.text,
                                              formUsername.text,
                                              formPassword.text,
                                              formActionName.text,
                                              formActionDeviceID.text,
                                              int.parse(formNoOfActions.text),
                                              int.parse(formTimeInterval.text),
                                              actionParamList,
                                              isCheckLogWrite,filePath));
                                      },
                                      child: Text('Execute'));
                              }),
                        ],
                      ),
                      SizedBox(height: 20,),
                      if(Responsive.isMobile(context))
                        actionMessages(),
                    ],
                  ),
                if (character == SingingCharacter.createDevice)
                  ApiCreateDevice(XSecret: formXSecret.text, username: formUsername.text, password: formPassword.text),
                if (character == SingingCharacter.createScene)
                  ApiCreateScene(XSecret: formXSecret.text, username: formUsername.text, password: formPassword.text),
                if(character== SingingCharacter.device)
                  ApiDevices(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget logSaveCheckBox(){
    return BlocBuilder<ApiAutomateBloc, ApiAutomateState>(
        builder:(context,state) {
          return AbsorbPointer(
            absorbing: state is ApiCallingState,
            child: Checkbox(
              checkColor: Colors.white,
              activeColor: checkBoxColor,
              value: isCheckLogWrite,
              onChanged: (bool? value) async {
                setState(() {
                  isCheckLogWrite = value!;
                });
                if (isCheckLogWrite) {
                  String? result = await FilePicker
                      .platform
                      .saveFile(
                      dialogTitle: "Select a path",
                    type: FileType.custom,
                    allowedExtensions: ['.CSV']
                  );
                  print(result);
                  if (result != null) {
                    filePath = result;
                  }
                  else {
                    setState(() {
                      isCheckLogWrite = false;
                    });
                  }
                }
              },
            ),
          );
        }
    );
  }
  Widget actionMessages(){
    return  Container(
      child: BlocBuilder<ApiAutomateBloc, ApiAutomateState>(
          builder: (context, state) {
            if (state is ApiCallingState)
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  eventMessageBox("Connecting ...", ConnectingColor),
                  SizedBox(
                      width: Responsive.isMobile(context)
                          ? 15
                          : 30),
                  CircularProgressIndicator(),
                ],
              );
            else if (state is ApiActionSuccessState)
              return actionMessageBox(
                  state.message, Colors.green);
            else if (state is NotConnectedState)
              return eventMessageBox("Error!", Colors.red);
            else {
              return Container();
            }
          }),
    );
  }

  Widget eventMessages(){
    return  Container(
      child: BlocBuilder<ApiAutomateBloc, ApiAutomateState>(
          builder: (context, state) {
            if (state is ApiCallingState)
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  eventMessageBox("Connecting ...",ConnectingColor),
                  SizedBox(
                      width: Responsive.isMobile(context)
                          ? 15
                          : 30),
                  CircularProgressIndicator(),
                ],
              );
            else if (state is ApiCallSuccessState)
              return eventMessageBox("Success", Colors.green);
            else if (state is ApiEventErrorState)
              return eventMessageBox("${state.error}", Colors.red);
            else {
              return Container();
            }
          }),
    );
  }

  Widget eventMessageBox(String message, Color color) {
    return Container(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 8 : 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: SingleChildScrollView(
          controller:eventScrollController,
          scrollDirection: Axis.horizontal,
          child: Text(
            message,
            style: TextStyle(color: color),
          )),
    );
  }

  Widget actionMessageBox(String message, Color color) {
    return Container(
      width: 350,
      height:45,
      padding: EdgeInsets.only(top: 5,left: 5,right: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: Scrollbar(
        controller: actionScrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
            controller: actionScrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Last Action: "),
                Text(
                  message,
                  style: TextStyle(color: color),
                ),
              ],
            )),
      ),
    );
  }

  Widget textField(controller, name) {
    return Container(
      child: TextFormField(
        maxLines: 2,
        minLines: 1,
        decoration: InputDecoration(
          filled: true,
          fillColor: TextFieldColour,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
      ),
    );
  }
  Widget noOfEventsTextField(controller, name) {
    return Container(
      child: TextFormField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintMaxLines: 1,
          filled: true,
          fillColor: TextFieldColour,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          hintText: name,
        ),
        controller: controller,
      ),
    );
  }

  Widget dateField(controller, label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          color: Colors.black12,
          borderRadius: BorderRadius.circular(5)),
      child: DateTimePicker(
        style: TextStyle(fontSize: 15),
        type: DateTimePickerType.dateTimeSeparate,
        timePickerEntryModeInput: true,
        use24HourFormat: true,
        dateMask: 'd MMM, yyyy',
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        icon: Icon(Icons.event),
        dateLabelText: '$label Date',
        timeLabelText: "Hour",
        controller: controller,
        validator: (val) {
          print(val);
          return null;
        },
      ),
    );
  }

  Widget listTextField(controller, name) {
    return Container(
      decoration: BoxDecoration(
          color: TextFieldColour,
          borderRadius: BorderRadius.circular(TextBoxRadius)),
      child: TextFormField(
        maxLines: 2,
        minLines: 1,

        decoration: InputDecoration(
          // filled: true,
          // fillColor: TextFieldColour,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
          ),
          hintText: name,
        ),
        controller: controller,
        validator: (text) {
          if (text!.isEmpty) {
            return 'Cannot be empty';
          }
        },
      ),
    );
  }

  Widget passwordTextField(controller, name) {
    return Container(
      child: TextFormField(
        keyboardType:TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
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
        onSaved: (text) {},
      ),
    );
  }

  Widget numberTextField(controller, name) {
    return Container(
      child: TextFormField(
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
        onSaved: (text) {},
      ),
    );
  }
  Widget timeInterval(controller, name) {
    return Container(
      child: TextFormField(
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
          }else if(int.parse(text)<10){
            return 'Should be >10';
          }
        },
        onSaved: (text) {},
      ),
    );
  }

  Widget zoneId() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          color: TextFieldColour,
          borderRadius: BorderRadius.circular(TextBoxRadius)),
      child: DropdownButton<String>(
        underline:SizedBox(),
        isExpanded: true,
        value: zoneidvalue,
        onChanged: (String? newValue) {
          setState(() {
            zoneidvalue = newValue!;
          });
        },
        items: <String>[
          'Asia/Colombo',
          'Asia/Jakarta',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget parameterBuilder() {
    return ListView.builder(
        itemCount: actionParamList.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: textField(actionParamList[index].para, "Para")),
                    SizedBox(
                      width:Responsive.isMobile(context) ? 10 : 40,
                    ),
                    Expanded(child: textField(actionParamList[index].value, "Value")),
                  ],
                ),
                SizedBox(height: Responsive.isMobile(context) ? 15 : 15),
              ],
            ),
          );
        });
  }

  Widget radioButton(String name,select){
    return ListTile(
      title:Text(name),
      leading: Radio<SingingCharacter>(
        activeColor:checkBoxColor,
        value: select,
        groupValue: character,
        onChanged: (SingingCharacter? value) {
          setState(() {
            character = value!;
          });
        },
      ),
    );
  }
}
