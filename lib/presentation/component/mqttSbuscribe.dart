import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MqttSubscribe extends StatefulWidget {
  // const MqttSubscribe({Key key}) : super(key: key);

  @override
  _MqttSubscribeState createState() => _MqttSubscribeState();
}
TextEditingController topic =TextEditingController();
TextEditingController message = TextEditingController();
class _MqttSubscribeState extends State<MqttSubscribe> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
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
            controller: topic,
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
            controller: message,
          ),
        ],
      ),
    );
  }
}
