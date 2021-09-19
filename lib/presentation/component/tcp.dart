import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/MODEL/tcpControllers.dart';
import 'package:iot_device_simulator/MODEL/tcpMessages.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/TCP/tcpBloc.dart';
import 'package:iot_device_simulator/logic/TCP/tcpEvents.dart';
import 'package:iot_device_simulator/logic/TCP/tcpState.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';
import 'package:iot_device_simulator/logic/connectionBloc.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';
import 'package:iot_device_simulator/presentation/component/tcpConsole.dart';
import 'package:iot_device_simulator/presentation/component/tcpTextboxBuilder.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

import 'automateSendData.dart';

class TcpBody extends StatefulWidget {
  const TcpBody() : super();
  static List<TcpControllers> textBoxes = [new TcpControllers()];
  static List<TcpControllers> messageAndResponse = [];

  @override
  _TcpBodyState createState() => _TcpBodyState();
}

TextEditingController profileName = TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey();
final GlobalKey<FormState> _formKeyMessage = GlobalKey();
final _formkeyAddress = GlobalKey<FormFieldState>();
final _formkeyPort = GlobalKey<FormFieldState>();
bool isChecked = false;

class _TcpBodyState extends State<TcpBody> {
  void removeList() {
    setState(() {
      TcpBody.textBoxes.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnetionBloc, ConsState>(
      listener: (context, state) {
        if (state is SaveConnectionState)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Success!'),
            duration: Duration(milliseconds: 500),
          ));
      },
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                        BlocBuilder<ConnetionBloc, ConsState>(
                            builder: (context, state) {
                          return textForm(
                              state.formTcpProfileName, "Profile Name");
                        }),
                        SizedBox(
                          height: 30,
                        ),
                        BlocBuilder<ConnetionBloc, ConsState>(
                            builder: (context, state) {
                          return textFormKeyAddressFiled(
                              state.formTcpHostAddress,
                              "Host Address",
                              _formkeyAddress);
                        }),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: BlocBuilder<ConnetionBloc, ConsState>(
                                  builder: (context, state) {
                                return textFormKeyPortField(
                                    state.formTcpHostPort, "Host Port", _formkeyPort);
                              }),
                            ),
                            SizedBox(
                              width: Responsive.isMobile(context) ? 15 : 30,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Responsive.isMobile(context) ? 10 : 20,
                                      vertical:
                                          Responsive.isMobile(context) ? 15 : 20)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String protocol =
                                      BlocProvider.of<ProtocolCubit>(context)
                                          .state
                                          .protocol;
                                  HiveConObject connection = HiveConObject(
                                      protocol,
                                      BlocProvider.of<ConnetionBloc>(context)
                                          .state
                                          .formTcpProfileName
                                          .text,
                                      "",
                                      BlocProvider.of<ConnetionBloc>(context)
                                          .state
                                          .formTcpHostAddress
                                          .text,
                                      int.parse(
                                          BlocProvider.of<ConnetionBloc>(context)
                                              .state
                                              .formTcpHostPort
                                              .text),
                                      "username",
                                      "password",
                                      60);
                                  BlocProvider.of<ConnetionBloc>(context)
                                      .add(ConnectionSaveEvent(connection));
                                }
                              },
                              child: Text('save'),
                            ),
                            SizedBox(
                              width: Responsive.isMobile(context) ? 15 : 30,
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: BlocBuilder<TcpBloc, TcpState>(
                                builder: (context, tcpState) {
                                  if (tcpState is TcpDisconnectedState) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Responsive.isMobile(context)
                                                  ? 10
                                                  : 20,
                                              vertical: Responsive.isMobile(context)
                                                  ? 15
                                                  : 20)),
                                      onPressed: () {
                                        if (_formkeyAddress.currentState!
                                                .validate() &&
                                            _formkeyPort.currentState!.validate()) {
                                          BlocProvider.of<TcpBloc>(context).add(
                                              TcpConnectEvent(
                                                  BlocProvider.of<ConnetionBloc>(
                                                          context)
                                                      .state
                                                      .formTcpHostAddress
                                                      .text,
                                                  int.parse(
                                                      BlocProvider.of<ConnetionBloc>(
                                                              context)
                                                          .state
                                                          .formTcpHostPort
                                                          .text)));
                                        }
                                      },
                                      child: Text('Connect'),
                                    );
                                  } else if (tcpState is TcpMessageSendingState) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Responsive.isMobile(context)
                                                  ? 10
                                                  : 20,
                                              vertical: Responsive.isMobile(context)
                                                  ? 15
                                                  : 20)),
                                      onPressed: null,
                                      child: Text('Disconnect'),
                                    );
                                  } else if (tcpState is TcpConnectingState) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Responsive.isMobile(context)
                                                  ? 10
                                                  : 20,
                                              vertical: Responsive.isMobile(context)
                                                  ? 15
                                                  : 20)),
                                      onPressed: () {
                                        BlocProvider.of<TcpBloc>(context)
                                            .add(TcpDisconnectEvent());
                                      },
                                      child: Text('Disconnect'),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if(!Responsive.isMobile(context))
                Expanded(
                  flex: isChecked?2:1,
                  child:automate(),
                ),
              ],
            ),
            if(!Responsive.isMobile(context))
              if(!isChecked)
              SizedBox(height: 20,),
            if(Responsive.isMobile(context))
              SizedBox(height: 20,),
            if(Responsive.isMobile(context))
              automate(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      // padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white10),
                      height: 300.0,
                      child: Form(
                          key: _formKeyMessage,
                          child: Row(
                            children: [
                              Expanded(child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: TcpTextBoxBuilder())
                              ),
                              if(!Responsive.isMobile(context))
                              Expanded(child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15,horizontal:15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  color: Colors.black12,

                                    ),
                                child: TcpConsole(),

                              )
                              ),
                            ],
                          )
                      )
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Ink(
                      padding: EdgeInsets.all(12),
                      decoration: const ShapeDecoration(
                        color: primaryColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        hoverColor: secondaryColor,
                        onPressed: () {
                          setState(() {
                            TcpBody.textBoxes.add(new TcpControllers());

                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Ink(
                      padding: EdgeInsets.all(12),
                      decoration: const ShapeDecoration(
                        color: primaryColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        iconSize: 25,
                        disabledColor: Colors.black26,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        hoverColor: secondaryColor,
                        onPressed:
                            TcpBody.textBoxes.length > 1 ? removeList : null,
                        icon: Icon(Icons.remove),
                      ),
                    ),
                  ],
                )
              ],
            ),
            if(Responsive.isMobile(context))
            SizedBox(
              height: 20,
            ),
            if(Responsive.isMobile(context))
            Container(
              height: 300.0,
              padding: EdgeInsets.symmetric(vertical: 15,horizontal:15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black12,

              ),
              child: TcpConsole(),

            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
                  onPressed: () {
                    setState(() {
                      TcpBody.textBoxes
                          .removeRange(1, TcpBody.textBoxes.length);
                      TcpBody.textBoxes[0].message.clear();
                    });
                    BlocProvider.of<TcpBloc>(context).add(TcpMessageAndResponseListClearEvent());
                  },
                  child: Text('Clear'),
                ),
                SizedBox(
                  width: 20,
                ),
                BlocBuilder<TcpBloc, TcpState>(builder: (context, state) {
                  if (state is TcpMessageSendingState) {
                    return Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 20,
                        ),
                        sendButton(),
                      ],
                    );
                  } else if (state is TcpMessageSendingState ||
                      state is TcpDisconnectedState) {
                    return sendButton();
                  } else {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20)),
                      onPressed: () {
                        if (_formKeyMessage.currentState!.validate()) {
                          if(isChecked){
                            if(BlocProvider.of<AutomateCubit>(context).state.setAutoDetails()){
                              BlocProvider.of<TcpBloc>(context)
                                  .add(TcpAutoSendMessageEvent(BlocProvider.of<AutomateCubit>(context).state.count,
                                  BlocProvider.of<AutomateCubit>(context).state.time));
                            }
                          }
                          else {
                            BlocProvider.of<TcpBloc>(context)
                                .add(TcpSendMessageEvent());
                          }
                        }
                      },
                      child: Text('send'),
                    );
                  }
                }),
                SizedBox(
                  width: 80,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
 Widget automate(){
    return  Container(
      height:isChecked?320:50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Auto"),
              SizedBox(width: 20,),
              Checkbox(
                checkColor: Colors.white,
                value:isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
            ],
          ),
          if(isChecked)
            Expanded(child: AutomateSendData()),
        ],
      ),
    );
 }
  Widget sendButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
      onPressed: null,
      child: Text('send'),
    );
  }

  Widget textFormKeyAddressFiled(controller, text, key) {
    return TextFormField(
      maxLines: 1,
      key: key,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
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

  Widget textFormKeyPortField(controller, text, key) {
    return TextFormField(
      maxLines: 1,
      key: key,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
      maxLines: 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
}
