
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/HTTP/httpBloc.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';


import '../Responsive.dart';
import 'automateSendData.dart';

class HttpBody extends StatefulWidget {
  // const HttpBody({Key key}) : super(key: key);

  @override
  _HttpBodyState createState() => _HttpBodyState();
}
bool isButtonClicked=true;

TextEditingController message =TextEditingController();
TextEditingController topic =TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey();

class _HttpBodyState extends State<HttpBody> {

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
          padding: EdgeInsets.only(left:20,right:20),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintMaxLines: 1,
                              filled: true,
                              fillColor: Colors.black26,
                              border:OutlineInputBorder(
                                borderSide:BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              hintText: 'URL',
                            ),
                            controller:topic,
                            validator: (text){
                              if(text!.isEmpty){
                                return 'Cannot be empty';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    if(!Responsive.isMobile(context))
                    SizedBox(height: 60,),
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
              SizedBox(width:40,),
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


}
