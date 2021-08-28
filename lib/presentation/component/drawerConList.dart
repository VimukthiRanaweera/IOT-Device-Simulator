import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttEvents.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';
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
          color:Colors.black38,
          child: AbsorbPointer(
            absorbing: !(conState is MqttDisconnectedState || conState is MqttClientNotClickState),
            child: Drawer(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Text("Connections",
                      style: TextStyle(color: Colors.black87, fontSize: 20,)
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
                                          Colors.white10:secondaryColor,
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
                                              leading: Text(index.toString()),
                                              onTap: () async {
                                                if (state.protocol == "MQTT")
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

}
