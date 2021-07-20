import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WindowMqttNewConnection extends StatefulWidget {
  // const WindowMqttNewConnection({Key key}) : super(key: key);

  @override
  _WindowMqttNewConnectionState createState() => _WindowMqttNewConnectionState();
}

class _WindowMqttNewConnectionState extends State<WindowMqttNewConnection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 80,vertical:60),
      child: Column(
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
              Expanded(flex:3,child:SizedBox(width: 10,))
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: [
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
                    hintText: 'Broker Address',

                  ),
                ),
              ),
              SizedBox(width: 60,),
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
                    hintText: 'Port',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: [
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
                    hintText: 'Username',

                  ),
                ),
              ),
              SizedBox(width: 60,),
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
                    hintText: 'Password',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: [
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
                    hintText: 'Keep Alive',

                  ),
                ),
              ),
              SizedBox(width: 60,),
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
                    hintText: 'Connection Timeout',
                  ),
                ),
              ),
            ],
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
        ],
      ),
    );
  }
}
