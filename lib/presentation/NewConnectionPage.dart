import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';
import 'package:iot_device_simulator/presentation/windowMqttNewConnection.dart';

class NewConnectionPage extends StatefulWidget {
  const NewConnectionPage({required this.title}) : super();
 final String title;
  @override
  _NewConnectionPageState createState() => _NewConnectionPageState();
}

class _NewConnectionPageState extends State<NewConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ProtocolCubit, ProtocolState>(
              builder: (context, state) {
                return Text(state.protocol + ' New Connection');
              }
          ),
        ),
        body: WindowMqttNewConnection()
    );
  }

}
