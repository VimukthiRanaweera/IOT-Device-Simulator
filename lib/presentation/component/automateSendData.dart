import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutomateSendData extends StatefulWidget {
  // const AutomateSendData({Key key}) : super(key: key);
  
  @override
  _AutomateSendDataState createState() => _AutomateSendDataState();
}

class _AutomateSendDataState extends State<AutomateSendData> {
  bool isChecked=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.end,
        children: [
        Row(
          children: [
            Text('Auto'),
            SizedBox(width: 30,),
            Checkbox(
            checkColor: Colors.white,
            // fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
             },
            ),
          ],
        ),
          SizedBox(height: 30,),
          TextField(
            maxLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Variable Name',
            ),
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              Expanded(
                  child:TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black26,
                      border:OutlineInputBorder(
                        borderSide:BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Time Interval',
                    ),
                  ),
              ),
              SizedBox(width: 20,),
              Text('Seconds'),
            ],
          ),
          SizedBox(height: 30,),
          ElevatedButton(
              style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric()
              ),
              onPressed: (){

              },
              child:Text('OK')
          ),
        ],
      ),
    );
  }
}
