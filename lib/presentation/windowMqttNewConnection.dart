import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';

class WindowMqttNewConnection extends StatefulWidget {
  // const WindowMqttNewConnection({Key key}) : super(key: key);

  @override
  _WindowMqttNewConnectionState createState() => _WindowMqttNewConnectionState();
}
final GlobalKey<FormState> _formKey = GlobalKey();
TextEditingController formConnectionName = new TextEditingController();
TextEditingController formConnectionID = new TextEditingController();
TextEditingController formBrokerAddress = new TextEditingController();
TextEditingController formPort = new TextEditingController();
TextEditingController formUserName = new TextEditingController();
TextEditingController formPassword= new TextEditingController();

class _WindowMqttNewConnectionState extends State<WindowMqttNewConnection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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

                  },
                  child:Text('New Connection')
              ),
            ),
            SizedBox(height: 50,),
            TextFormField(
              decoration: InputDecoration(
                hintMaxLines: 1,
                filled: true,
                fillColor: Colors.black26,
                border:OutlineInputBorder(
                  borderSide:BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Connection Name',
              ),
              controller: formConnectionName,
              validator: (text){
                if(text!.isEmpty){
                  return 'Cannot be empty';
                }
              },
              onSaved: (text){
                  BlocProvider.of<ConnectionCubit>(context).setConnectionName(text);
              },
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment:MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintMaxLines: 1,
                      filled: true,
                      fillColor: Colors.black26,
                      border:OutlineInputBorder(
                        borderSide:BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Client ID',
                    ),
                    controller:formConnectionID,
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      BlocProvider.of<ConnectionCubit>(context).setConnectionID(text);
                    },
                  ),
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintMaxLines: 1,
                      filled: true,
                      fillColor: Colors.black26,
                      border:OutlineInputBorder(
                        borderSide:BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Broker Address',
                    ),
                    controller: formBrokerAddress,
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      BlocProvider.of<ConnectionCubit>(context).setBrokerAddress(text);
                    },
                  ),
                ),
                SizedBox(width: 60,),
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
                      hintText: 'Port',
                    ),
                    controller: formPort,
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      BlocProvider.of<ConnectionCubit>(context).setPort(text);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
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
                      hintText: 'Username',

                    ),
                    controller: formUserName,
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      BlocProvider.of<ConnectionCubit>(context).setUsername(text);
                    },
                  ),
                ),
                SizedBox(width: 60,),
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
                      hintText: 'Password',
                    ),
                    controller: formPassword,
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      BlocProvider.of<ConnectionCubit>(context).setPassword(text);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
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
                      hintText: 'Keep Alive',

                    ),
                  ),
                ),
                SizedBox(width: 60,),
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
                      hintText: 'Connection Timeout',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                    ),
                    onPressed: (){
                      formConnectionName.clear();
                      formBrokerAddress.clear();
                      formPort.clear();
                      formUserName.clear();
                      formPassword.clear();
                      formConnectionID.clear();
                    },
                    child:Text('Delete')
                ),
                Spacer(),
                ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                    ),
                    onPressed: (){

                    },
                    child:Text('Cancel')
                ),
                SizedBox(width:40,),
                ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                    ),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                      }
                    },
                    child:Text('Save')
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
