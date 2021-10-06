import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';
import 'package:iot_device_simulator/presentation/component/tcp.dart';

class TcpTextBoxBuilder extends StatefulWidget {
  const TcpTextBoxBuilder() : super();

  @override
  _TcpTextBoxBuilderState createState() => _TcpTextBoxBuilderState();
}


ScrollController scrollController = ScrollController();
class _TcpTextBoxBuilderState extends State<TcpTextBoxBuilder> {

  @override
  Widget build(BuildContext context) {

    return Scrollbar(
      isAlwaysShown:true,
      thickness: 9,
      interactive: true,
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: TcpBody.textBoxes.length,
          itemBuilder:(context,index){
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child:  Column(
                children: [
                    textMessage(TcpBody.textBoxes[index].message,"Message"),
                    SizedBox(height: 10,),
                ],
              ),
            );
          }

      ),
    );
  }
  Widget textMessage(controller, text) {
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

  Widget textResponse(controller, text) {
    return TextFormField(
      enabled: false,
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
    );
  }
}
