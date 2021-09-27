
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateBloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ReadSceneList.dart';

import '../ApiAutomation.dart';
import '../Responsive.dart';

class ApiCreateScene extends StatefulWidget {
  const ApiCreateScene({Key? key,required this.XSecret,required this.username,required this.password}) : super(key: key);
  final String username;
  final  String password;
  final String XSecret;
  @override
  _ApiCreateSceneState createState() => _ApiCreateSceneState();
}
String filePath = "";
final TextEditingController formSceneName = new TextEditingController();
class _ApiCreateSceneState extends State<ApiCreateScene> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ApiAutomateBloc,ApiAutomateState>(
      listener: (context,state){
        if(state is ApiSceneCreateMessageState){
          _showMyDialog(state.notCreateSceneList, state.noOfScene);
        }
      },
      child: Column(
        children: [
          SizedBox(height: 20,),
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
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['CSV'],
                    );
                    if(result != null) {
                      File file = File(result.files.single.path!);
                      print(file.path);
                      filePath=file.path;
                    }

                  },
                  child: Text('Select CSV File')),
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
                                      : 25,
                                  vertical: Responsive.isMobile(context)
                                      ? 18
                                      : 20)),
                          onPressed: () {
                            if(filePath.isNotEmpty) {
                              print(filePath);
                              print(formXSecret.text);
                              print(formUsername.text);
                              print(formPassword.text);
                              if(formKey.currentState!.validate())
                              BlocProvider.of<ApiAutomateBloc>(context).add(ApiAddSceneEvent(formXSecret.text, formUsername.text, formPassword.text, filePath));
                            }


                          },
                          child: Text('Submit'));
                  }
              ),
            ],
          ),
        ],
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
                  messageBox("Connecting ...", Colors.blue),
                  SizedBox(
                      width: Responsive.isMobile(context)
                          ? 15
                          : 30),
                  CircularProgressIndicator(),
                ],
              );
            else if (state is ApiSceneCreatedState)
              return messageBox("Success", Colors.green);
            else if (state is ApiSceneErrorState)
              return messageBox("${state.error}", Colors.red);
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
  Future<void> _showMyDialog(List notCreateList,int noOfDevices) async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:(BuildContext context){
        int createdList=(noOfDevices - notCreateList.length);
        return AlertDialog(
          title: Text('Scenes Create Summery',style:TextStyle(color:Colors.black87,fontWeight:FontWeight.bold),),
          content: Container(
            width: double.minPositive,
            height: notCreateList.isEmpty?80:300,
            child: Column(
              children: [
                Text("$createdList out of $noOfDevices scenes were created successfully",style:TextStyle(color:Colors.green,fontWeight:FontWeight.w600),),
                if(notCreateList.isNotEmpty)
                  SizedBox(height: 20,),
                if(notCreateList.isNotEmpty)
                  Text("Not Created Scenes Names",style:TextStyle(fontWeight:FontWeight.w500),),
                SizedBox(height: 10,),
                if(notCreateList.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54, width: 1),
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white10),
                    height: 180,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: notCreateList.length,
                        itemBuilder:(context,index){
                          return Container(
                            child: Row(
                              children: [
                                Text("${notCreateList[index]}",style:TextStyle(color:Colors.red,fontWeight: FontWeight.w400),),
                                SizedBox(height: 5,),
                                // Text(notCreateList.keys[index])
                              ],
                            ),
                          );
                        }
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed:(){
                  Navigator.of(context).pop();
                },
                child:Text("OK",style:TextStyle(fontSize:14,color:Colors.blue,fontWeight:FontWeight.bold),)
            ),
          ],
        );
      },
    );

  }

  // Widget typeSelectBox() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //         border: Border.all(color: Colors.black38),
  //         color: Colors.black12,
  //         borderRadius: BorderRadius.circular(10)),
  //     child: DropdownButton<String>(
  //       value:sceneType,
  //       onChanged: (String? newValue) {
  //         setState(() {
  //           sceneType = newValue!;
  //         });
  //       },
  //       items: <String>[
  //         'Select Type',
  //         'By Device',
  //         'By Time',
  //       ].map<DropdownMenuItem<String>>((String value) {
  //         return DropdownMenuItem(
  //           value: value,
  //           child: Text(value),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
}
