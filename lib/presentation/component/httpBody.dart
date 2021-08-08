import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';

class HttpBody extends StatefulWidget {
  // const HttpBody({Key key}) : super(key: key);

  @override
  _HttpBodyState createState() => _HttpBodyState();
}

class _HttpBodyState extends State<HttpBody> {

  @override
  Widget build(BuildContext context) {
    String dropdownValueHttp='POST';
    return Container(
      padding: EdgeInsets.only(top:80,left:30,right:30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              DropdownButton<String>(
                value:dropdownValueHttp,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValueHttp = newValue!;
                  });
                },
                items:<String>['POST'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 20,),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintMaxLines: 1,
                    filled: true,
                    fillColor: Colors.black26,
                    border:OutlineInputBorder(
                      borderSide:BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'URL',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 60,),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Message',
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(
              style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
              ),
              onPressed: (){

              },
              child:Text('Send')
          ),

        ],
      ),
    );
  }
}
