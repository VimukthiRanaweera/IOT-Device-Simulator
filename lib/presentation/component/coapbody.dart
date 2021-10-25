
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/COAP/coapBloc.dart';
import 'package:iot_device_simulator/logic/COAP/coapEvents.dart';
import 'package:iot_device_simulator/logic/COAP/coapState.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';

import '../Responsive.dart';

class CoapBody extends StatefulWidget {
  // const CoapBody({Key key}) : super(key: key);

  @override
  _CoapBodyState createState() => _CoapBodyState();
}
late String dropdownValueCOAP='GET';
final GlobalKey<FormState> _formKey = GlobalKey();
final _formkeyAddress = GlobalKey<FormFieldState>();
final _formkeyPort = GlobalKey<FormFieldState>();

TextEditingController formUriPath = new TextEditingController();
TextEditingController formUriQuery = new TextEditingController();
TextEditingController formUriTitle = new TextEditingController();
TextEditingController formResponse = new TextEditingController();
class _CoapBodyState extends State<CoapBody> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoapBloc,CoapState>(
      listener:(context,state){
        if(state is CoapGetSuccessState){
          formResponse.text=state.response;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success!'),
                duration: Duration(milliseconds: 1000),
              )
          );
        }else if(state is CoapPostSuccessState){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success!'),
                duration: Duration(milliseconds: 1000),
              )
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(top:40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  DropdownButton<String>(
                    underline: SizedBox(),
                    value:dropdownValueCOAP,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueCOAP = newValue!;
                      });
                    },
                    items:<String>['GET','POST'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child:hostAddress(),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: hostPort()),
                  SizedBox(width: 20,),
                  BlocBuilder<ConnetionBloc,ConsState>(
                    builder:(context,state) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20)
                          ),
                          onPressed: () {
                            if (_formkeyAddress.currentState!.validate() &&
                                _formkeyPort.currentState!.validate()) {
                              String protocol = BlocProvider
                                  .of<ProtocolCubit>(context)
                                  .state
                                  .protocol;
                              HiveConObject connection = HiveConObject(
                                  protocol,
                                  state.formCoapProfileName.text,
                                  "",
                            state.formCoapHostAddress.text,
                            int.parse(state.formCoapHostPort.text),
                                  "",
                                  "",
                                  60);
                              BlocProvider.of<ConnetionBloc>(context).add(ConnectionSaveEvent(connection));
                            }
                          },
                          child: Text('Update')
                      );
                    }
                  ),
                ],
              ),
              SizedBox(height: 30,),
              uriPath(),
              SizedBox(height: 30,),
              if(dropdownValueCOAP=="GET")
              response(),
              if(dropdownValueCOAP=='POST')
                uriTitle(),
              SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20)
                        ),
                        onPressed:() async {

                      if(dropdownValueCOAP=="GET"){
                        formResponse.clear();
                        formUriPath.clear();
                      }
                      else{
                        formUriPath.clear();
                        formUriTitle.clear();
                        formUriQuery.clear();
                      }
                    },
                        child:Text("Clear")
                    ),
                     SizedBox(width: 20,),
                     BlocBuilder<CoapBloc,CoapState>(
                          builder:(context,state) {
                            if(state is CoapConnectingState){
                              return CircularProgressIndicator();
                            }
                            else
                            return ElevatedButton(

                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20)
                                ),
                                onPressed: () {
                                  if (dropdownValueCOAP == "GET") {
                                    if(_formKey.currentState!.validate())
                                    BlocProvider.of<CoapBloc>(context).add(
                                        CoapGetEvent(BlocProvider.of<ConnetionBloc>(context).state.formCoapHostAddress.text,
                                            int.parse(BlocProvider.of<ConnetionBloc>(context).state.formCoapHostPort.text),
                                            formUriPath.text));
                                  }
                                  else if (dropdownValueCOAP == 'POST') {
                                    if(_formKey.currentState!.validate())
                                    BlocProvider.of<CoapBloc>(context).add(
                                        CoapPostEvent(
                                            BlocProvider.of<ConnetionBloc>(context).state.formCoapHostAddress.text,
                                            int.parse(BlocProvider.of<ConnetionBloc>(context).state.formCoapHostPort.text),
                                            formUriPath.text, formUriTitle.text));
                                  }
                                },
                                child: Text('Send')
                            );
                          }
                        ),
                  ],
                ),
              // if(Responsive.isMobile(context) && dropdownValueCOAP=='POST')
              //   AutomateSendData(),
            ],
          ),
        ),
      ),
    );
  }



  Widget hostAddress(){
    return BlocBuilder<ConnetionBloc, ConsState>(
      builder:(context,state){
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: TextFieldColour,
            border:OutlineInputBorder(
              borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
            ),
            hintText:"Host Address",
          ),
          key: _formkeyAddress,
          controller:state.formCoapHostAddress,
          validator: (text){
            if(text!.isEmpty){
              return 'Cannot be empty';
            }
          },
        );
      },
    );
  }
  Widget hostPort(){
    return BlocBuilder<ConnetionBloc, ConsState>(
      builder:(context,state){
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: TextFieldColour,
            border:OutlineInputBorder(
              borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
            ),
            hintText:"Port",
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          key: _formkeyPort,
          controller:state.formCoapHostPort,
          validator: (text){
            if(text!.isEmpty){
              return 'Cannot be empty';
            }
          },
        );
      },
    );
  }
  Widget uriPath(){
    return BlocBuilder<ConnetionBloc, ConsState>(
      builder:(context,state){
        return TextFormField(
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration(
            filled: true,
            fillColor: TextFieldColour,
            border:OutlineInputBorder(
              borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
            ),
            hintText:"Uri Path",
          ),
          controller:formUriPath,
          validator: (text){
            if(text!.isEmpty){
              return 'Cannot be empty';
            }
          },
        );
      },
    );
  }
  Widget uriTitle(){
    return BlocBuilder<ConnetionBloc, ConsState>(
      builder:(context,state){
        return TextFormField(
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: TextFieldColour,
            border:OutlineInputBorder(
              borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
            ),
            hintText:"Uri Title",
          ),
          controller: formUriTitle,
          validator: (text){
            if(text!.isEmpty){
              return 'Cannot be empty';
            }
          },
        );
      },
    );
  }
  Widget response(){
    return BlocBuilder<ConnetionBloc, ConsState>(
      builder:(context,state){
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor:Colors.white10,
            border:OutlineInputBorder(
              // borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
            ),
            hintText:"Response",
          ),
          controller:formResponse,
        );
      },
    );
  }



}
