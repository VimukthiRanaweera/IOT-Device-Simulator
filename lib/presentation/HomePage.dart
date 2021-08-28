import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/presentation/ApiAutomation.dart';
import 'package:iot_device_simulator/presentation/Responsive.dart';

import 'Simmulator.dart';
import 'body.dart';
import 'component/drawerConList.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
List<bool> isSelected =[true,false];
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Responsive.isDesktop(context)?null:drawerConList(),
      appBar:AppBar(
        title: !Responsive.isMobile(context)||Responsive.isTablet(context)?Text("Dialog Iot Simulator",):Text("Dialog Iot \nSimulator",style:TextStyle(fontSize:17),),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 0),
            child: ToggleButtons(
              // fillColor:secondaryColor ,
              // highlightColor:secondaryColor ,
              borderWidth: 1,
              color: Colors.white70,
              fillColor:primaryColor,
              borderRadius:BorderRadius.all(Radius.circular(5)),
              selectedBorderColor: Colors.white38,
              borderColor: Colors.white38,
              selectedColor: Colors.black,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:5,horizontal:15),
                  child: Text('Simulator',style: TextStyle(fontWeight:FontWeight.w600),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:5,horizontal: 25),
                  child: Text('API',style: TextStyle(fontWeight:FontWeight.w600)),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });

              },
              isSelected: isSelected,
              // fillColor:appbarColor,

            ),
          ),

        ],
      ),
      body:(isSelected[0])?Simulator():ApiAitomation(),

    );
  }
}
