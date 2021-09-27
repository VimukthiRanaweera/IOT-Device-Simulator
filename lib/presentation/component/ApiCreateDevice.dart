
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateBloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';

import '../ApiAutomation.dart';
import '../Responsive.dart';

class ApiCreateDevice extends StatefulWidget {


  const ApiCreateDevice({Key? key,required this.XSecret,required this.username,required this.password}) : super(key: key);

  final String username;
  final  String password;
  final String XSecret;
  @override
  _ApiCreateDeviceState createState() => _ApiCreateDeviceState();


}


String filePath="";
final TextEditingController formDeviceDefinitionId = new TextEditingController();
final TextEditingController formBrand = new TextEditingController();
final TextEditingController formType = new TextEditingController();
final TextEditingController formModel = new TextEditingController();
final TextEditingController formDeviceCategory = new TextEditingController();
final TextEditingController formDeviceParentId = new TextEditingController();
bool isNotSelectFile=false;
class _ApiCreateDeviceState extends State<ApiCreateDevice> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApiAutomateBloc,ApiAutomateState>(
      listener:(context,state){
        if(state is ApiDeviceCreateMessageState)
          _showMyDialog(state.notCreateDeviceList,state.noOfDevices);
      },
      child: Column(
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
                      child: numberTextField(
                          formDeviceDefinitionId, "Device Definition Id"),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: textField(formBrand, "Brand"),
                    )
                  ],
                ),
                if (Responsive.isMobile(context))
                  numberTextField(formDeviceDefinitionId, "Device Definition Id"),
                if (Responsive.isMobile(context))
                  SizedBox(
                    height: 30,
                  ),
                if (Responsive.isMobile(context)) textField(formBrand, "Brand"),
                SizedBox(
                  height: 30,
                ),
                if (!Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: textField(formType, "Type"),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: optionalTextField(formModel, "Model"),
                    )
                  ],
                ),
                if (Responsive.isMobile(context))
                  textField(formType, "Type"),
                if (Responsive.isMobile(context))
                  SizedBox(
                    height: 30,
                  ),
                if (Responsive.isMobile(context))
                  optionalTextField(formModel, "Model"),
                SizedBox(
                  height: 30,
                ),
                if (!Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: optionalTextField(formDeviceCategory, "Device Category"),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: numberTextField(formDeviceParentId, "Device Parent Id"),
                    )
                  ],
                ),
                if (Responsive.isMobile(context))
                  optionalTextField(formDeviceCategory, "Device Category"),
                if (Responsive.isMobile(context))
                  SizedBox(
                    height: 30,
                  ),
                if (Responsive.isMobile(context))
                  numberTextField(formDeviceParentId, "Device Parent Id"),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: zoneId()),
                      if(!Responsive.isMobile(context))
                      Expanded(
                        child: SizedBox(
                          width: 40,
                        ),
                        
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    if(!Responsive.isMobile(context))
                    Text("Select Device List CSV File",style:TextStyle(fontWeight: FontWeight.w600),),
                    if(!Responsive.isMobile(context))
                    selectFileButton()
                  ],
                ),
                if(Responsive.isMobile(context))
                  SizedBox(
                    height: 20,),
                if(Responsive.isMobile(context))
                Row(
                  children: [
                      Text("Select Device List CSV File",style:TextStyle(fontWeight: FontWeight.w600),),
                      selectFileButton()
                  ],
                )
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
                          horizontal: Responsive.isMobile(context)
                              ? 18
                              : 20,
                          vertical: Responsive.isMobile(context)
                              ? 18
                              : 20)),
                  onPressed: () {
                    formDeviceParentId.clear();
                    formDeviceCategory.clear();
                    formModel.clear();
                    formType.clear();
                    formBrand.clear();
                    formXSecret.clear();
                     formUsername.clear();
                    formPassword.clear();
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
                            if(formKey.currentState!.validate())
                            if(filePath.isNotEmpty) {
                              BlocProvider.of<ApiAutomateBloc>(context).add(
                                  CreateDeviceEvent(xSecret: widget.XSecret,
                                      username: widget.username,
                                      password: widget.password,
                                      deviceDefinitionId: int.parse(
                                          formDeviceDefinitionId.text),
                                      brand: formBrand.text,
                                      type: formType.text,
                                      model: formModel.text,
                                      deviceCategory: formDeviceCategory.text,
                                      deviceParentId: int.parse(formDeviceParentId
                                          .text),zoneId: zoneidvalue,
                                      filePath: filePath));
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
        ],
      ),
    );
  }
  Widget selectFileButton(){
    return Column(
      children: [
        IconButton(onPressed:() async {

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
          Text("Select the file",style:TextStyle(color:Colors.red)),
      ],
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
            else if (state is ApiDeviceCreateSuccessState)
              return messageBox("Success", Colors.green);
            else if (state is ApiErrorState)
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
  Widget optionalTextField(controller, name) {
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

  Future<void> _showMyDialog(List notCreateList,int noOfDevices) async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:(BuildContext context){
        int createdList=(noOfDevices - notCreateList.length);
        return AlertDialog(
          title: Text('Device Create Summery',style:TextStyle(color:Colors.black87,fontWeight:FontWeight.bold),),
          content: Container(
            width: double.minPositive,
            height: notCreateList.isEmpty?80:300,
            child: Column(
              children: [
                Text("$createdList out of $noOfDevices devices were created successfully",style:TextStyle(color:Colors.green,fontWeight:FontWeight.w600),),
                if(notCreateList.isNotEmpty)
                SizedBox(height: 20,),
                if(notCreateList.isNotEmpty)
                Text("Mac Address Already in Use",style:TextStyle(fontWeight:FontWeight.w500),),
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

}
