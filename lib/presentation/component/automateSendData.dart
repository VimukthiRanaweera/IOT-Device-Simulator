import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      padding: EdgeInsets.only(left:50,right: 40),
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
                  SizedBox(height:157,),
                if(state.isChecked)
                  SizedBox(height: 25,),
                if(state.isChecked)
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
                if(state.isChecked)
                  SizedBox(height: 25,),
                if(state.isChecked)
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
                      SizedBox(width: 20,),
                      Text('Seconds'),

                    ],
                  ),
                SizedBox(height: 45,),
              ],
            ),
          );
        }
      ),
    );
  }
}
