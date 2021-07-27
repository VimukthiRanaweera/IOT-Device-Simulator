import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_device_simulator/Route/appRoute.dart';
import 'package:iot_device_simulator/logic/connectionCubit.dart';
import 'package:iot_device_simulator/logic/protocolCubit.dart';
import 'package:iot_device_simulator/constants/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter=AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:[
          BlocProvider(
              create:(context)=>ProtocolCubit(),
          ),
          BlocProvider(
              create:(context) =>ConnectionCubit(),
          )
        ],

      child: MaterialApp(
        onGenerateRoute: _appRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light().copyWith(
          appBarTheme:AppBarTheme(backgroundColor:appbarColor),
          canvasColor:primaryColor,
          backgroundColor: bgColor,
          elevatedButtonTheme:ElevatedButtonThemeData(
            style:ElevatedButton.styleFrom(
              primary:buttonColor,

            )
          ),
          visualDensity:VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}


