import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/MQTT/mqttConCubit.dart';
import 'package:iot_device_simulator/logic/checkConCubit.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';


class drawerConList extends StatefulWidget {
  // const drawerConList({Key key}) : super(key: key);

  @override
  _drawerConListState createState() => _drawerConListState();
}
var items =List<String>.generate(20, (index) => 'Item $index');
class _drawerConListState extends State<drawerConList> {
  late Box<HiveConObject> consBox;
  late String protocol='CoAP';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consBox=Hive.box<HiveConObject>( ConnectionsBoxName);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: 20.0),
             Text("Connections",
                 style:TextStyle(color: Colors.black87,fontSize:20,)
             ),
          SizedBox(height: 20.0),
          Expanded(
            child: ValueListenableBuilder(
                  valueListenable: consBox.listenable(),
                  builder: (context, Box<HiveConObject> cons, _) {
                    // List<int> keys = cons.keys.cast<int>().toList();
                   return BlocBuilder<ProtocolCubit,ProtocolState>(
                    builder:(context,state) {
                    List<String> keys = cons.keys.cast<String>().where((key) =>
                    cons.get(key)!.protocol == BlocProvider
                        .of<ProtocolCubit>(context)
                        .state
                        .protocol).toList();

                    return ListView.builder(
                      itemBuilder: (_, index) {
                        final String key = keys[index];
                        final HiveConObject? hiveCon = cons.get(key);
                        return Card(
                          child: ListTile(
                            tileColor: secondaryColor,
                            title: Text(hiveCon!.connectionName),
                            subtitle: Text(hiveCon.protocol,
                              style: TextStyle(fontSize: 12.0),),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showMyDialog(key, hiveCon.connectionName);
                              },
                            ),
                            leading: Text(index.toString()),
                            onTap: () async {
                              if(BlocProvider.of<CheckConCubit>(context).state.isconnected) {
                                BlocProvider
                                    .of<MqttConCubit>(context)
                                    .state
                                    .Disconnect();
                                BlocProvider.of<CheckConCubit>(context)
                                    .CheckConnection(false);
                              }

                              BlocProvider.of<ConnectionCubit>(context)
                                  .setConnectionDetails(
                                  hiveCon.protocol,
                                  hiveCon.connectionName,
                                  hiveCon.connectionID,
                                  hiveCon.brokerAddress,
                                  hiveCon.port,
                                  hiveCon.username,
                                  hiveCon.password,
                                  hiveCon.keepAlive,
                              );
                            },

                          ),
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
            TextButton(
              child: Text('Delete',style: TextStyle(color:Colors.black87,fontWeight:FontWeight.bold)),
              onPressed: () {
                consBox.delete(key);
                if(BlocProvider.of<ConnectionCubit>(context).state.connectionName==conName){
                  BlocProvider.of<MqttConCubit>(context).state.Disconnect();
                  BlocProvider.of<CheckConCubit>(context).CheckConnection(false);
                  BlocProvider.of<ConnectionCubit>(context).setConnectionDetails("", "IoT Client", "","", 0, "", "",60);

                }
                Navigator.of(context).pop();
              },
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

}
