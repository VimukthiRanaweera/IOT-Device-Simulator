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
  bool isChecked=false;
  @override
  Widget build(BuildContext context) {

    return Container(
      alignment:Alignment.topCenter,
      padding: EdgeInsets.only(left:10,right:10),
      child: BlocBuilder<AutomateCubit,AutomateState>(
        builder:(context,state) {
          return Form(
            key: state.formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Auto'),
                    SizedBox(width: 30,),
                    Checkbox(
                      checkColor: Colors.white,
                      // fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: state.isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          state.isChecked = value!;
                          // BlocProvider.of<AutomateCubit>(context).checkBox(
                          //     isChecked);
                        });
                      },
                    ),
                  ],
                ),
                if(!state.isChecked)
                  SizedBox(height:170,),
                if(state.isChecked)
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black26,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                         SizedBox(height: 15,),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.black26,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
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

