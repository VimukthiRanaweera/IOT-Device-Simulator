import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';

class WindowMqttNewConnection extends StatefulWidget {
  // const WindowMqttNewConnection({Key key}) : super(key: key);

  @override
  _WindowMqttNewConnectionState createState() => _WindowMqttNewConnectionState();
}


final GlobalKey<FormState> _formKey = GlobalKey();

class _WindowMqttNewConnectionState extends State<WindowMqttNewConnection> {
  late Box<HiveConObject> consBox;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   consBox=Hive.box<HiveConObject>( ConnectionsBoxName);
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<ConnetionBloc,ConsState>(
      listener:(context,state){
        if(state is SaveConnectionState)
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success!'),
                duration: Duration(milliseconds: 500),
              )
          );
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 80,vertical:60),
        child: Form(
          key:_formKey,
          child: Column(
            children: [
              Container(
                alignment:Alignment.topRight,
                child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                    ),
                    onPressed: (){
                        BlocProvider.of<ConnetionBloc>(context).add(CreateNewConnetionEvent(BlocProvider.of<ConnetionBloc>(context).state.superConModel));
                    },
                    child:Text('New Connection')
                ),
              ),
              SizedBox(height: 50,),
              _connectionName(),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment:MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child:_clientId()
                  ),
                  SizedBox(width: 30,),
                  ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal:20,vertical:20)
                      ),
                      onPressed: (){

                      },
                      child:Text('Generate ID')
                  ),
                  Expanded(flex:3,child:SizedBox(width: 10,))
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    child:_brokerAddres()
                  ),
                  SizedBox(width: 60,),
                  Expanded(
                    child:_port()
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    child:_username()
                  ),
                  SizedBox(width: 60,),
                  Expanded(
                    child: _password()
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _keepAlive()
                  ),
                  Expanded(
                    flex: 4,
                      child: SizedBox(width: 10,)),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                      ),
                      onPressed: (){

                      },
                      child:Text('Cancel')
                  ),
                  SizedBox(width:40,),
                  BlocBuilder<ConnetionBloc,ConsState>(
                    builder:(context,state) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20)
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String protocol = BlocProvider
                                  .of<ProtocolCubit>(context)
                                  .state
                                  .protocol;

                              HiveConObject connection = HiveConObject(
                                  protocol,
                                  state.formConnectionName.text,
                                  state.formConnectionID.text,
                                  state.formBrokerAddress.text,
                                  int.parse(state.formPort.text),
                                  state.formUserName.text,
                                  state. formPassword.text,
                                  60);
                              BlocProvider.of<ConnetionBloc>(context).add(ConnectionSaveEvent(connection));

                            }
                          },
                          child: Text('Save')
                      );
                    }
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _connectionName(){

    return BlocBuilder<ConnetionBloc,ConsState>(
      builder:(context,state) {
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: Colors.black26,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'Connection Name',
          ),
          controller: state.formConnectionName,

          validator: (text) {
            if (text!.isEmpty) {
              return 'Cannot be empty';
            }
          },
          onSaved: (text) {

          },
        );
      }
    );
  }

  Widget _clientId(){
    return BlocBuilder<ConnetionBloc,ConsState>(
      builder:(context,state) {
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: Colors.black26,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'Client ID',
          ),
          controller:state.formConnectionID,
          validator: (text) {
            if (text!.isEmpty) {
              return 'Cannot be empty';
            }
          },
          onSaved: (text) {

          },
        );
      }
    );
  }
  Widget _brokerAddres(){
    return BlocBuilder<ConnetionBloc,ConsState>(
      builder:(context,state) {
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: Colors.black26,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'Broker Address',
          ),
          controller: state.formBrokerAddress,
          validator: (text) {
            if (text!.isEmpty) {
              return 'Cannot be empty';
            }
          },
          onSaved: (text) {

          },
        );
      }
    );
  }
  Widget _port(){
    return  BlocBuilder<ConnetionBloc,ConsState>(
      builder:(context,state) {
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: Colors.black26,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'Port',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: state.formPort,
          validator: (text) {
            if (text!.isEmpty) {
              return 'Cannot be empty';
            }
          },
          onSaved: (text) {

          },
        );
      }
    );
  }
  Widget _username(){
    return BlocBuilder<ConnetionBloc,ConsState>(
      builder:(context,state){
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: Colors.black26,
            border:OutlineInputBorder(
              borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'Username',

          ),
          controller: state.formUserName,
          validator: (text){
            if(text!.isEmpty){
              return 'Cannot be empty';
            }
          },
          onSaved: (text){

          },
        );
      },
    );
  }
  Widget _password(){
    return BlocBuilder<ConnetionBloc,ConsState>(
      builder:(context,state){
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: Colors.black26,
            border:OutlineInputBorder(
              borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'Password',
          ),
          controller: state.formPassword,
          validator: (text){
            if(text!.isEmpty){
              return 'Cannot be empty';
            }
          },
          onSaved: (text){
          },
        );
      },
    );
  }
  Widget _keepAlive(){
    return BlocBuilder<ConnetionBloc,ConsState>(
      builder:(context,state) {
        return TextFormField(
          decoration: InputDecoration(
            hintMaxLines: 1,
            filled: true,
            fillColor: Colors.black26,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'Keep Alive',

          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        );
      }
    );
  }
}
