import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';

class AutomateSendData extends StatefulWidget {
  // const AutomateSendData({Key key}) : super(key: key);
  
  @override
  _AutomateSendDataState createState() => _AutomateSendDataState();
}
TextEditingController count = new TextEditingController();
TextEditingController time= new TextEditingController();

class _AutomateSendDataState extends State<AutomateSendData> {
  @override
  Widget build(BuildContext context) {

    return Container(
      alignment:Alignment.topCenter,
      padding: EdgeInsets.only(),
      child: BlocBuilder<AutomateCubit,AutomateState>(
        builder:(context,state) {
          return Form(
            key: state.formKey,
            child: Column(
              children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: countTextBox(),
                            ),
                            SizedBox(width: 20,),
                            if(!Responsive.isMobile(context))
                            Expanded(
                              flex: 2,
                              child:timeTextBox(),
                            ),

                            Expanded(
                                flex:1,
                                child: Container()),
                          ],
                        ),
                        if(Responsive.isMobile(context))
                         SizedBox(height: 30,),
                        if(Responsive.isMobile(context))
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child:timeTextBox(),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                  flex:1,
                                  child: Container()),
                            ],
                          ),
                        SizedBox(height:10,),
                        description(),
                        ]
                    ),
                  ),
              ],
            ),
          );
        }
      ),
    );
  }
Widget countTextBox(){
    return BlocBuilder<AutomateCubit,AutomateState>(
      builder:(context,state){
        return TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: TextFieldColour,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(TextBoxRadius)),
            ),
            hintText: 'Count',
          ),
          controller: state.formCount,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (text) {
            if (text!.isEmpty) {
              return 'Cannot be empty';
            }
          },
        );
      },
    );
}
Widget timeTextBox(){
    return BlocBuilder<AutomateCubit,AutomateState>(
      builder:(context,state){
        return TextFormField(
          maxLines: 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: TextFieldColour,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                  Radius.circular(TextBoxRadius)),
            ),
            hintText: 'Time Interval in seconds',
          ),
          controller: state.formTime,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (text) {
            if (text!.isEmpty) {
              return 'Cannot be empty';
            }
          },
        );
      },
    );
}
Widget description(){
    return   Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      color: primaryColor,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("For integer/double values : \$d\$decimalPoints\$minumumValue\$maximumValue\$ (Eg\: \$d\$2\$50\$100\$)",style:TextStyle(color:Colors.black),),
          SizedBox(height:5,),
          Text("For string/boolean values : \$s\${value1,value2...}\$ (Eg: \$s\${true,false}\$)",style:TextStyle(color:Colors.black)),
        ],
      ),
    );
}
}

