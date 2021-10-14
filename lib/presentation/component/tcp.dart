import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/MODEL/tcpControllers.dart';
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
bool isLogWrite = false;
String path = "";

class _TcpBodyState extends State<TcpBody> {
  void removeList() {
    setState(() {
      TcpBody.textBoxes.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnetionBloc, ConsState>(
          listener: (context, state) {
            if (state is SaveConnectionState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Connection Saved!'),
                duration: Duration(milliseconds: 500),
              ));
            }
          },
        ),
        BlocListener<TcpBloc, TcpState>(
          listener: (context, state) {
            if (state is TcpSendMessageSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Success!'),
                duration: Duration(milliseconds: 500),
              ));
            }
          },
        )
      ],
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
                        SizedBox(
                          height: 42,
                        ),
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
                                    state.formTcpHostPort,
                                    "Host Port",
                                    _formkeyPort);
                              }),
                            ),
                            SizedBox(
                              width: Responsive.isMobile(context) ? 15 : 30,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35,
                                      vertical: 20)),
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
                                      int.parse(BlocProvider.of<ConnetionBloc>(
                                              context)
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
                              child: Text('Save'),
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
                                              horizontal: 25,
                                              vertical:
                                                  20)),
                                      onPressed: () {
                                        // if (_formkeyAddress.currentState!
                                        //         .validate() &&
                                        //     _formkeyPort.currentState!
                                        //         .validate())
                                        if (_formKey.currentState!.validate()) {
                                          BlocProvider.of<TcpBloc>(context).add(
                                              TcpConnectEvent(
                                                  BlocProvider.of<
                                                              ConnetionBloc>(
                                                          context)
                                                      .state
                                                      .formTcpHostAddress
                                                      .text,
                                                  int.parse(BlocProvider.of<
                                                              ConnetionBloc>(
                                                          context)
                                                      .state
                                                      .formTcpHostPort
                                                      .text)));
                                        }
                                      },
                                      child: Text('Connect'),
                                    );
                                  } else if (tcpState
                                      is TcpMessageSendingState) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical:20)),
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
                                              horizontal: 20,
                                              vertical:20)),
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
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: isChecked ? 2 : 1,
                    child: automate(),
                  ),
              ],
            ),
            if (!Responsive.isMobile(context))
              if (!isChecked)
                SizedBox(
                  height: 20,
                ),
            if (Responsive.isMobile(context))
              SizedBox(
                height: 20,
              ),
            if (Responsive.isMobile(context)) automate(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      // padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.circular(TextBoxRadius),
                          color: Colors.white10),
                      height: 300.0,
                      child: Form(
                          key: _formKeyMessage,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: TcpTextBoxBuilder())),
                              if (!Responsive.isMobile(context))
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(TextBoxRadius),
                                    color: Colors.black12,
                                  ),
                                  child: TcpConsole(),
                                )),
                            ],
                          ))),
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
            if (Responsive.isMobile(context))
              SizedBox(
                height: 20,
              ),
            if (Responsive.isMobile(context))
              Container(
                height: 300.0,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                          EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
                  onPressed: () {
                    setState(() {
                      TcpBody.textBoxes
                          .removeRange(1, TcpBody.textBoxes.length);
                      TcpBody.textBoxes[0].message.clear();
                      TcpState.messageAndResponse.clear();
                    });
                  },
                  child: Text('Clear'),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20)),
                  onPressed: () {
                    if (_formKey.currentState!.validate())
                      BlocProvider.of<TcpBloc>(context).add(
                          TcpMessageWriteFileEvent(
                              BlocProvider.of<ConnetionBloc>(context)
                                  .state
                                  .formTcpProfileName
                                  .text));
                  },
                  child: Text('Save File'),
                ),
                SizedBox(
                  width: 20,
                ),
                BlocBuilder<TcpBloc, TcpState>(builder: (context, state) {
                  if (state is TcpMessageSendingState ||
                      state is TcpAddListState ||
                      state is TcpMessageSendState) {
                    return CircularProgressIndicator();
                  } else if (state is TcpDisconnectedState) {
                    return sendButton();
                  } else {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 20)),
                      onPressed: () {
                        if (_formKeyMessage.currentState!.validate()) {
                          if (isChecked) {
                            if (BlocProvider.of<AutomateCubit>(context)
                                .state
                                .setAutoDetails()) {
                              BlocProvider.of<TcpBloc>(context)
                                  .add(TcpAutoSendMessageEvent(
                                BlocProvider.of<AutomateCubit>(context)
                                    .state
                                    .count,
                                BlocProvider.of<AutomateCubit>(context)
                                    .state
                                    .time,
                              ));
                            }
                          } else {
                            BlocProvider.of<TcpBloc>(context)
                                .add(TcpSendMessageEvent());
                          }
                        }
                      },
                      child: Text('Send'),
                    );
                  }
                }),
                if (!Responsive.isMobile(context))
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

  Widget automate() {
    return Container(
      height: isChecked ? 330 : 60,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: checkBoxColor,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              SizedBox(
                width: 20,
              ),
              Text("Automate"),
            ],
          ),
          SizedBox(height: 10,),
          if (isChecked) Expanded(child: AutomateSendData()),
        ],
      ),
    );
  }

  Widget sendButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
      onPressed: null,
      child: Text('Send'),
    );
  }

  Widget textFormKeyAddressFiled(controller, text, key) {
    return TextFormField(
      maxLines: 1,
      key: key,
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

  Widget textFormKeyPortField(controller, text, key) {
    return TextFormField(
      maxLines: 1,
      key: key,
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
      maxLines: 1,
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
}
