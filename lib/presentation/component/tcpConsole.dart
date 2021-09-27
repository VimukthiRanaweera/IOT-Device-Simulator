
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/TCP/tcpBloc.dart';
import 'package:iot_device_simulator/logic/TCP/tcpState.dart';

class TcpConsole extends StatefulWidget {
  const TcpConsole() : super();

  @override
  _TcpConsoleState createState() => _TcpConsoleState();
}
ScrollController scrollController = ScrollController();
class _TcpConsoleState extends State<TcpConsole> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown:true,
      thickness: 9,
      controller: scrollController,
      child: BlocBuilder<TcpBloc,TcpState>(
          builder: (context,state) {
            return ListView.builder(
              controller: scrollController,
                itemCount: TcpState.messageAndResponse.length,
                itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment:CrossAxisAlignment.start ,
                          children: [
                            if(TcpState.messageAndResponse[index].message.isNotEmpty)
                              SelectableText("Send        :",style:TextStyle(fontWeight: FontWeight.bold),),
                            Expanded(child: SelectableText(TcpState.messageAndResponse[index].message)),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment:CrossAxisAlignment.start ,
                          children: [
                            if(TcpState.messageAndResponse[index].response.isNotEmpty)
                              SelectableText("Response :",style:TextStyle(fontWeight: FontWeight.bold),),
                            Expanded(child: SelectableText(TcpState.messageAndResponse[index].response)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                });
          }
        ),
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
