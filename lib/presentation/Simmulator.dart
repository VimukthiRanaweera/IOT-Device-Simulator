import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Responsive.dart';
import 'body.dart';
import 'component/drawerConList.dart';


class Simulator extends StatelessWidget {
  const Simulator() : super();

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(Responsive.isDesktop(context))
              Expanded(
                child: drawerConList(),
              ),
            Expanded(
                flex: 4,
                child:PageBody()

            ),
          ],
        ),
      );
  }
}
