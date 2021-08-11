import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';

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

void ClearText(){
  formConnectionName.clear();
  formBrokerAddress.clear();
  formPort.clear();
  formUserName.clear();
  formPassword.clear();
  formConnectionID.clear();
}


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
                      print(consBox.getAt(0));
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: formPort,
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){

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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

                    },
                    child:Text('Delete')
                ),
                Spacer(),
                ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                    ),
                    onPressed: (){
                    ClearText();

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
                        String protocol = BlocProvider.of<ProtocolCubit>(context).state.protocol;
                        BlocProvider.of<ConnectionCubit>(context).setConnectionDetails(protocol,formConnectionName.text, formConnectionID.text,
                            formBrokerAddress.text,int.parse(formPort.text),formUserName.text,formPassword.text,60);

                       HiveConObject connection = HiveConObject(protocol , formConnectionName.text, formConnectionID.text,
                           formBrokerAddress.text,  int.parse(formPort.text),formUserName.text, formPassword.text, 60);
                        consBox.put(formConnectionName.text, connection);
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
