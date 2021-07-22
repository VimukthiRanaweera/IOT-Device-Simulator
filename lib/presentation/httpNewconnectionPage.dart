
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HttpNewConectionPage extends StatefulWidget {
  // const HttpNewConectionPage({Key key}) : super(key: key);

  @override
  _HttpNewConectionPageState createState() => _HttpNewConectionPageState();
}

class _HttpNewConectionPageState extends State<HttpNewConectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTTP New Connection'),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal:100,vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
                style:ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                ),
                onPressed: (){

                },
                child:Text('New Connection')
            ),
            SizedBox(height: 40,),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                border:OutlineInputBorder(
                  borderSide:BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Connection Name',
              ),
            ),
            SizedBox(height: 40,),
            Row(
              children: [
                Expanded(
                    child:TextField(

                      decoration: InputDecoration(
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
                        padding: EdgeInsets.symmetric(horizontal:30,vertical:20)
                    ),
                    onPressed: (){

                    },
                    child:Text('Generate ID')
                ),
              ],
            ),
            SizedBox(height: 40,),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                border:OutlineInputBorder(
                  borderSide:BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Server',
              ),
            ),
            SizedBox(height: 40,),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                border:OutlineInputBorder(
                  borderSide:BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Port',
              ),
            ),
            SizedBox(height: 40,),
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
      ),
    );
  }
}
