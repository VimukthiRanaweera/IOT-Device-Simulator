import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:iot_device_simulator/MODEL/apiParaControllers.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateBloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/writeActionFileCubit.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';

class ApiAitomation extends StatefulWidget {
  const ApiAitomation() : super();

  @override
  _ApiAitomationState createState() => _ApiAitomationState();
}

List<ApiParaControllers> paramList = [new ApiParaControllers()];

final GlobalKey<FormState> _formKey = GlobalKey();

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
ScrollController scrollController = new ScrollController();
SingingCharacter _character = SingingCharacter.event;

class _ApiAitomationState extends State<ApiAitomation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: !Responsive.isMobile(context)
            ? EdgeInsets.symmetric(horizontal: 60, vertical: 50)
            : EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Form(
          key: _formKey,
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
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('EVENT'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.event,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('ACTION'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.action,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              if (_character == SingingCharacter.event)
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
                                child: numberTextField(
                                    formNoOfEvents, "No Of Events")),
                            Expanded(
                                flex: 4,
                                child: SizedBox(
                                  width: 40,
                                )),
                          ],
                        ),
                      if (Responsive.isMobile(context))
                        numberTextField(formNoOfEvents, "No Of Events"),
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
                                      horizontal: Responsive.isMobile(context)
                                          ? 18
                                          : 20,
                                      vertical: Responsive.isMobile(context)
                                          ? 18
                                          : 20)),
                              onPressed: () {},
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
                                          horizontal:
                                              Responsive.isMobile(context)
                                                  ? 15
                                                  : 20,
                                          vertical: Responsive.isMobile(context)
                                              ? 15
                                              : 20)),
                                  onPressed: null,
                                  child: Text('Submit'));
                            } else
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Responsive.isMobile(context)
                                                  ? 18
                                                  : 20,
                                          vertical: Responsive.isMobile(context)
                                              ? 18
                                              : 20)),
                                  onPressed: () {
                                    print(formXSecret.text);
                                    BlocProvider.of<ApiAutomateBloc>(context)
                                        .add(ExportButtonClickedEvent(
                                            xSecret: formXSecret.text,
                                            username: formUsername.text,
                                            password: formPassword.text,
                                            eventName: formEventName.text,
                                            deviceIds: formDeviceIDs.text,
                                            startDate: formStartDate.text,
                                            endDate: formEndDate.text,
                                            zoneId: zoneidvalue,
                                            eventParms: formEventParams.text,
                                            noOfEvents: int.parse(
                                                formNoOfEvents.text)));
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
                ),
              if (_character == SingingCharacter.action)
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
                                Ink(
                                  padding: EdgeInsets.all(12),
                                  decoration: const ShapeDecoration(
                                    color: primaryColor,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    hoverColor: secondaryColor,
                                    onPressed: () {
                                      setState(() {
                                        paramList.add(new ApiParaControllers());
                                      });
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Ink(
                                  padding: EdgeInsets.all(12),
                                  decoration: const ShapeDecoration(
                                    color: primaryColor,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    hoverColor: secondaryColor,
                                    onPressed: () {
                                      setState(() {
                                        paramList.removeLast();
                                      });
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
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
                                formTimeInterval, "Time Interval"),
                          ),
                          SizedBox(
                            width: Responsive.isMobile(context) ? 10 : 40,
                          ),
                          Expanded(
                            child: numberTextField(
                                formNoOfActions, "No of Actions"),
                          ),
                          if (!Responsive.isMobile(context))
                            Expanded(
                                flex: Responsive.isTablet(context) ? 1 : 3,
                                child: SizedBox(
                                  width: 20,
                                )),
                          Text("Log Write"),
                          SizedBox(
                            width: 10,
                          ),
                          BlocBuilder<WriteActionFileCubit,
                              WriteActionFileState>(builder: (context, state) {
                            return Checkbox(
                              checkColor: Colors.white,
                              value: state.isCheckLogWrite,
                              onChanged: (bool? value) {
                                setState(() {
                                  state.isCheckLogWrite = value!;
                                });
                              },
                            );
                          }),
                        ],
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
                                      horizontal: Responsive.isMobile(context)
                                          ? 20
                                          : 20,
                                      vertical: Responsive.isMobile(context)
                                          ? 18
                                          : 20)),
                              onPressed: () {
                                var inputFormat =  DateFormat("yyyy-MM-dd HH:mm:ss");
                                print(inputFormat.format(DateTime.now()));
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
                                          horizontal:
                                              Responsive.isMobile(context)
                                                  ? 25
                                                  : 20,
                                          vertical: Responsive.isMobile(context)
                                              ? 15
                                              : 20)),
                                  onPressed: null,
                                  child: Text('Export'));
                            } else
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Responsive.isMobile(context)
                                                  ? 20
                                                  : 20,
                                          vertical: Responsive.isMobile(context)
                                              ? 18
                                              : 20)),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate())
                                      BlocProvider.of<ApiAutomateBloc>(context)
                                          .add(ActionExportButtonClickedEvent(
                                              formXSecret.text,
                                              formUsername.text,
                                              formPassword.text,
                                              formActionName.text,
                                              formActionDeviceID.text,
                                              int.parse(formNoOfActions.text),
                                              int.parse(formTimeInterval.text),
                                              paramList,
                                              BlocProvider.of<
                                                          WriteActionFileCubit>(
                                                      context)
                                                  .state
                                                  .isCheckLogWrite));
                                  },
                                  child: Text('Export'));
                          }),
                        ],
                      ),
                      SizedBox(height: 20,),
                      if(Responsive.isMobile(context))
                        actionMessages(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  Widget actionMessages(){
    return  Container(
      child: BlocBuilder<ApiAutomateBloc, ApiAutomateState>(
          builder: (context, state) {
            if (state is ApiCallingState)
              return Row(
                children: [
                  messageBox("Connecting ...", Colors.blue),
                  SizedBox(
                      width: Responsive.isMobile(context)
                          ? 15
                          : 30),
                  CircularProgressIndicator(),
                ],
              );
            else if (state is ApiActionSuccessState)
              return successMessageBox(
                  state.message, Colors.green);
            else if (state is NotConnectedState)
              return messageBox("Error!", Colors.red);
            else {
              return Container(
                height: 45,
                width: 120,
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                child: Text(''),
              );
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
                children: [
                  messageBox("Connecting ...", Colors.blue),
                  SizedBox(
                      width: Responsive.isMobile(context)
                          ? 15
                          : 30),
                  CircularProgressIndicator(),
                ],
              );
            else if (state is ApiCallSuccessState)
              return messageBox("Success", Colors.green);
            else if (state is NotConnectedState)
              return messageBox("Error!", Colors.red);
            else {
              return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 50, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                child: Text(""),
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

  Widget successMessageBox(String message, Color color) {
    return Container(
      width: 400,
      height:45,
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
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
      onSaved: (text) {},
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
          borderRadius: BorderRadius.circular(10)),
      child: DateTimePicker(
        type: DateTimePickerType.dateTimeSeparate,
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
        onSaved: (val) {},
      ),
    );
  }

  Widget listTextField(controller, name) {
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
      onSaved: (text) {},
    );
  }

  Widget passwordTextField(controller, name) {
    return TextFormField(
      // inputFormatters: [FilteringTextInputFormatter.allow("[+w]")],
      obscureText: true,
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

  Widget zoneId() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<String>(
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
        itemCount: paramList.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: textField(paramList[index].para, "Para")),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(child: textField(paramList[index].value, "Value")),
                  ],
                ),
                SizedBox(height: Responsive.isMobile(context) ? 15 : 15),
              ],
            ),
          );
        });
  }
}
