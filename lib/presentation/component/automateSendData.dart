import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';

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
      padding: EdgeInsets.only(left:30,right:10),
      child: BlocBuilder<AutomateCubit,AutomateState>(
        builder:(context,state) {
          return Form(
            key: state.formKey,
            child: Column(
              children: [
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
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
                              ),
                            ),
                            Expanded(
                                flex:1,
                                child: Container()),
                          ],
                        ),
                         SizedBox(height: 15,),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: TextFieldColour,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(TextBoxRadius)),
                                    ),
                                    hintText: 'Time Interval',
                                  ),
                                  controller: state.formTime,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return 'Cannot be empty';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 5,),
                              Text('Seconds',style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold)),
                            ],
                          ),
                        SizedBox(height:10,),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.topLeft,
                          color: primaryColor,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("for integer/double values",style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold),),
                              Text("\$d\$decimalPoints\$minumumValue\$maximumValue\$"),
                              Text("ex\: \$d\$2\$50\$100\$"),
                              SizedBox(height:5,),
                              Text("for string/boolean values",style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold)),
                              Text("ex\: \$s\${value1,value2...}\$"),
                            ],
                          ),
                        )

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


}

