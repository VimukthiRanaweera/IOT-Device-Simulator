import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobileNewMqttConnection extends StatefulWidget {
  // const MobileNewMqttConnection({Key key}) : super(key: key);

  @override
  _MobileNewMqttConnectionState createState() => _MobileNewMqttConnectionState();
}

class _MobileNewMqttConnectionState extends State<MobileNewMqttConnection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(30),
      child:Column(
        children: [
          Container(
            alignment:Alignment.topRight,
            child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                ),
                onPressed: (){

                },
                child:Text('New Connection')
            ),
          ),
          SizedBox(height: 50,),
          TextField(
            decoration: InputDecoration(
              hintMaxLines: 1,
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Connection Name',
            ),
          ),
          SizedBox(height: 30,),
      Row(
        mainAxisAlignment:MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: TextField(
              decoration: InputDecoration(
                hintMaxLines: 1,
                filled: true,
                fillColor: Colors.black26,
                border:OutlineInputBorder(
                  borderSide:BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Client ID',

              ),
            ),
          ),
          SizedBox(width: 30,),
          ElevatedButton(
              style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal:20,vertical:20)
              ),
              onPressed: (){

              },
              child:Text('Generate ID')
          ),
        ],
      ),
          SizedBox(height: 30,),
          TextField(
            decoration: InputDecoration(
              hintMaxLines: 1,
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Broker Address',

            ),
          ),
          SizedBox(height: 30,),
          TextField(
            decoration: InputDecoration(
              hintMaxLines: 1,
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Port',
            ),
          ),
          SizedBox(height: 30,),
          TextField(
            decoration: InputDecoration(
              hintMaxLines: 1,
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Username',

            ),
          ),
          SizedBox(height: 30,),
          TextField(
            decoration: InputDecoration(
              hintMaxLines: 1,
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Password',
            ),
          ),
          SizedBox(height: 30,),
          TextField(
            decoration: InputDecoration(
              hintMaxLines: 1,
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Keep Alive',

            ),
          ),
          SizedBox(height: 30,),
          TextField(
            decoration: InputDecoration(
              hintMaxLines: 1,
              filled: true,
              fillColor: Colors.black26,
              border:OutlineInputBorder(
                borderSide:BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Connection Timeout',
            ),
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              ElevatedButton(
                  style:ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                  ),
                  onPressed: (){

                  },
                  child:Text('Delete')
              ),
              Spacer(),
              ElevatedButton(
                  style:ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                  ),
                  onPressed: (){

                  },
                  child:Text('Cancel')
              ),
              SizedBox(width:40,),
              ElevatedButton(
                  style:ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                  ),
                  onPressed: (){

                  },
                  child:Text('Save')
              ),

            ],
          )
     ]
      )
    );
  }
}
