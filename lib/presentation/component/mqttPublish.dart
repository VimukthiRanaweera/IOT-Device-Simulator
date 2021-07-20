import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MqttPublish extends StatefulWidget {
  // const MqttPublish({Key key}) : super(key: key);

  @override
  _MqttPublishState createState() => _MqttPublishState();
}

class _MqttPublishState extends State<MqttPublish> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
    Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
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
         SizedBox(height: 40,),
            TextField(
              maxLines: 2,
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
         SizedBox(height:20),
         ElevatedButton(
           style:ElevatedButton.styleFrom(
              padding:EdgeInsets.symmetric(horizontal:30,vertical:20)
           ),
             onPressed: (){},
             child:Text('Publish')
         ),
       ],
      ),
    ),
        Container(

        ),
     ]
    );
  }
}
