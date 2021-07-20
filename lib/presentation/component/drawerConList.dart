import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/constants/constants.dart';

class drawerConList extends StatefulWidget {
  // const drawerConList({Key key}) : super(key: key);

  @override
  _drawerConListState createState() => _drawerConListState();
}

class _drawerConListState extends State<drawerConList> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40.0),
            DrawerHeader(
                child: Text("Connections",
                    style:TextStyle(color: Colors.white,fontSize:20,)
                )
            ),
            Card(
              child: ListTile(
                tileColor: secondaryColor ,
                title:Text('Connection 1',),
                trailing: IconButton(
                  icon:Icon(Icons.settings),
                  onPressed: () { print('in the icon');
                  },
                ),
                onTap: (){
                  print('In the list item');
                },
              ),
            ),
            Card(
              child: ListTile(
                tileColor: secondaryColor ,
                title:Text('Connection 2',),
                trailing: IconButton(
                  icon:Icon(Icons.settings),

                  onPressed: () { print('in the icon');
                  },
                ),
                onTap: (){
                  print('In the list item');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
