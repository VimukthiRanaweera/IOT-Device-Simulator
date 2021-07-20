import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MqttSubscribe extends StatefulWidget {
  // const MqttSubscribe({Key key}) : super(key: key);

  @override
  _MqttSubscribeState createState() => _MqttSubscribeState();
}

class _MqttSubscribeState extends State<MqttSubscribe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.end,
        children: [
          TextField(
            decoration: InputDecoration(
              hintMaxLines: 2,
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Topic',

            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              style:ElevatedButton.styleFrom(
                  padding:EdgeInsets.symmetric(horizontal:30,vertical:20)
              ),
              onPressed: (){},
              child:Text('Subscribe')
          ),
          SizedBox(height: 40,),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                border:OutlineInputBorder(
                  borderSide:BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Message'
            ),
          ),
        ],
      ),
    );
  }
}
