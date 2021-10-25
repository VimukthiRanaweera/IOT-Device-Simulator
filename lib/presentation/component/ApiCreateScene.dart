
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateBloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';


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
bool isNotSelectFile=false;
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
          // if (Responsive.isMobile(context))
            Container(
              padding:EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 3),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(filePath.isNotEmpty?filePath:"Select Device List CSV File",style:TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.end,)),
                  selectFileButton(),
                ],
              ),
            ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!Responsive.isMobile(context))
                Expanded(flex:Responsive.isTablet(context)?1:2,child: Container()),
              if(!Responsive.isMobile(context))
                eventMessages(),
                SizedBox(
                  width: 30,
                ),
              BlocBuilder<ApiAutomateBloc, ApiAutomateState>(
                  builder: (context, state) {
                    if (state is ApiCallingState) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal:20,
                                  vertical: 20)),
                          onPressed: null,
                          child: Text('Submit'));
                    } else
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 20)),
                          onPressed: () {
                            if(formKey.currentState!.validate())
                            if(filePath.isNotEmpty) {
                              BlocProvider.of<ApiAutomateBloc>(context).add(ApiAddSceneEvent(formXSecret.text, formUsername.text, formPassword.text, filePath));
                            }else{
                              setState(() {
                                isNotSelectFile=true;
                              });
                            }


                          },
                          child: Text('Submit'));
                  }
              ),
            ],
          ),
          SizedBox(height: 20,),
          if(Responsive.isMobile(context))
            eventMessages(),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  messageBox("Connecting ...", ConnectingColor),
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
              );
            }
          }),
    );
  }
  Widget messageBox(String message, Color color) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      height:45,
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
  Widget selectFileButton(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed:() async {

            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['CSV'],
            );
            if(result != null) {

              File file = File(result.files.single.path!);
              print(file.path);

              setState(() {
                filePath=file.path;
                isNotSelectFile=false;
              });

            } else {
              // User canceled the picker
            }
          },
          icon:Icon(Icons.upload_file,color:filePath.isNotEmpty?Colors.green:Colors.blue,),
        ),
        if(isNotSelectFile)
          Text("File not select",style:TextStyle(color:Colors.red)),
      ],
    );
  }

}
