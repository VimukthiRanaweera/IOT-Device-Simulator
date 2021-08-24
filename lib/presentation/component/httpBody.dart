
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
TextEditingController topic =TextEditingController();
TextEditingController connectionName=TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey();
final GlobalKey<FormState> _formkeySaveCon = GlobalKey();


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
        if(BlocProvider.of<AutomateCubit>(context).state.isChecked) {
          if(BlocProvider.of<AutomateCubit>(context).state.setAutoDetails()) {
            BlocProvider.of<HttpBloc>(context).add(MultipleHttpPost(message.text,topic.text,BlocProvider.of<AutomateCubit>(context).state.count,
                BlocProvider.of<AutomateCubit>(context).state.time));
          }
        }else
          BlocProvider.of<HttpBloc>(context).add(HttpPost(message.text,topic.text));
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
        }
      },
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(left:0,right:0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 50,),
                    Row(
                      children: [
                        DropdownButton<String>(
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
                                key: _formFieldKey,
                                decoration: InputDecoration(
                                  hintMaxLines: 1,
                                  filled: true,
                                  fillColor: Colors.black26,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  hintText: 'URL',
                                ),
                                controller: state.formBrokerAddress,
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
                    SizedBox(height: 20,),
                    BlocBuilder<ConnetionBloc,ConsState>(
                      builder:(context,state){
                        return ElevatedButton(
                          style:ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal:20,vertical:10)
                          ),
                          onPressed:(){
                            if(_formFieldKey.currentState!.validate()) {
                              _showMyDialog(state.formBrokerAddress.text);
                            }
                          },
                          child:Text('Save')
                        );
                      }
                    ),
                    if(!Responsive.isMobile(context))
                    SizedBox(height: 40,),
                    if(Responsive.isMobile(context))
                      SizedBox(height: 30,),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black26,
                        border:OutlineInputBorder(
                          borderSide:BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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

                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        if(Responsive.isMobile(context))
                          Expanded(child: AutomateSendData()),
                        BlocBuilder<HttpBloc,HttpState>(
                            builder:(context,state){
                              if(state is HttpMultiplePosting)
                                return Row(
                                  children: [
                                    Text("Posting . . . ",style:TextStyle(fontSize:20,color:Colors.blueAccent),),
                                    SizedBox(width:10,),
                                    CircularProgressIndicator(),
                                    SizedBox(width:10,),
                                  ],
                                );
                              return SizedBox(width: 10,);

                            }
                        ),
                        BlocBuilder<HttpBloc,HttpState>(
                            builder:(context,state){
                              return ElevatedButton(
                                  style:ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                                  ),
                                  onPressed:state is HttpMultiplePosting?null:sendButtonClick,
                                  child:Text('Send')
                              );
                            }
                        )

                      ],
                    ),
                  ],
                ),
              ),
              if(!Responsive.isMobile(context))
              SizedBox(width:30,),
              if(!Responsive.isMobile(context))
                Expanded(
                  flex: 2,
                    child: AutomateSendData()
                ),
            ],
          ),
        ),
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
