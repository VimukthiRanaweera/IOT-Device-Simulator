
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/MODEL/tcpControllers.dart';
import 'package:iot_device_simulator/logic/TCP/tcpBloc.dart';
import 'package:iot_device_simulator/logic/TCP/tcpState.dart';
import 'package:iot_device_simulator/presentation/component/tcp.dart';

class TcpConsole extends StatefulWidget {
  const TcpConsole() : super();

  @override
  _TcpConsoleState createState() => _TcpConsoleState();
}

class _TcpConsoleState extends State<TcpConsole> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TcpBloc,TcpState>(
        builder: (context,state) {
          return ListView.builder(
              itemCount: TcpState.messageAndResponse.length,
              itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Send:"),
                          Expanded(child: Text(TcpState.messageAndResponse[index].message)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text("Response: "),
                          Expanded(child: Text(TcpState.messageAndResponse[index].response)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
              });
        }
      );
  }

  Widget textMessage(controller, text) {
    return TextFormField(
      maxLines: 1,
      decoration: InputDecoration(
        // filled: true,
        // fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: text,
      ),
      controller: controller,
    );
  }
}
