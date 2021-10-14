
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/HTTP/httpBloc.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';

import '../Responsive.dart';
import 'automateSendData.dart';

class HttpBody extends StatefulWidget {
  // const HttpBody({Key key}) : super(key: key);

  @override
  _HttpBodyState createState() => _HttpBodyState();
}

TextEditingController message =TextEditingController();
TextEditingController connectionName=TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey();
final GlobalKey<FormState> _formkeySaveCon = GlobalKey();
bool isChecked=false;

class _HttpBodyState extends State<HttpBody> {
  final _formFieldKey = GlobalKey<FormFieldState>();
  late Box<HiveConObject> consBox;
  @override
  void initState() {
    super.initState();
    consBox=Hive.box<HiveConObject>( ConnectionsBoxName);
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValueHttp='POST';
    void sendButtonClick(){
      if(_formKey.currentState!.validate()){
        if(isChecked) {
          if(BlocProvider.of<AutomateCubit>(context).state.setAutoDetails()) {
            BlocProvider.of<HttpBloc>(context).add(MultipleHttpPost(message.text,BlocProvider.of<ConnetionBloc>(context).state.formHttpAddress.text
                ,BlocProvider.of<AutomateCubit>(context).state.count,
                BlocProvider.of<AutomateCubit>(context).state.time));
          }
        }else
          BlocProvider.of<HttpBloc>(context).add(HttpPost(message.text,BlocProvider.of<ConnetionBloc>(context).state.formHttpAddress.text));
      }
    }

    return BlocListener<HttpBloc,HttpState>(
      listener:(context,state){
        if(state is HttpPostSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('success!'),
                duration: Duration(milliseconds: 500),
              )
          );
        }if(state is HttpError){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Request Fail',style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold),),
                duration: Duration(milliseconds: 1000),
              )
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 42,),
                    Row(
                      children: [
                        DropdownButton<String>(
                          underline: SizedBox(),
                          value:dropdownValueHttp,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValueHttp = newValue!;
                            });
                          },
                          items:<String>['POST'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: BlocBuilder<ConnetionBloc,ConsState>(
                            builder:(context,state) {
                              return TextFormField(
                                minLines: 1,
                                maxLines: 2,
                                key: _formFieldKey,
                                decoration: InputDecoration(
                                  hintMaxLines: 1,
                                  filled: true,
                                  fillColor: TextFieldColour,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(TextBoxRadius)),
                                  ),
                                  hintText: 'URL',
                                ),
                                controller: state.formHttpAddress,
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return 'Cannot be empty';
                                  }
                                },
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    BlocBuilder<ConnetionBloc,ConsState>(
                      builder:(context,state){
                        return ElevatedButton(
                          style:ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal:35,vertical:20)
                          ),
                          onPressed:(){
                            if(_formFieldKey.currentState!.validate()) {
                              _showMyDialog(state.formHttpAddress.text);
                            }
                          },
                          child:Text('Save')
                        );
                      }
                    ),
                      SizedBox(height: 30,),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: TextFieldColour,
                        border:OutlineInputBorder(
                          borderSide:BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
                        ),
                        hintText: 'Message',
                      ),
                      controller:message,
                      validator: (text){
                        if(text!.isEmpty){
                          return 'Cannot be empty';
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    if(Responsive.isMobile(context))
                      automate(),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocBuilder<HttpBloc,HttpState>(
                            builder:(context,state){
                              if(state is HttpMultiplePosting)
                                return Row(
                                  children: [
                                    Text("Posting . . . ",style:TextStyle(fontSize:20,color:buttonColor),),
                                    SizedBox(width:10,),
                                    CircularProgressIndicator(),
                                    SizedBox(width:10,),
                                  ],
                                );
                              return SizedBox(width: 10,);

                            }
                        ),
                        SizedBox(width: 10,),
                        ElevatedButton(
                          style:ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal:35,vertical:20)
                          ),
                          onPressed:(){
                            message.clear();

                          }, child:Text("Clear"),
                        ),
                        SizedBox(width: 10,),
                        BlocBuilder<HttpBloc,HttpState>(
                            builder:(context,state){
                              return ElevatedButton(
                                  style:ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal:35,vertical:20)
                                  ),
                                  onPressed:state is HttpMultiplePosting?null:sendButtonClick,
                                  child:Text('Send')
                              );
                            }
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20,),
              if(!Responsive.isMobile(context))
              Expanded(
                flex: isChecked?2:1,
                child: automate(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget automate(){
    return  Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: checkBoxColor,
                // fillColor: MaterialStateProperty.resolveWith(getColor),
                value:isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              SizedBox(width: 20,),
              Text("Automate"),
            ],
          ),
          SizedBox(height: 10,),
          if(isChecked)
            AutomateSendData(),
          SizedBox(height:20),
        ],
      ),
    );
  }
  Future<void> _showMyDialog(String message) async{
    return showDialog<void>
      (
      context: context,
      barrierDismissible: true,
      builder:(BuildContext context){
        return AlertDialog(
          title: Text('HTTP Client',style:TextStyle(color:Colors.black45,fontWeight:FontWeight.bold),),
          content: SingleChildScrollView(
            child: Form(
              key: _formkeySaveCon,
              child: Column(
                children: <Widget>[
                  SizedBox(width: 300,),
                TextFormField(
                  decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  border:OutlineInputBorder(
                    borderSide:BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Connection Name',
                ),
                controller: connectionName,
                validator: (text){
                  if(text!.isEmpty){
                    return 'Cannot be empty';
                  }
                },
              ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(border: Border.all(color:Colors.white30),borderRadius:BorderRadius.circular(15),color:Colors.black38),
                      child: Text(message,style:TextStyle(fontSize: 15,fontWeight:FontWeight.bold),
                      )
                  )

                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed:(){
                  if(_formkeySaveCon.currentState!.validate()) {
                    String protocol = BlocProvider
                        .of<ProtocolCubit>(context)
                        .state
                        .protocol;
                    HiveConObject connection = HiveConObject(
                        protocol,
                        connectionName.text,
                        "",
                        message,
                        0,
                        "",
                        "",
                        60);
                    BlocProvider.of<ConnetionBloc>(context).add(ConnectionSaveEvent(connection));
                    connectionName.clear();
                    Navigator.of(context).pop();
                  }

                },
                child:Text("OK",style:TextStyle(fontSize:14,color:  Colors.green,fontWeight:FontWeight.bold),)
            ),
            TextButton(
                onPressed:(){
                  Navigator.of(context).pop();

                },
                child:Text("Cancel",style:TextStyle(fontSize:14,color: Colors.deepOrangeAccent,fontWeight:FontWeight.bold),)
            ),
          ],
        );
      },
    );

  }

}
