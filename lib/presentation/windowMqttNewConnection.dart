import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:random_string_generator/random_string_generator.dart';

class WindowMqttNewConnection extends StatefulWidget {
  // const WindowMqttNewConnection({Key key}) : super(key: key);

  @override
  _WindowMqttNewConnectionState createState() => _WindowMqttNewConnectionState();
}


final GlobalKey<FormState> _formKey = GlobalKey();
ScrollController scrollController =ScrollController();

class _WindowMqttNewConnectionState extends State<WindowMqttNewConnection> {
  late Box<HiveConObject> consBox;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   consBox=Hive.box<HiveConObject>( ConnectionsBoxName);
  }
  int _currentIntValue=60;
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
        padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context)?30:80,vertical:Responsive.isMobile(context)?20:60),
        child: Form(
          key:_formKey,
          child: Column(
            children: [
              Container(
                alignment:Alignment.topRight,
                child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal:Responsive.isMobile(context)?15:30,vertical:Responsive.isMobile(context)?10:20)
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
                    flex: Responsive.isMobile(context)?5:4,
                    child:_clientId()
                  ),
                  SizedBox(width: 30,),
                  ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal:Responsive.isMobile(context)?15:20,vertical:Responsive.isMobile(context)?17:20)
                      ),
                      onPressed: (){
                        var generator = RandomStringGenerator(
                          hasSymbols: false,
                          alphaCase:AlphaCase.LOWERCASE_ONLY,
                          fixedLength: 20,
                        );

                        print(generator.generate());
                        BlocProvider.of<ConnetionBloc>(context).state.formConnectionID.text=generator.generate();

                      },
                      child:Text('Generate ID')
                  ),
                  Expanded(flex:Responsive.isMobile(context)?1:3,child:SizedBox(width: 10,))
                ],
              ),
              SizedBox(height: 30,),
              if(!Responsive.isMobile(context))
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
              if(Responsive.isMobile(context))
                _brokerAddres(),
              if(Responsive.isMobile(context))
                SizedBox(height: 30,),
              if(Responsive.isMobile(context))
                _port(),
              SizedBox(height: 30,),
              if(!Responsive.isMobile(context))
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
              if(Responsive.isMobile(context))
                _username(),
              if(Responsive.isMobile(context))
              SizedBox(height: 30,),
              if(Responsive.isMobile(context))
              _password(),
              SizedBox(height: 30,),
              Row(
                children: [
                  Text("Keep Alive",style:TextStyle(fontWeight: FontWeight.w600),),
                  SizedBox(width: 5,),
                  _keepAlive(),
                  SizedBox(width: 5,),
                  Text("Seconds"),
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
                        Navigator.pop(context);
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
                                  state.formMqttConnectionName.text,
                                  state.formConnectionID.text,
                                  state.formBrokerAddress.text,
                                  int.parse(state.formPort.text),
                                  state.formUserName.text,
                                  state. formPassword.text,
                                  int.parse(state.keepAlive.text));
                              BlocProvider.of<ConnetionBloc>(context).add(ConnectionSaveEvent(connection));
                              BlocProvider.of<MqttBloc>(context).add(MqttClientClickedEvent());

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
            fillColor: TextFieldColour,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
            ),
            hintText: 'Connection Name',
          ),
          controller: state.formMqttConnectionName,

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
            fillColor: TextFieldColour,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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
            fillColor: TextFieldColour,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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
            fillColor: TextFieldColour,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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
            fillColor: TextFieldColour,
            border:OutlineInputBorder(
              borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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
            fillColor: TextFieldColour,
            border:OutlineInputBorder(
              borderSide:BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
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
        return Container(
          decoration: BoxDecoration(
            color: TextFieldColour,
            borderRadius: BorderRadius.circular(TextBoxRadius),
            border: Border.all(color: Colors.black26),
          ),
          child: NumberPicker(
            value: state.keepAlive.text.isEmpty?60:int.parse(state.keepAlive.text),
            minValue: 0,
            maxValue: 100,
            step: 10,
            textStyle:TextStyle(color: Colors.black38),
            itemHeight: 40,
            axis: Axis.horizontal,
            itemWidth:40,
            haptics: false,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(0),
              // border: Border.symmetric(horizontal:BorderSide(color: Colors.black26)),
            ),
            onChanged: (value) => setState(() => state.keepAlive.text = value.toString()),
          ),
        );
      }
    );
  }
}
