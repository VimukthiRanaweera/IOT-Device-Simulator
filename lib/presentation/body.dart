import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';
import 'package:iot_device_simulator/presentation/component/coapbody.dart';
import 'package:iot_device_simulator/presentation/component/httpBody.dart';
import 'component/mainTopBar.dart';
import 'component/mqttBody.dart';
import 'component/tcp.dart';

class PageBody extends StatefulWidget {
  // const Body({Key key}) : super(key: key);

  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MainTopBar(),
              SizedBox(height: 30.0,),
               BlocBuilder<ProtocolCubit,ProtocolState>(
                 builder:(context,state){
                   if(state.protocol=="HTTP")
                     return HttpBody();
                   else if(state.protocol=='CoAP')
                     return CoapBody();
                   else if(state.protocol=="TCP")
                     return TcpBody();
                   else
                     return MqttBody();

                 }
               )

            ],
           ),
        ),
    );
  }
}
