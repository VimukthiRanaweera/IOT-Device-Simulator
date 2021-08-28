import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateBloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';
import 'package:iot_device_simulator/logic/CreateCSVFile.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';

class ApiAitomation extends StatefulWidget {
  const ApiAitomation() : super();

  @override
  _ApiAitomationState createState() => _ApiAitomationState();
}
final GlobalKey<FormState> _formKey = GlobalKey();
final TextEditingController formXscrete= new TextEditingController();
final TextEditingController formUsername= new TextEditingController();
final TextEditingController formPassword= new TextEditingController();
final TextEditingController formEventName= new TextEditingController();
final TextEditingController formDeviceIDs= new TextEditingController();
late TextEditingController formStartDate = new TextEditingController(text: DateTime.now().toString());
 late TextEditingController formEndDate = new TextEditingController(text: DateTime.now().toString());
final TextEditingController formNoOfEvents= new TextEditingController();
final TextEditingController formZoneId= new TextEditingController();
final TextEditingController formEventParams= new TextEditingController();
String zoneidvalue ="Asia/Colombo";
class _ApiAitomationState extends State<ApiAitomation> {
  @override
  void initState() {
    super.initState();


  }
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        padding:!Responsive.isMobile(context)?EdgeInsets.symmetric(horizontal: 80,vertical:50):EdgeInsets.symmetric(horizontal: 30,vertical:20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textField(formXscrete,"X Screte"),
              SizedBox(height: 40,),
              if(!Responsive.isMobile(context))
              Row(
                children: [
                  Expanded(child:textField(formUsername, "Username"), ),
                  SizedBox(width: 40,),
                  Expanded(child: passwordTextField(formPassword, "Password"),)
                ],
              ),
              if(Responsive.isMobile(context))
              textField(formUsername, "Username"),
              if(Responsive.isMobile(context))
              SizedBox(height: 30,),
              if(Responsive.isMobile(context))
              passwordTextField(formPassword, "Password"),
              SizedBox(height: 40,),

              if(!Responsive.isMobile(context))
              Row(
                children: [
                  Expanded(child:textField(formEventName, "Event Name"), ),
                  SizedBox(width: 40,),
                  Expanded(child: listTextField(formDeviceIDs, "Device IDs"),)
                ],
              ),

              if(Responsive.isMobile(context))
              textField(formEventName, "Event Name"),
              if(Responsive.isMobile(context))
              SizedBox(height: 30,),
              if(Responsive.isMobile(context))
              listTextField(formDeviceIDs, "Device IDs"),
              SizedBox(height: 30,),

              if(!Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(child: dateField(formStartDate,"Start") ),
                    SizedBox(width: 40,),
                    Expanded(child: dateField(formEndDate,"End")),
                  ],
                ),

              if(Responsive.isMobile(context))
                dateField(formStartDate,"Start"),
              if(Responsive.isMobile(context))
              SizedBox(height: 30,),
              if(Responsive.isMobile(context))
                dateField(formEndDate,"End"),

              if(!Responsive.isMobile(context))
              SizedBox(height: 40,),

              if(!Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(child:zoneId()),
                    SizedBox(width: 40,),
                    Expanded(child: listTextField(formEventParams, "Event Params")),
                  ],
                ),
              if(Responsive.isMobile(context))
              SizedBox(height: 30,),
              if(Responsive.isMobile(context))
              zoneId(),
              SizedBox(height: 40,),
              if(Responsive.isMobile(context))
              listTextField(formEventParams, "Event Params"),
              if(Responsive.isMobile(context))
              SizedBox(height: 30,),

              if(!Responsive.isMobile(context))
              Row(
                children: [
                  Expanded(flex:1,child:numberTextField(formNoOfEvents, "No Of Events")),
                  Expanded(flex:4,child: SizedBox(width: 40,)),
                ],
              ),

              if(Responsive.isMobile(context))
              numberTextField(formNoOfEvents, "No Of Events"),
              if(Responsive.isMobile(context))
              SizedBox(height: 30,),
              if(!Responsive.isMobile(context))
              SizedBox(height: 40,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<ApiAutomateBloc,ApiAutomateState>(
                      builder:(context,state){
                        if(state is ApiCallingState)
                          return Row(
                            children: [
                              messageBox("Connecting ...",Colors.blue),
                              SizedBox(width:Responsive.isMobile(context)?15:30),
                              CircularProgressIndicator(),
                            ],
                          );
                        else if(state is ApiCallSuccessState)
                          return  messageBox("Success",Colors.green);
                        else if(state is NotConnectedState)
                          return messageBox("Error!",Colors.red);
                        else{
                          return  Container(
                            padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                            decoration:BoxDecoration( border: Border.all(color:Colors.black26,width: 1,),),
                            child: Text(""),
                          );
                        }
                      }
                  ),
                  if(!Responsive.isMobile(context))
                  SizedBox(width: 30,),
                  if(Responsive.isMobile(context))
                    SizedBox(width: 15,),
                  ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal:Responsive.isMobile(context)?18:20, vertical: Responsive.isMobile(context)?18:20)
                      ),
                      onPressed: (){
                        print(formStartDate.text);
                        print(formEndDate.text);
                        print(zoneidvalue);
                      },
                      child:Text('Clear')
                  ),


                    SizedBox(width:Responsive.isMobile(context)?15:30,),
                  BlocBuilder<ApiAutomateBloc,ApiAutomateState>(
                    builder:(context,state) {
                      if(state is ApiCallingState){
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal:Responsive.isMobile(context)?15:20, vertical: Responsive.isMobile(context)?15:20)
                            ),
                            onPressed:null,
                            child: Text('Submit')
                        );
                      }
                      else
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal:Responsive.isMobile(context)?18:20, vertical: Responsive.isMobile(context)?18:20)
                          ),
                          onPressed: () {
                            print(formXscrete.text);
                            BlocProvider.of<ApiAutomateBloc>(context).add(
                                ExportButtonClickedEvent(
                                    xSecret: formXscrete.text,
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
                          child: Text('Submit')
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget messageBox(String message,Color color){
    return  Container(
      padding: EdgeInsets.all(Responsive.isMobile(context)?8:10),
      decoration:BoxDecoration( border: Border.all(color:color,width: 3,),),
      child: Text(message,style: TextStyle(color: color),),
    );
  }

  Widget textField(controller,name) {
    return TextFormField(
      decoration: InputDecoration(
        hintMaxLines: 1,
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText:name,
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
  Widget dateField( controller,label) {
    return DateTimePicker(
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
      onSaved: (val) {
      },
    );
  }
  Widget listTextField(controller,name) {
    return TextFormField(
      decoration: InputDecoration(
        hintMaxLines: 1,
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText:name,
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
  Widget passwordTextField(controller,name) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintMaxLines: 1,
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText:name,
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
  Widget numberTextField(controller,name) {
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
        hintText:name,
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
  Widget zoneId(){
    return  DropdownButton<String>(
      value:zoneidvalue,
      onChanged: (String? newValue) {
        setState(() {
          zoneidvalue = newValue!;
        });
      },
      items:<String>['Asia/Colombo','Asia/Jakarta',].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
