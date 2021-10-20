
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';


class drawerConList extends StatefulWidget {
  // const drawerConList({Key key}) : super(key: key);

  @override
  _drawerConListState createState() => _drawerConListState();
}
class _drawerConListState extends State<drawerConList> {
  late Box<HiveConObject> consBox;

  TextEditingController tcpProfileName = TextEditingController();
  TextEditingController tcpHostAddress = TextEditingController();
  TextEditingController tcpPort = TextEditingController();
  final GlobalKey<FormState> _tcpFormkeySaveCon = GlobalKey();


  TextEditingController httpProfileName = TextEditingController();
  TextEditingController httpHostAddress = TextEditingController();
  final GlobalKey<FormState> _httpFormkeySaveCon = GlobalKey();

  TextEditingController coapProfileName = TextEditingController();
  TextEditingController coapHostAddress = TextEditingController();
  TextEditingController coapPort = TextEditingController();
  final GlobalKey<FormState> _coapFormkeySaveCon = GlobalKey();

  @override
  void initState() {
    super.initState();
    consBox=Hive.box<HiveConObject>( ConnectionsBoxName);

  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MqttBloc,MqttState>(
      builder:(context,conState) {
        return Container(
          // color:Colors.black38,
          child: AbsorbPointer(
            absorbing: !( conState is MqttClientNotClickState || conState is MqttClientClickedState || conState is MqttDisconnectedState),
            child: Drawer(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Connections",
                          style: TextStyle(color: Colors.black87, fontSize: 20,)
                      ),
                      SizedBox(width: 20,),
                      BlocBuilder<ProtocolCubit, ProtocolState>(
                        builder:(context,state) {
                          return IconButton(onPressed: () {
                            if(state.protocol ==MQTT ) {
                              BlocProvider.of<ConnetionBloc>(context).add(
                                  CreateNewConnetionEvent(BlocProvider
                                      .of<ConnetionBloc>(context)
                                      .state
                                      .superConModel));
                              Navigator.of(context).pushNamed(
                                  '/newConnection');
                            }
                            else if(state.protocol ==TCP ){
                              tcpShowMyDialog(state.protocol);
                            }
                            else if(state.protocol == HTTP){
                              httpShowMyDialog(state.protocol);
                            }
                            else if(state.protocol == CoAP){
                              coapShowMyDialog(state.protocol);
                            }
                          }, icon: Icon(Icons.add));
                        }
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: consBox.listenable(),
                        builder: (context, Box<HiveConObject> cons, _) {
                          // List<int> keys = cons.keys.cast<int>().toList();
                          return BlocBuilder<ProtocolCubit, ProtocolState>(
                            builder: (context, state) {
                              List<String> keys = cons.keys.cast<String>().where((
                                  key) =>
                              cons.get(key)!.protocol == state.protocol).toList();

                              return ListView.builder(
                                itemBuilder: (_, index) {
                                  final String key = keys[index];
                                  final HiveConObject? hiveCon = cons.get(key);
                                  return BlocBuilder<ConnetionBloc,ConsState>(
                                      builder:(context,constate) {
                                        return Card(
                                          color: (constate.superConModel
                                              .connectionName ==
                                              hiveCon!.connectionName) ?
                                          clickedListTileColor:secondaryColor,
                                            child: ListTile(
                                              title: Text(
                                                  hiveCon.connectionName),
                                              subtitle: Text(hiveCon.protocol,
                                                style: TextStyle(
                                                    fontSize: 12.0),),
                                              trailing: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  _showMyDialog(
                                                      key,
                                                      hiveCon.connectionName);
                                                },
                                              ),
                                              onTap: () async {
                                                if (state.protocol == MQTT)
                                                  BlocProvider.of<MqttBloc>(
                                                      context).add(
                                                      MqttClientClickedEvent());
                                                else
                                                  BlocProvider.of<MqttBloc>(
                                                      context).add(
                                                      MqttUnselectedEvent());
                                                BlocProvider.of<ConnetionBloc>(
                                                    context).add(
                                                    SelectConnectionEvent(
                                                        hiveCon));
                                              },

                                            )
                                        );
                                      }
                                  );
                                },
                                itemCount: keys.length,
                              );
                            },

                          );
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Future<void> _showMyDialog(String key,String conName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert',style:TextStyle(color:Colors.red,fontWeight:FontWeight.bold),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Do you want to delete $conName?'),
              ],
            ),
          ),
          backgroundColor:primaryColor,

          actions: <Widget>[
            BlocBuilder<ConnetionBloc,ConsState>(
              builder:(context,state) {
                return TextButton(
                  child: Text('Delete', style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    BlocProvider.of<MqttBloc>(context).add(MqttClientDeleteEvent(state.superConModel,conName));
                    BlocProvider.of<ConnetionBloc>(context).add(DeleteConnectionEvent(key,conName,state.superConModel));


                    Navigator.of(context).pop();
                  },
                );
              }
            ),
            TextButton(
              child: Text('Cancel',style: TextStyle(color:Colors.black87,fontWeight:FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> tcpShowMyDialog(String protocol ) async{
    return showDialog<void>
      (
      context: context,
      barrierDismissible: true,
      builder:(BuildContext context){
        return AlertDialog(
          title: Text('New TCP Client',style:TextStyle(color:Colors.black45,fontWeight:FontWeight.bold),),
          content: SingleChildScrollView(
            child: Form(
              key: _tcpFormkeySaveCon,
              child: Column(
                children: <Widget>[
                  SizedBox(width: 500,),
                  textForm(
                      tcpProfileName, "Profile Name"),
                  SizedBox(height: 20,),
                  textForm(tcpHostAddress, "Host"),
                  SizedBox(height: 20,),
                  formPortField(tcpPort,"Port")
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed:(){
                  if(_tcpFormkeySaveCon.currentState!.validate()) {
                    HiveConObject connection = HiveConObject(
                        protocol,
                        tcpProfileName.text,
                        "",
                        tcpHostAddress.text,
                        int.parse(tcpPort.text),
                        "",
                        "",
                        60);
                    BlocProvider.of<ConnetionBloc>(context).add(ConnectionSaveEvent(connection));
                    tcpHostAddress.clear();
                    tcpPort.clear();
                    tcpProfileName.clear();
                    Navigator.of(context).pop();
                  }

                },
                child:Text("Save",style:TextStyle(fontSize:14,color:  Colors.green,fontWeight:FontWeight.bold),)
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
  Widget formPortField(controller, text) {
    return TextFormField(
      maxLines: 1,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        filled: true,
        fillColor: TextFieldColour,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
        ),
        hintText: text,
      ),
      controller: controller,
      validator: (text) {
        if (text!.isEmpty) {
          return 'Cannot be empty';
        }
      },
    );
  }
  Widget textForm(controller, text) {
    return TextFormField(
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration(
        filled: true,
        fillColor: TextFieldColour,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
        ),
        hintText: text,
      ),
      controller: controller,
      validator: (text) {
        if (text!.isEmpty) {
          return 'Cannot be empty';
        }
      },
    );
  }

  Future<void> httpShowMyDialog(String protocol ) async{
    return showDialog<void>
      (
      context: context,
      barrierDismissible: true,
      builder:(BuildContext context){
        return AlertDialog(
          title: Text('New HTTP Client',style:TextStyle(color:Colors.black45,fontWeight:FontWeight.bold),),
          content: SingleChildScrollView(
            child: Form(
              key: _httpFormkeySaveCon,
              child: Column(
                children: <Widget>[
                  SizedBox(width: 500,),
                  textForm(httpProfileName,"Connection Name"),
                  SizedBox(height: 20,),
                  textForm(httpHostAddress,"URL"),
                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed:(){
                  if(_httpFormkeySaveCon.currentState!.validate()) {
                    HiveConObject connection = HiveConObject(
                        protocol,
                        httpProfileName.text,
                        "",
                        httpHostAddress.text,
                        0,
                        "",
                        "",
                        60);
                    BlocProvider.of<ConnetionBloc>(context).add(ConnectionSaveEvent(connection));
                    httpHostAddress.clear();
                    httpProfileName.clear();
                    Navigator.of(context).pop();
                  }

                },
                child:Text("Save",style:TextStyle(fontSize:14,color:  Colors.green,fontWeight:FontWeight.bold),)
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
  Future<void> coapShowMyDialog( String protocol) async{
    return showDialog<void>
      (
      context: context,
      barrierDismissible: true,
      builder:(BuildContext context){
        return AlertDialog(
          title: Text('New CoAP Client',style:TextStyle(color:Colors.black45,fontWeight:FontWeight.bold),),
          content: SingleChildScrollView(
            child: Form(
              key: _coapFormkeySaveCon,
              child: Column(
                children: <Widget>[
                  SizedBox(width: 500,),
                  textForm(coapProfileName, "Connection name"),
                  SizedBox(height: 20,),
                  textForm(coapHostAddress, "Host Address"),
                  SizedBox(height: 20,),
                  formPortField(coapPort,"Port")
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed:(){
                  if(_coapFormkeySaveCon.currentState!.validate()) {
                    HiveConObject connection = HiveConObject(
                        protocol,
                        coapProfileName.text,
                        "",
                        coapHostAddress.text,
                        int.parse(coapPort.text),
                        "",
                        "",
                        60);
                    BlocProvider.of<ConnetionBloc>(context).add(ConnectionSaveEvent(connection));
                    coapPort.clear();
                    coapHostAddress.clear();
                    coapProfileName.clear();
                    Navigator.of(context).pop();
                  }

                },
                child:Text("Save",style:TextStyle(fontSize:14,color:  Colors.green,fontWeight:FontWeight.bold),)
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
